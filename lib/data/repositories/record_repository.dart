import 'package:sqflite/sqflite.dart';

import '../models/vehicle_record.dart';

class RecordRepository {
  RecordRepository(this._db);

  final Database _db;

  Future<List<VehicleRecord>> listForVehicle(String vehicleId) async {
    final rows = await _db.query(
      'records',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
      orderBy: 'event_date DESC, created_at DESC',
    );
    return rows.map(VehicleRecord.fromMap).toList();
  }

  Future<VehicleRecord?> getById(String id) async {
    final rows = await _db.query('records', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : VehicleRecord.fromMap(rows.first);
  }

  Future<void> insert(VehicleRecord record) async {
    await _db.insert('records', record.toMap());
  }

  Future<void> update(VehicleRecord record) async {
    await _db.update(
      'records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<void> delete(String id) async {
    await _db.delete('records', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countForVehicle(String vehicleId) async {
    final value = Sqflite.firstIntValue(
      await _db.rawQuery('SELECT COUNT(*) FROM records WHERE vehicle_id = ?', [
        vehicleId,
      ]),
    );
    return value ?? 0;
  }

  Future<List<VehicleRecord>> recentForOwner(
    String ownerId, {
    int limit = 5,
  }) async {
    final rows = await _db.rawQuery(
      '''
      SELECT r.* FROM records r
      JOIN vehicles v ON v.id = r.vehicle_id
      WHERE v.owner_id = ?
      ORDER BY r.event_date DESC, r.created_at DESC
      LIMIT ?
      ''',
      [ownerId, limit],
    );
    return rows.map(VehicleRecord.fromMap).toList();
  }
}
