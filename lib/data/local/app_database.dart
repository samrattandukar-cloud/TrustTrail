import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'schema.dart';

class AppDatabase {
  AppDatabase._(this.db);

  final Database db;

  static const int version = 1;
  static const String fileName = 'trusttrail.db';

  static Future<AppDatabase> open() async {
    final directory = await getDatabasesPath();
    final database = await openDatabase(
      p.join(directory, fileName),
      version: version,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) => createSchema(db),
    );
    return AppDatabase._(database);
  }

  /// Deletes every row but keeps the schema; used by "reset demo data".
  Future<void> wipe() async {
    await db.transaction((txn) async {
      for (final table in const [
        'app_events',
        'sus_responses',
        'saved_reports',
        'report_snapshots',
        'evidence',
        'reminders',
        'records',
        'vehicles',
        'users',
      ]) {
        await txn.delete(table);
      }
    });
  }

  Future<void> close() => db.close();
}

final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);
