import 'package:flutter_test/flutter_test.dart';
import 'package:trusttrail/domain/integrity_chain.dart';

Map<String, Object?> _record({
  required String id,
  required String date,
  int odometerKm = 12000,
  int costNpr = 3500,
  List<Map<String, Object?>> evidence = const [],
}) => {
  'id': id,
  'vehicle_id': 'veh-1',
  'category': 'service',
  'title': 'Periodic service',
  'description': 'Oil and filter change',
  'event_date': date,
  'odometer_km': odometerKm,
  'workshop': 'Lalitpur Auto Care',
  'cost_npr': costNpr,
  'document_no': 'INV-101',
  'source': 'ownerRecorded',
  'evidence': evidence,
};

void main() {
  test('produces a deterministic chain regardless of input record order', () {
    final recA = _record(id: 'r1', date: '2026-01-10', odometerKm: 10000);
    final recB = _record(id: 'r2', date: '2026-06-15', odometerKm: 14500);

    final forward = buildIntegrityChain([recA, recB]);
    final reversed = buildIntegrityChain([recB, recA]);

    expect(forward.algorithm, 'SHA-256');
    expect(forward.entryCount, 2);
    expect(forward.rootHash, hasLength(64));
    expect(forward.rootHash, reversed.rootHash);
    expect(forward.entries.first.previousHash, integrityGenesisHash);
    expect(forward.entries.last.previousHash, forward.entries.first.entryHash);
  });

  test('verifies an untampered payload as intact', () {
    final records = [
      _record(
        id: 'r1',
        date: '2026-02-01',
        evidence: [
          {
            'id': 'ev1',
            'kind': 'receipt',
            'label': 'VAT Bill',
            'mime': 'image/jpeg',
            'size_bytes': 124000,
            'created_at': '2026-02-01T10:00:00.000Z',
          },
        ],
      ),
    ];
    final chain = buildIntegrityChain(records);
    final payload = <String, Object?>{
      'records': records,
      'integrity': chain.toMap(),
    };

    final result = verifyPayloadIntegrity(payload);
    expect(result, isNotNull);
    expect(result!.intact, isTrue);
    expect(result.entryCount, 1);
    expect(result.storedRootHash, chain.rootHash);
  });

  test('detects tampering when odometer or evidence metadata is modified', () {
    final records = [
      _record(id: 'r1', date: '2026-02-01', odometerKm: 28000),
      _record(id: 'r2', date: '2026-08-01', odometerKm: 34200),
    ];
    final chain = buildIntegrityChain(records);

    final tamperedRecords = [
      _record(id: 'r1', date: '2026-02-01', odometerKm: 28000),
      _record(id: 'r2', date: '2026-08-01', odometerKm: 29200),
    ];
    final payload = <String, Object?>{
      'records': tamperedRecords,
      'integrity': chain.toMap(),
    };

    final result = verifyPayloadIntegrity(payload);
    expect(result, isNotNull);
    expect(result!.intact, isFalse);
    expect(result.computedRootHash, isNot(result.storedRootHash));
  });

  test('handles empty record lists cleanly', () {
    final chain = buildIntegrityChain(const []);
    expect(chain.entryCount, 0);
    expect(chain.rootHash, hasLength(64));

    final verification = verifyPayloadIntegrity({
      'records': const <Map<String, Object?>>[],
      'integrity': chain.toMap(),
    });
    expect(verification?.intact, isTrue);
    expect(verification?.entryCount, 0);
  });

  test('returns null for legacy snapshots without an integrity block', () {
    final verification = verifyPayloadIntegrity({
      'records': [_record(id: 'r1', date: '2026-02-01')],
    });
    expect(verification, isNull);
  });
}
