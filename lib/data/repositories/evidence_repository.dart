import 'package:sqflite/sqflite.dart';

import '../models/evidence.dart';

class EvidenceRepository {
  EvidenceRepository(this._db);

  final Database _db;

  Future<List<Evidence>> listForRecord(String recordId) async {
    final rows = await _db.query(
      'evidence',
      where: 'record_id = ?',
      whereArgs: [recordId],
      orderBy: 'created_at ASC',
    );
    return rows.map(Evidence.fromMap).toList();
  }

  Future<List<Evidence>> listForVehicle(String vehicleId) async {
    final rows = await _db.rawQuery(
      '''
      SELECT e.* FROM evidence e
      JOIN records r ON r.id = e.record_id
      WHERE r.vehicle_id = ?
      ORDER BY e.created_at ASC
      ''',
      [vehicleId],
    );
    return rows.map(Evidence.fromMap).toList();
  }

  Future<void> insert(Evidence evidence) async {
    await _db.insert('evidence', evidence.toMap());
  }

  Future<void> delete(String id) async {
    await _db.delete('evidence', where: 'id = ?', whereArgs: [id]);
  }

  Future<({int count, int bytes})> usage() async {
    final rows = await _db.rawQuery(
      'SELECT COUNT(*) AS n, COALESCE(SUM(size_bytes), 0) AS bytes FROM evidence',
    );
    final row = rows.first;
    return (count: row['n'] as int? ?? 0, bytes: row['bytes'] as int? ?? 0);
  }
}
