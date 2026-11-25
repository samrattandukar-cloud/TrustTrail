import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

/// Lightweight task timings for the usability evaluation; stays on device.
class EventRepository {
  EventRepository(this._db);

  final Database _db;

  Future<void> log(String type, [Map<String, Object?>? meta]) async {
    await _db.insert('app_events', {
      'id': const Uuid().v4(),
      'type': type,
      'at': DateTime.now().toIso8601String(),
      'meta_json': meta == null ? null : jsonEncode(meta),
    });
  }

  Future<List<Map<String, Object?>>> recent({int limit = 50}) async {
    return _db.query('app_events', orderBy: 'at DESC', limit: limit);
  }

  Future<List<Map<String, Object?>>> listAll() async {
    return _db.query('app_events', orderBy: 'at ASC');
  }

  Future<int> count() async {
    final value = Sqflite.firstIntValue(
      await _db.rawQuery('SELECT COUNT(*) FROM app_events'),
    );
    return value ?? 0;
  }
}
