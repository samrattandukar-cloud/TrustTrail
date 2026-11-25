import 'package:sqflite/sqflite.dart';

import '../../domain/backup_codec.dart';

/// Exports and restores local SQLite records as a JSON file with a SHA-256
/// checksum. Evidence file paths are stored in the database.
class BackupRepository {
  BackupRepository(this._db);

  final Database _db;

  Future<BackupCounts> summary() async {
    final vehicles =
        Sqflite.firstIntValue(
          await _db.rawQuery('SELECT COUNT(*) FROM vehicles'),
        ) ??
        0;
    final records =
        Sqflite.firstIntValue(
          await _db.rawQuery('SELECT COUNT(*) FROM records'),
        ) ??
        0;
    final reminders =
        Sqflite.firstIntValue(
          await _db.rawQuery('SELECT COUNT(*) FROM reminders'),
        ) ??
        0;
    return BackupCounts(
      vehicles: vehicles,
      records: records,
      reminders: reminders,
    );
  }

  Future<({String json, BackupCounts counts})> exportArchive({
    DateTime? exportedAt,
  }) async {
    final tables = await _db.transaction((txn) async {
      return {
        for (final table in backupTableOrder) table: await txn.query(table),
      };
    });
    final json = encodeBackupArchive(
      tables: tables,
      exportedAt: exportedAt ?? DateTime.now(),
    );
    return (
      json: json,
      counts: BackupCounts(
        vehicles: tables['vehicles']?.length ?? 0,
        records: tables['records']?.length ?? 0,
        reminders: tables['reminders']?.length ?? 0,
      ),
    );
  }

  Future<BackupCounts> restoreArchive(String rawJson) async {
    final decoded = decodeBackupArchive(rawJson);
    await _db.transaction((txn) async {
      for (final table in backupTableOrder.reversed) {
        await txn.delete(table);
      }
      for (final table in backupTableOrder) {
        for (final row in decoded.tables[table]!) {
          await txn.insert(
            table,
            row,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    });
    return decoded.counts;
  }
}
