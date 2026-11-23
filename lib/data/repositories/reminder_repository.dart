import 'package:sqflite/sqflite.dart';

import '../models/reminder.dart';

class ReminderRepository {
  ReminderRepository(this._db);

  final Database _db;

  Future<List<Reminder>> listAll() async {
    final rows = await _db.query('reminders', orderBy: 'due_date ASC');
    return rows.map(Reminder.fromMap).toList();
  }

  Future<List<Reminder>> listForVehicle(String vehicleId) async {
    final rows = await _db.query(
      'reminders',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
      orderBy: 'due_date ASC',
    );
    return rows.map(Reminder.fromMap).toList();
  }

  Future<void> insert(Reminder reminder) async {
    await _db.insert('reminders', reminder.toMap());
  }

  Future<void> update(Reminder reminder) async {
    await _db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<void> setState(String id, ReminderState state) async {
    await _db.update(
      'reminders',
      {'status': state.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(String id) async {
    await _db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }
}
