import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trusttrail/domain/backup_codec.dart';

Map<String, List<Map<String, Object?>>> _sampleTables() => {
  'users': [
    {
      'id': 'u1',
      'name': 'Sujan Bajracharya',
      'phone': '+977 9801234567',
      'email': null,
      'role': 'owner',
      'locale': 'en',
      'is_demo': 0,
      'created_at': '2026-11-25T10:00:00.000Z',
    },
  ],
  'vehicles': [
    {
      'id': 'v1',
      'owner_id': 'u1',
      'make': 'Honda',
      'model': 'Shine 125',
      'year_ad': 2022,
      'plate_roman': 'BA 2 PA 1234',
      'plate_devanagari': 'बा २ प १२३४',
      'province': 'Bagmati',
      'fuel': 'petrol',
      'transmission': 'manual',
      'color': 'Black',
      'chassis_masked': null,
      'engine_masked': null,
      'initial_odometer': 0,
      'photo_asset': null,
      'created_at': '2026-11-25T10:00:00.000Z',
      'is_seed': 0,
    },
  ],
  'records': [],
  'evidence': [],
  'reminders': [],
  'report_snapshots': [],
  'saved_reports': [],
  'sus_responses': [],
  'app_events': [],
};

void main() {
  test('encodes and decodes a valid SHA-256 signed backup archive', () {
    final encoded = encodeBackupArchive(
      tables: _sampleTables(),
      exportedAt: DateTime.utc(2026, 11, 25, 12, 30),
    );

    final decoded = decodeBackupArchive(encoded);
    expect(decoded.formatVersion, backupFormatVersion);
    expect(decoded.exportedAt, DateTime.utc(2026, 11, 25, 12, 30));
    expect(decoded.checksum, hasLength(64));
    expect(decoded.counts.vehicles, 1);
    expect(decoded.counts.records, 0);
    expect(decoded.tables['users']!.single['name'], 'Sujan Bajracharya');
  });

  test('rejects a backup whose contents were tampered after export', () {
    final encoded = encodeBackupArchive(
      tables: _sampleTables(),
      exportedAt: DateTime.utc(2026, 11, 25),
    );
    final tampered = encoded.replaceFirst('Shine 125', 'CB Hornet');

    expect(
      () => decodeBackupArchive(tampered),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects malformed JSON and missing tables', () {
    expect(
      () => decodeBackupArchive('not json'),
      throwsA(isA<FormatException>()),
    );
    final incomplete = jsonEncode({
      'app': 'TrustTrail',
      'formatVersion': 1,
      'exportedAt': '2026-11-25T00:00:00.000Z',
      'checksum': 'abc',
      'tables': {'users': []},
    });
    expect(
      () => decodeBackupArchive(incomplete),
      throwsA(isA<FormatException>()),
    );
  });
}
