import '../data/local/app_database.dart';
import '../data/local/seed/seed_data.dart';

/// Opens the local database and guarantees the deterministic demo content.
Future<AppDatabase> bootstrapDatabase() async {
  final database = await AppDatabase.open();
  await DemoSeeder.seedIfEmpty(database.db);
  return database;
}

/// Settings → demo reset. Clears every table, then reseeds.
Future<void> resetDemoData(AppDatabase database) async {
  await database.wipe();
  await DemoSeeder.seed(database.db);
}
