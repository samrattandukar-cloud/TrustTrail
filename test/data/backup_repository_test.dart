import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:trusttrail/data/local/schema.dart';
import 'package:trusttrail/data/local/seed/seed_data.dart';
import 'package:trusttrail/data/repositories/backup_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Database db;
  late BackupRepository backup;

  setUp(() async {
    sqfliteFfiInit();
    db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onConfigure: (database) => database.execute('PRAGMA foreign_keys = ON'),
        onCreate: (database, version) => createSchema(database),
      ),
    );
    await DemoSeeder.seed(db);
    backup = BackupRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('exports and restores the full SQLite database losslessly', () async {
    final before = await backup.summary();
    expect(before.vehicles, greaterThan(0));
    expect(before.records, greaterThan(0));

    final exported = await backup.exportArchive(
      exportedAt: DateTime.utc(2026, 11, 25, 14),
    );
    expect(exported.counts.vehicles, before.vehicles);
    expect(exported.counts.records, before.records);

    await db.delete('records');
    await db.delete('vehicles');
    final wiped = await backup.summary();
    expect(wiped.vehicles, 0);
    expect(wiped.records, 0);

    final restored = await backup.restoreArchive(exported.json);
    expect(restored.vehicles, before.vehicles);
    expect(restored.records, before.records);
    expect(restored.reminders, before.reminders);

    final after = await backup.summary();
    expect(after.vehicles, before.vehicles);
    expect(after.records, before.records);
    expect(after.reminders, before.reminders);
  });
}
