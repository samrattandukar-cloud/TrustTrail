import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Pure-Dart SHA-256 hash chain over a vehicle's frozen records and evidence.
///
/// Each entry hashes its own canonical fields together with the previous
/// entry's hash, producing a single root fingerprint stored inside a report
/// snapshot. Re-running [verifyPayloadIntegrity] on a buyer snapshot confirms
/// whether any record or evidence metadata was altered after snapshot creation.
///
/// This verifies internal snapshot integrity only; it does not verify claims
/// against any government registry or third party.
const String integrityGenesisHash = 'trusttrail:v1:genesis';

class IntegrityEntry {
  const IntegrityEntry({
    required this.recordId,
    required this.previousHash,
    required this.entryHash,
    required this.evidenceCount,
  });

  final String recordId;
  final String previousHash;
  final String entryHash;
  final int evidenceCount;

  Map<String, Object?> toMap() => {
    'recordId': recordId,
    'previousHash': previousHash,
    'entryHash': entryHash,
    'evidenceCount': evidenceCount,
  };
}

class IntegrityChain {
  const IntegrityChain({
    required this.algorithm,
    required this.rootHash,
    required this.entries,
  });

  final String algorithm;
  final String rootHash;
  final List<IntegrityEntry> entries;

  int get entryCount => entries.length;

  String get shortFingerprint {
    if (rootHash.length <= 14) return rootHash;
    return '${rootHash.substring(0, 8)}…${rootHash.substring(rootHash.length - 4)}';
  }

  Map<String, Object?> toMap() => {
    'algorithm': algorithm,
    'rootHash': rootHash,
    'entryCount': entryCount,
    'entries': [for (final entry in entries) entry.toMap()],
  };
}

class IntegrityVerification {
  const IntegrityVerification({
    required this.intact,
    required this.storedRootHash,
    required this.computedRootHash,
    required this.entryCount,
  });

  final bool intact;
  final String storedRootHash;
  final String computedRootHash;
  final int entryCount;

  String get shortFingerprint {
    if (storedRootHash.length <= 14) return storedRootHash;
    return '${storedRootHash.substring(0, 8)}…${storedRootHash.substring(storedRootHash.length - 4)}';
  }
}

/// Builds a deterministic SHA-256 hash chain over serialized record maps
/// (each optionally containing an `'evidence'` list).
IntegrityChain buildIntegrityChain(List<Map<String, Object?>> records) {
  final ordered = List<Map<String, Object?>>.from(records)
    ..sort((a, b) {
      final dateCmp = '${a['event_date'] ?? ''}'.compareTo(
        '${b['event_date'] ?? ''}',
      );
      if (dateCmp != 0) return dateCmp;
      return '${a['id'] ?? ''}'.compareTo('${b['id'] ?? ''}');
    });

  var previous = integrityGenesisHash;
  final entries = <IntegrityEntry>[];

  for (final record in ordered) {
    final evidenceList =
        (record['evidence'] as List? ?? const [])
            .whereType<Map<Object?, Object?>>()
            .map((item) => item.cast<String, Object?>())
            .toList()
          ..sort((a, b) => '${a['id'] ?? ''}'.compareTo('${b['id'] ?? ''}'));

    final canonical = jsonEncode({
      'prev': previous,
      'id': record['id'],
      'vehicle_id': record['vehicle_id'],
      'category': record['category'],
      'title': record['title'],
      'description': record['description'],
      'event_date': record['event_date'],
      'odometer_km': record['odometer_km'],
      'workshop': record['workshop'],
      'cost_npr': record['cost_npr'],
      'document_no': record['document_no'],
      'source': record['source'],
      'evidence': [
        for (final item in evidenceList)
          {
            'id': item['id'],
            'kind': item['kind'],
            'label': item['label'],
            'mime': item['mime'],
            'size_bytes': item['size_bytes'],
            'created_at': item['created_at'],
          },
      ],
    });

    final digest = _sha256Hex(canonical);
    entries.add(
      IntegrityEntry(
        recordId: '${record['id'] ?? ''}',
        previousHash: previous,
        entryHash: digest,
        evidenceCount: evidenceList.length,
      ),
    );
    previous = digest;
  }

  final rootHash = entries.isEmpty
      ? _sha256Hex('$integrityGenesisHash:empty')
      : previous;

  return IntegrityChain(
    algorithm: 'SHA-256',
    rootHash: rootHash,
    entries: entries,
  );
}

/// Verifies a frozen report payload's stored integrity chain.
///
/// Returns `null` for legacy snapshots created before integrity hashing was
/// enabled.
IntegrityVerification? verifyPayloadIntegrity(Map<String, Object?> payload) {
  final rawIntegrity = payload['integrity'];
  if (rawIntegrity is! Map) return null;
  final integrity = rawIntegrity.cast<String, Object?>();
  final storedRoot = integrity['rootHash'] as String?;
  if (storedRoot == null || storedRoot.isEmpty) return null;

  final records = (payload['records'] as List? ?? const [])
      .whereType<Map<Object?, Object?>>()
      .map((item) => item.cast<String, Object?>())
      .toList();

  final recomputed = buildIntegrityChain(records);
  return IntegrityVerification(
    intact: recomputed.rootHash == storedRoot,
    storedRootHash: storedRoot,
    computedRootHash: recomputed.rootHash,
    entryCount: recomputed.entryCount,
  );
}

String _sha256Hex(String input) {
  return sha256.convert(utf8.encode(input)).toString();
}
