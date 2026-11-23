import 'package:sqflite/sqflite.dart';

import '../models/sus_response.dart';

class FeedbackRepository {
  FeedbackRepository(this._db);

  final Database _db;

  Future<void> insert(SusResponse response) async {
    await _db.insert('sus_responses', response.toMap());
  }

  Future<List<SusResponse>> list() async {
    final rows = await _db.query('sus_responses', orderBy: 'created_at DESC');
    return rows.map(SusResponse.fromMap).toList();
  }

  Future<int> count() async {
    final value = Sqflite.firstIntValue(
      await _db.rawQuery('SELECT COUNT(*) FROM sus_responses'),
    );
    return value ?? 0;
  }
}
