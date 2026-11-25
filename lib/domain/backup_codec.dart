import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Ordered parent-to-child table list matching SQLite foreign-key constraints.
const List<String> backupTableOrder = [
  'users',
  'vehicles',
  'records',
  'evidence',
  'reminders',
  'report_snapshots',
  'saved_reports',
  'sus_responses',
  'app_events',
];

const int backupFormatVersion = 1;

class BackupCounts {
  const BackupCounts({
    required this.vehicles,
    required this.records,
    required this.reminders,
  });

  final int vehicles;
  final int records;
  final int reminders;
}

class DecodedBackup {
  const DecodedBackup({
    required this.formatVersion,
    required this.exportedAt,
    required this.checksum,
    required this.tables,
  });

  final int formatVersion;
  final DateTime exportedAt;
  final String checksum;
  final Map<String, List<Map<String, Object?>>> tables;

  BackupCounts get counts => BackupCounts(
    vehicles: tables['vehicles']?.length ?? 0,
    records: tables['records']?.length ?? 0,
    reminders: tables['reminders']?.length ?? 0,
  );
}

/// Serializes all local TrustTrail tables into a JSON archive with a SHA-256
/// checksum for the table data.
String encodeBackupArchive({
  required Map<String, List<Map<String, Object?>>> tables,
  required DateTime exportedAt,
}) {
  final normalized = <String, List<Map<String, Object?>>>{
    for (final name in backupTableOrder)
      name: [
        for (final row in tables[name] ?? const <Map<String, Object?>>[])
          Map<String, Object?>.from(row),
      ],
  };
  final tablesJson = jsonEncode(normalized);
  final checksum = sha256.convert(utf8.encode(tablesJson)).toString();

  final envelope = <String, Object?>{
    'app': 'TrustTrail',
    'formatVersion': backupFormatVersion,
    'exportedAt': exportedAt.toUtc().toIso8601String(),
    'checksum': checksum,
    'tables': normalized,
  };
  return const JsonEncoder.withIndent('  ').convert(envelope);
}

/// Validates and decodes a TrustTrail JSON backup archive.
///
/// Throws [FormatException] if the JSON is malformed, missing required tables,
/// or fails its SHA-256 checksum verification.
DecodedBackup decodeBackupArchive(String rawJson) {
  final Object? decoded;
  try {
    decoded = jsonDecode(rawJson);
  } catch (_) {
    throw const FormatException('Backup file is not valid JSON.');
  }
  if (decoded is! Map) {
    throw const FormatException('Backup root must be a JSON object.');
  }

  final map = decoded.cast<String, Object?>();
  if (map['app'] != 'TrustTrail') {
    throw const FormatException('Unrecognized backup source.');
  }
  final version = map['formatVersion'];
  if (version is! int || version != backupFormatVersion) {
    throw const FormatException('Unsupported backup format version.');
  }
  final exportedAtRaw = map['exportedAt'];
  final exportedAt = exportedAtRaw is String
      ? DateTime.tryParse(exportedAtRaw)
      : null;
  if (exportedAt == null) {
    throw const FormatException('Missing or invalid export timestamp.');
  }
  final storedChecksum = map['checksum'];
  if (storedChecksum is! String || storedChecksum.isEmpty) {
    throw const FormatException('Missing backup checksum.');
  }
  final rawTables = map['tables'];
  if (rawTables is! Map) {
    throw const FormatException('Missing tables payload.');
  }

  final tables = <String, List<Map<String, Object?>>>{};
  for (final name in backupTableOrder) {
    final rows = rawTables[name];
    if (rows is! List) {
      throw FormatException('Missing table "$name" in backup.');
    }
    tables[name] = [
      for (final row in rows)
        if (row is Map)
          row.cast<String, Object?>()
        else
          throw FormatException('Invalid row inside table "$name".'),
    ];
  }

  final computedChecksum = sha256
      .convert(utf8.encode(jsonEncode(tables)))
      .toString();
  if (computedChecksum != storedChecksum) {
    throw const FormatException('Backup checksum verification failed.');
  }

  return DecodedBackup(
    formatVersion: version,
    exportedAt: exportedAt,
    checksum: storedChecksum,
    tables: tables,
  );
}
