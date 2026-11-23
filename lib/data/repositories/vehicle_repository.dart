import 'package:sqflite/sqflite.dart';

import '../models/vehicle.dart';

class VehicleRepository {
  VehicleRepository(this._db);

  final Database _db;

  Future<List<Vehicle>> listByOwner(String ownerId) async {
    final rows = await _db.query(
      'vehicles',
      where: 'owner_id = ?',
      whereArgs: [ownerId],
      orderBy: 'created_at DESC',
    );
    return rows.map(Vehicle.fromMap).toList();
  }

  Future<Vehicle?> getById(String id) async {
    final rows = await _db.query('vehicles', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Vehicle.fromMap(rows.first);
  }

  Future<void> insert(Vehicle vehicle) async {
    await _db.insert('vehicles', vehicle.toMap());
  }

  Future<void> update(Vehicle vehicle) async {
    await _db.update(
      'vehicles',
      vehicle.toMap(),
      where: 'id = ?',
      whereArgs: [vehicle.id],
    );
  }

  Future<void> delete(String id) async {
    await _db.delete('vehicles', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countByOwner(String ownerId) async {
    final value = Sqflite.firstIntValue(
      await _db.rawQuery('SELECT COUNT(*) FROM vehicles WHERE owner_id = ?', [
        ownerId,
      ]),
    );
    return value ?? 0;
  }

  Future<Vehicle?> findByPlate(String plate) async {
    final normalized = plate
        .replaceAll(RegExp(r'[^A-Za-z0-9]'), '')
        .toUpperCase();
    final rows = await _db.query('vehicles');
    for (final row in rows) {
      final candidate = (row['plate_roman'] as String)
          .replaceAll(RegExp(r'[^A-Za-z0-9]'), '')
          .toUpperCase();
      if (candidate == normalized) return Vehicle.fromMap(row);
    }
    return null;
  }
}
