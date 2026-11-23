import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:trusttrail/data/local/schema.dart';
import 'package:trusttrail/data/local/seed/seed_data.dart';
import 'package:trusttrail/data/models/vehicle_record.dart';
import 'package:trusttrail/data/repositories/auth_repository.dart';
import 'package:trusttrail/data/repositories/evidence_repository.dart';
import 'package:trusttrail/data/repositories/insights.dart';
import 'package:trusttrail/data/repositories/record_repository.dart';
import 'package:trusttrail/data/repositories/report_repository.dart';
import 'package:trusttrail/data/repositories/vehicle_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Database db;
  late VehicleRepository vehicles;
  late RecordRepository records;
  late EvidenceRepository evidence;
  late ReportRepository reports;
  late AuthRepository auth;

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
    vehicles = VehicleRepository(db);
    records = RecordRepository(db);
    evidence = EvidenceRepository(db);
    reports = ReportRepository(db);
    auth = AuthRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('seeds a four-vehicle demo garage with frozen reports', () async {
    final ownerGarage = await vehicles.listByOwner(DemoSeeder.ownerId);
    expect(ownerGarage.map((v) => v.displayName), [
      'Honda Shine 125',
      'Hyundai Creta SX',
    ]);

    final shineRecords = await records.listForVehicle(DemoSeeder.shineId);
    expect(shineRecords.length, greaterThan(20));
    expect(shineRecords.first.category, RecordCategory.service);
    expect(shineRecords.first.eventDate, DateTime(2026, 11, 5));

    final allEvidence = await evidence.listForVehicle(DemoSeeder.shineId);
    expect(allEvidence.length, 10);
    expect(allEvidence.where((item) => item.isAsset), isNotEmpty);

    expect(await reports.getByToken(DemoSeeder.shineToken), isNotNull);
    expect(await reports.getByToken(DemoSeeder.fzsToken), isNotNull);
    expect(await reports.getByToken(DemoSeeder.grandToken), isNotNull);
  });

  test('Shine is 7/10 complete with a clean odometer series', () async {
    final vehicle = (await vehicles.getById(DemoSeeder.shineId))!;
    final vehicleRecords = await records.listForVehicle(vehicle.id);
    final vehicleEvidence = await evidence.listForVehicle(vehicle.id);

    final completeness = completenessFor(
      vehicle,
      vehicleRecords,
      vehicleEvidence,
    );
    expect(completeness.filled, 7);
    expect(completeness.percent, 70);
    expect(
      completeness.missing.map((section) => section.name),
      containsAll(['engineNumber', 'chassisNumber', 'photos']),
    );

    final odometer = odometerFor(vehicleRecords);
    expect(odometer.significantGaps, isEmpty);
    expect(odometer.hasDecrease, isFalse);
    expect(odometer.latestKm, 18240);
  });

  test('FZ-S report exposes a long gap and Grand i10 a decrease', () async {
    final fzsRecords = await records.listForVehicle(DemoSeeder.fzsId);
    final fzs = odometerFor(fzsRecords);
    expect(fzs.hasDecrease, isFalse);
    expect(fzs.significantGaps, isNotEmpty);
    final longest = fzs.significantGaps.reduce(
      (a, b) => a.days >= b.days ? a : b,
    );
    expect(longest.days, greaterThan(400));
    expect(longest.months, greaterThan(14));

    final grandRecords = await records.listForVehicle(DemoSeeder.grandId);
    final grand = odometerFor(grandRecords);
    expect(grand.hasDecrease, isTrue);
    expect(
      grand.flags.where((flag) => flag.issue.name == 'decrease'),
      isNotEmpty,
    );
  });

  test('buyer lookup resolves tokens, QR payloads and plates', () async {
    expect(
      (await reports.search('TT-SHIN-2026'))?.vehicle.plateRoman,
      'BA 2 PA 1234',
    );
    expect((await reports.search('SHIN2026'))?.vehicle.id, DemoSeeder.shineId);
    expect(
      (await reports.search('trusttrail://r/SHIN2026'))?.vehicle.id,
      DemoSeeder.shineId,
    );
    expect((await reports.search('TT-FZS-2026'))?.vehicle.id, DemoSeeder.fzsId);
    expect(
      (await reports.search('BA 99 PA 4521'))?.vehicle.id,
      DemoSeeder.fzsId,
    );
    expect((await reports.search('ba99pa4521'))?.vehicle.id, DemoSeeder.fzsId);
    expect(await reports.search('TT-NONE-0000'), isNull);
  });

  test('new reports freeze payloads and can be saved for comparison', () async {
    final vehicle = (await vehicles.getById(DemoSeeder.cretaId))!;
    final vehicleRecords = await records.listForVehicle(vehicle.id);
    final vehicleEvidence = await evidence.listForVehicle(vehicle.id);

    final snapshot = await reports.create(
      vehicle: vehicle,
      records: vehicleRecords,
      evidence: vehicleEvidence,
      includeCosts: false,
    );

    expect(snapshot.token, startsWith('TT-'));
    final match = await reports.search(snapshot.token);
    expect(match?.vehicle.id, DemoSeeder.cretaId);
    expect(match?.payload['includeCosts'], isFalse);
    expect((match?.payload['records'] as List).length, vehicleRecords.length);

    await reports.saveReport(snapshot.token);
    expect(await reports.isSaved(snapshot.token), isTrue);
    expect((await reports.savedReports()).single.token, snapshot.token);

    await reports.removeSaved(snapshot.token);
    expect(await reports.isSaved(snapshot.token), isFalse);
  });

  test('demo phone sign-in accepts local and +977 forms', () async {
    expect((await auth.findByPhone('9801234567'))?.id, DemoSeeder.ownerId);
    expect((await auth.findByPhone('+977 9801234567'))?.id, DemoSeeder.ownerId);
    expect((await auth.findByPhone('+9779801234567'))?.id, DemoSeeder.ownerId);
    expect(await auth.findByPhone('9800000001'), isNull);
  });

  test('deleting a record cascades to its evidence', () async {
    final before = await evidence.listForRecord('rec-shine-01');
    expect(before, isNotEmpty);

    await records.delete('rec-shine-01');

    expect(await evidence.listForRecord('rec-shine-01'), isEmpty);
  });
}
