import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/reminder_engine.dart';
import '../../models/evidence.dart';
import '../../models/reminder.dart';
import '../../models/report_snapshot.dart';
import '../../models/user.dart';
import '../../models/vehicle.dart';
import '../../models/vehicle_record.dart';
import '../../repositories/report_payload_builder.dart';

/// Deterministic demo data so a fresh install always has a garage, three
/// buyer-searchable reports and reminders to demonstrate. All people, plates,
/// workshops and documents are fictitious.
abstract final class DemoSeeder {
  static const ownerId = 'demo-owner';
  static const sellerId = 'demo-seller';
  static const buyerId = 'demo-buyer';
  static const shineId = 'veh-shine';
  static const cretaId = 'veh-creta';
  static const fzsId = 'veh-fzs';
  static const grandId = 'veh-grand';

  static const shineToken = 'TT-SHIN-2026';
  static const fzsToken = 'TT-FZS-2026';
  static const grandToken = 'TT-GRND-2026';
  static const demoTokens = [shineToken, fzsToken, grandToken];

  static const demoPhone = '+977 9801234567';
  static const demoOtp = '123456';

  static Future<void> seedIfEmpty(Database db) async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM users'),
    );
    if ((count ?? 0) > 0) return;
    await seed(db);
  }

  static Future<void> seed(Database db) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final seededAt = DateTime(2026, 11, 1, 9);
    final sharedAt = today.subtract(const Duration(days: 12));

    final shine = Vehicle(
      id: shineId,
      ownerId: ownerId,
      make: 'Honda',
      model: 'Shine 125',
      yearAd: 2021,
      plateRoman: 'BA 2 PA 1234',
      plateDevanagari: 'बा २ प १२३४',
      province: 'Bagmati',
      fuel: 'Petrol',
      transmission: 'Manual',
      color: 'Matte Black',
      initialOdometer: 0,
      photoAsset: 'assets/demo/vehicle_shine.png',
      createdAt: DateTime(2021, 6, 15),
      isSeed: true,
    );
    final creta = Vehicle(
      id: cretaId,
      ownerId: ownerId,
      make: 'Hyundai',
      model: 'Creta SX',
      yearAd: 2021,
      plateRoman: 'BA 5 CHA 7788',
      plateDevanagari: 'बा ५ च ७७८८',
      province: 'Bagmati',
      fuel: 'Diesel',
      transmission: 'Automatic',
      color: 'Polar White',
      chassisMasked: 'MALC381U**7742',
      engineMasked: 'D4FA**1188',
      initialOdometer: 12,
      photoAsset: 'assets/demo/vehicle_creta.png',
      createdAt: DateTime(2021, 2, 10),
      isSeed: true,
    );
    final fzs = Vehicle(
      id: fzsId,
      ownerId: sellerId,
      make: 'Yamaha',
      model: 'FZ-S FI',
      yearAd: 2019,
      plateRoman: 'BA 99 PA 4521',
      plateDevanagari: 'बा ९९ प ४५२१',
      province: 'Bagmati',
      fuel: 'Petrol',
      transmission: 'Manual',
      color: 'Matt Black',
      chassisMasked: 'ME1RG1**04521',
      engineMasked: 'G3J*20**9214',
      initialOdometer: 0,
      photoAsset: 'assets/demo/vehicle_fzs.png',
      createdAt: DateTime(2019, 3, 2),
      isSeed: true,
    );
    final grand = Vehicle(
      id: grandId,
      ownerId: sellerId,
      make: 'Hyundai',
      model: 'Grand i10',
      yearAd: 2018,
      plateRoman: 'BA 15 CHA 8902',
      plateDevanagari: 'बा १५ च ८९०२',
      province: 'Bagmati',
      fuel: 'Petrol',
      transmission: 'Manual',
      color: 'Silver',
      initialOdometer: 0,
      photoAsset: 'assets/demo/vehicle_grand.png',
      createdAt: DateTime(2018, 5, 20),
      isSeed: true,
    );

    final users = [
      User(
        id: ownerId,
        name: 'Sujan Bajracharya',
        phone: demoPhone,
        email: 'sujan.b@example.com',
        role: UserRole.owner,
        locale: 'en',
        isDemo: true,
        createdAt: DateTime(2021, 6, 1),
      ),
      User(
        id: sellerId,
        name: 'Bikash Shrestha',
        phone: '+977 9845678901',
        role: UserRole.owner,
        locale: 'en',
        isDemo: true,
        createdAt: DateTime(2019, 2, 1),
      ),
      User(
        id: buyerId,
        name: 'Anita Gurung',
        phone: '+977 9812345678',
        role: UserRole.buyer,
        locale: 'en',
        isDemo: true,
        createdAt: DateTime(2026, 1, 10),
      ),
    ];

    final shineRecords = _shineRecords(seededAt);
    final cretaRecords = _cretaRecords(seededAt);
    final fzsRecords = _fzsRecords(seededAt);
    final grandRecords = _grandRecords(seededAt);
    final evidence = [..._shineEvidence(), ..._fzsEvidence()];

    final reminders = <Reminder>[
      Reminder(
        id: 'rem-shine-insurance',
        vehicleId: shineId,
        type: ReminderType.insurance,
        title: 'Insurance renewal',
        dueDate: today.add(const Duration(days: 12)),
        notes: 'Shikhar Insurance · policy SHK/MC/2025/8821',
      ),
      Reminder(
        id: 'rem-shine-tax',
        vehicleId: shineId,
        type: ReminderType.roadTax,
        title: 'Road tax renewal',
        dueDate: today.subtract(const Duration(days: 4)),
        notes: 'Bagmati Province · renewal for 2083/84',
      ),
      Reminder(
        id: 'rem-shine-service',
        vehicleId: shineId,
        type: ReminderType.service,
        title: 'Service at 18,580 km',
        dueDate: today.add(const Duration(days: 45)),
        targetOdometer: 18580,
        notes: 'Next oil change from Sajha Auto Works',
      ),
      Reminder(
        id: 'rem-shine-pollution',
        vehicleId: shineId,
        type: ReminderType.pollution,
        title: 'Pollution test',
        dueDate: today.add(const Duration(days: 90)),
        notes: 'Bagmati Pollution Control · last test 20 Feb 2026',
      ),
      Reminder(
        id: 'rem-creta-insurance',
        vehicleId: cretaId,
        type: ReminderType.insurance,
        title: 'Insurance renewal',
        dueDate: today.add(const Duration(days: 40)),
      ),
      Reminder(
        id: 'rem-creta-service',
        vehicleId: cretaId,
        type: ReminderType.service,
        title: 'Service at 38,000 km',
        dueDate: today.add(const Duration(days: 200)),
        targetOdometer: 38000,
      ),
      Reminder(
        id: 'rem-creta-tax',
        vehicleId: cretaId,
        type: ReminderType.roadTax,
        title: 'Road tax 2082/83',
        dueDate: today.subtract(const Duration(days: 120)),
        state: ReminderState.done,
        notes: 'Paid at Transport Management Office',
      ),
    ];

    final snapshots = [
      _snapshot(
        id: 'snap-shine',
        token: shineToken,
        vehicle: shine,
        records: shineRecords,
        evidence: evidence,
        sharedAt: sharedAt,
      ),
      _snapshot(
        id: 'snap-fzs',
        token: fzsToken,
        vehicle: fzs,
        records: fzsRecords,
        evidence: evidence,
        sharedAt: sharedAt.subtract(const Duration(days: 3)),
      ),
      _snapshot(
        id: 'snap-grand',
        token: grandToken,
        vehicle: grand,
        records: grandRecords,
        evidence: evidence,
        sharedAt: sharedAt.subtract(const Duration(days: 6)),
      ),
    ];

    final batch = db.batch();
    for (final user in users) {
      batch.insert('users', user.toMap());
    }
    for (final vehicle in [shine, creta, fzs, grand]) {
      batch.insert('vehicles', vehicle.toMap());
    }
    for (final record in [
      ...shineRecords,
      ...cretaRecords,
      ...fzsRecords,
      ...grandRecords,
    ]) {
      batch.insert('records', record.toMap());
    }
    for (final item in evidence) {
      batch.insert('evidence', item.toMap());
    }
    for (final reminder in reminders) {
      batch.insert('reminders', reminder.toMap());
    }
    for (final snapshot in snapshots) {
      batch.insert('report_snapshots', snapshot.toMap());
    }
    await batch.commit(noResult: true);
  }

  static ReportSnapshot _snapshot({
    required String id,
    required String token,
    required Vehicle vehicle,
    required List<VehicleRecord> records,
    required List<Evidence> evidence,
    required DateTime sharedAt,
  }) {
    final payload = buildReportPayload(
      token: token,
      vehicle: vehicle,
      records: records,
      evidence: evidence,
      generatedAt: sharedAt,
    );
    return ReportSnapshot(
      id: id,
      vehicleId: vehicle.id,
      token: token,
      createdAt: sharedAt,
      payloadJson: jsonEncode(payload),
    );
  }

  static VehicleRecord _record({
    required String id,
    required String vehicleId,
    required RecordCategory category,
    required String title,
    required String date,
    int? km,
    String? workshop,
    int? cost,
    String? doc,
    RecordSource source = RecordSource.ownerRecorded,
    String? description,
    required DateTime createdAt,
  }) {
    return VehicleRecord(
      id: id,
      vehicleId: vehicleId,
      category: category,
      title: title,
      description: description,
      eventDate: DateTime.parse(date),
      odometerKm: km,
      workshop: workshop,
      costNpr: cost,
      documentNo: doc,
      source: source,
      createdAt: createdAt,
      isSeed: true,
    );
  }

  static Evidence _evidence({
    required String id,
    required String recordId,
    required EvidenceKind kind,
    required String asset,
    required String label,
    required DateTime createdAt,
  }) {
    return Evidence(
      id: id,
      recordId: recordId,
      kind: kind,
      filePath: 'asset:assets/demo/$asset',
      thumbPath: 'asset:assets/demo/$asset',
      mime: 'image/png',
      width: 1080,
      height: 1440,
      sizeBytes: 210000,
      label: label,
      createdAt: createdAt,
    );
  }

  static List<VehicleRecord> _shineRecords(DateTime createdAt) {
    const v = shineId;
    return [
      _record(
        id: 'rec-shine-01',
        vehicleId: v,
        category: RecordCategory.ownership,
        title: 'Purchased — first owner',
        date: '2021-06-15',
        km: 0,
        workshop: 'Sajha Auto Works, Kathmandu',
        cost: 218000,
        doc: 'BLK-2078-04512',
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-02',
        vehicleId: v,
        category: RecordCategory.insurance,
        title: 'Comprehensive insurance',
        date: '2021-06-16',
        km: 0,
        cost: 7900,
        doc: 'SHK/MC/2021/11842',
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-03',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'First free service',
        date: '2021-08-02',
        km: 480,
        workshop: 'Sajha Auto Works, Kathmandu',
        cost: 0,
        doc: 'SAW-21-0821',
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-04',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2021-10-10',
        km: 1150,
        cost: 900,
        description: 'Self-reported fill-up, no receipt kept.',
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-05',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2021-12-20',
        km: 1710,
        cost: 900,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-06',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Second free service',
        date: '2022-02-11',
        km: 3420,
        workshop: 'Sajha Auto Works, Kathmandu',
        cost: 0,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-07',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2022-04-02',
        km: 4100,
        cost: 1000,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-08',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2022-06-18',
        km: 5080,
        cost: 1200,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-09',
        vehicleId: v,
        category: RecordCategory.insurance,
        title: 'Insurance renewal',
        date: '2022-06-20',
        km: 5150,
        cost: 6900,
        doc: 'SHK/MC/2022/14410',
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-10',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2022-08-20',
        km: 5850,
        cost: 1100,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-11',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Paid service — oil and filter',
        date: '2022-11-05',
        km: 6890,
        workshop: 'Sajha Auto Works, Kathmandu',
        cost: 1450,
        doc: 'SAW-22-1108',
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-12',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2023-01-15',
        km: 7600,
        cost: 1050,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-13',
        vehicleId: v,
        category: RecordCategory.tax,
        title: 'Road tax 2079/80',
        date: '2023-03-14',
        km: 8450,
        cost: 2900,
        doc: 'DOF-2079-88421',
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-14',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Monsoon service',
        date: '2023-06-10',
        km: 8900,
        workshop: 'Sajha Auto Works, Kathmandu',
        cost: 1300,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-15',
        vehicleId: v,
        category: RecordCategory.repair,
        title: 'Brake shoes replacement',
        date: '2023-09-03',
        km: 9850,
        workshop: 'Sajha Auto Works, Kathmandu',
        cost: 1900,
        doc: 'SAW-23-0915',
        source: RecordSource.workshopReceipt,
        description: 'Front and rear brake shoes replaced.',
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-16',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2023-12-20',
        km: 11200,
        cost: 950,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-17',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Annual service',
        date: '2024-03-22',
        km: 13400,
        workshop: 'Sajha Auto Works, Kathmandu',
        cost: 1850,
        doc: 'SAW-24-0311',
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-18',
        vehicleId: v,
        category: RecordCategory.insurance,
        title: 'Insurance renewal',
        date: '2024-06-16',
        km: 14200,
        cost: 7400,
        doc: 'SHK/MC/2024/19002',
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-19',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2024-07-10',
        km: 15200,
        cost: 1000,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-20',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2024-10-15',
        km: 15900,
        cost: 980,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-21',
        vehicleId: v,
        category: RecordCategory.tax,
        title: 'Road tax 2081/82',
        date: '2024-11-20',
        km: 16100,
        cost: 3200,
        doc: 'DOF-2081-11230',
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-22',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2025-01-05',
        km: 16300,
        cost: 850,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-23',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2025-02-18',
        km: 16450,
        cost: 900,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-24',
        vehicleId: v,
        category: RecordCategory.repair,
        title: 'Chain and sprocket set',
        date: '2025-05-10',
        km: 16750,
        workshop: 'Sajha Auto Works, Kathmandu',
        cost: 1400,
        doc: 'SAW-25-0507',
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-25',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2025-08-12',
        km: 16950,
        cost: 950,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-26',
        vehicleId: v,
        category: RecordCategory.tax,
        title: 'Road tax 2083/84',
        date: '2025-11-18',
        km: 17100,
        cost: 3600,
        doc: 'DOF-2083-20418',
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-27',
        vehicleId: v,
        category: RecordCategory.insurance,
        title: 'Insurance renewal',
        date: '2025-12-04',
        km: 17180,
        cost: 7600,
        doc: 'SHK/MC/2025/8821',
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-28',
        vehicleId: v,
        category: RecordCategory.pollution,
        title: 'Pollution test — pass',
        date: '2026-02-20',
        km: 17300,
        cost: 700,
        doc: 'BPCL-26-7712',
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-29',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'General checkup and oil',
        date: '2026-05-30',
        km: 17450,
        workshop: 'Sajha Auto Works, Kathmandu',
        cost: 1200,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-30',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2026-08-20',
        km: 17900,
        cost: 1000,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-31',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2026-10-02',
        km: 18150,
        cost: 950,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-shine-32',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Pre-sale inspection service',
        date: '2026-11-05',
        km: 18240,
        workshop: 'Sajha Auto Works, Kathmandu',
        cost: 950,
        doc: 'SAW-26-1102',
        source: RecordSource.workshopReceipt,
        description: 'Owner-requested check before listing the bike.',
        createdAt: createdAt,
      ),
    ];
  }

  static List<VehicleRecord> _cretaRecords(DateTime createdAt) {
    const v = cretaId;
    return [
      _record(
        id: 'rec-creta-01',
        vehicleId: v,
        category: RecordCategory.ownership,
        title: 'Purchased — first owner',
        date: '2021-02-10',
        km: 12,
        workshop: 'Laxmi Hyundai, Kupondole',
        cost: 5650000,
        doc: 'BLK-2077-11902',
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-creta-02',
        vehicleId: v,
        category: RecordCategory.insurance,
        title: 'Comprehensive insurance',
        date: '2021-02-12',
        km: 12,
        cost: 28400,
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-creta-03',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'First free service',
        date: '2021-08-14',
        km: 4900,
        workshop: 'Laxmi Hyundai, Kupondole',
        cost: 0,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-creta-04',
        vehicleId: v,
        category: RecordCategory.tax,
        title: 'Road tax 2078/79',
        date: '2021-09-06',
        km: 5600,
        cost: 14200,
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-creta-05',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Scheduled service',
        date: '2022-09-02',
        km: 14800,
        workshop: 'Laxmi Hyundai, Kupondole',
        cost: 8900,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-creta-06',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Scheduled service',
        date: '2023-10-11',
        km: 24600,
        workshop: 'Laxmi Hyundai, Kupondole',
        cost: 11200,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-creta-07',
        vehicleId: v,
        category: RecordCategory.insurance,
        title: 'Insurance renewal',
        date: '2024-02-12',
        km: 28300,
        cost: 31200,
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-creta-08',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Scheduled service',
        date: '2024-11-20',
        km: 32400,
        workshop: 'Laxmi Hyundai, Kupondole',
        cost: 9800,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-creta-09',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — diesel',
        date: '2026-04-10',
        km: 36800,
        cost: 6000,
        description: 'Odometer noted at last fill-up.',
        createdAt: createdAt,
      ),
    ];
  }

  static List<VehicleRecord> _fzsRecords(DateTime createdAt) {
    const v = fzsId;
    return [
      _record(
        id: 'rec-fzs-01',
        vehicleId: v,
        category: RecordCategory.ownership,
        title: 'Purchased — second owner',
        date: '2019-03-02',
        km: 0,
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-fzs-02',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'First service',
        date: '2019-07-11',
        km: 950,
        workshop: 'Yamaha Service Centre, Balaju',
        cost: 0,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-fzs-03',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Oil change',
        date: '2020-01-18',
        km: 4800,
        workshop: 'Yamaha Service Centre, Balaju',
        cost: 1350,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-fzs-04',
        vehicleId: v,
        category: RecordCategory.insurance,
        title: 'Third-party insurance',
        date: '2020-03-05',
        km: 5200,
        cost: 4800,
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-fzs-05',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Full service',
        date: '2021-06-22',
        km: 12600,
        workshop: 'Yamaha Service Centre, Balaju',
        cost: 2100,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-fzs-06',
        vehicleId: v,
        category: RecordCategory.repair,
        title: 'Chain and clutch plates',
        date: '2022-09-14',
        km: 18900,
        workshop: 'Balaju Bike Garage',
        cost: 3200,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-fzs-07',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Oil and filter change',
        date: '2023-02-08',
        km: 21400,
        workshop: 'Yamaha Service Centre, Balaju',
        cost: 1800,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-fzs-08',
        vehicleId: v,
        category: RecordCategory.tax,
        title: 'Road tax 2080/81',
        date: '2024-04-02',
        km: 23600,
        cost: 2600,
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-fzs-09',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Full service after storage',
        date: '2025-06-26',
        km: 26100,
        workshop: 'Yamaha Service Centre, Balaju',
        cost: 1900,
        source: RecordSource.workshopReceipt,
        description: 'Bike was in storage; owner reports it was rarely ridden during this period.',
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-fzs-10',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2026-03-15',
        km: 27400,
        cost: 1000,
        createdAt: createdAt,
      ),
    ];
  }

  static List<VehicleRecord> _grandRecords(DateTime createdAt) {
    const v = grandId;
    return [
      _record(
        id: 'rec-grand-01',
        vehicleId: v,
        category: RecordCategory.ownership,
        title: 'Purchased — first owner',
        date: '2018-05-20',
        km: 0,
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-grand-02',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'First free service',
        date: '2018-11-02',
        km: 4200,
        workshop: 'Hyundai Service, Dhumbarahi',
        cost: 0,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-grand-03',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Scheduled service',
        date: '2020-02-14',
        km: 16800,
        workshop: 'Hyundai Service, Dhumbarahi',
        cost: 6400,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-grand-04',
        vehicleId: v,
        category: RecordCategory.insurance,
        title: 'Comprehensive insurance',
        date: '2021-05-20',
        km: 24800,
        cost: 21000,
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-grand-05',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Scheduled service',
        date: '2022-08-09',
        km: 31500,
        workshop: 'Hyundai Service, Dhumbarahi',
        cost: 7800,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-grand-06',
        vehicleId: v,
        category: RecordCategory.fuel,
        title: 'Fuel — NOC',
        date: '2023-06-10',
        km: 38900,
        cost: 4000,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-grand-07',
        vehicleId: v,
        category: RecordCategory.service,
        title: 'Scheduled service',
        date: '2024-03-15',
        km: 41500,
        workshop: 'Hyundai Service, Dhumbarahi',
        cost: 8200,
        source: RecordSource.workshopReceipt,
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-grand-08',
        vehicleId: v,
        category: RecordCategory.repair,
        title: 'Clutch work',
        date: '2024-09-10',
        km: 39200,
        workshop: 'Dhumbarahi Auto Care',
        cost: 14500,
        source: RecordSource.workshopReceipt,
        description: 'Odometer reading on this receipt is lower than the previous service.',
        createdAt: createdAt,
      ),
      _record(
        id: 'rec-grand-09',
        vehicleId: v,
        category: RecordCategory.insurance,
        title: 'Insurance renewal',
        date: '2025-05-20',
        km: 39800,
        cost: 23500,
        source: RecordSource.officialDocument,
        createdAt: createdAt,
      ),
    ];
  }

  static List<Evidence> _shineEvidence() {
    final at = DateTime(2026, 11, 1, 9);
    return [
      _evidence(
        id: 'ev-shine-bluebook',
        recordId: 'rec-shine-01',
        kind: EvidenceKind.bluebook,
        asset: 'doc_bluebook.png',
        label: 'Bluebook — owner copy',
        createdAt: at,
      ),
      _evidence(
        id: 'ev-shine-policy-2021',
        recordId: 'rec-shine-02',
        kind: EvidenceKind.policy,
        asset: 'doc_policy.png',
        label: 'Shikhar policy 2021/22',
        createdAt: at,
      ),
      _evidence(
        id: 'ev-shine-service-1',
        recordId: 'rec-shine-03',
        kind: EvidenceKind.bill,
        asset: 'bill_service_a.png',
        label: 'First free service slip',
        createdAt: at,
      ),
      _evidence(
        id: 'ev-shine-policy-2022',
        recordId: 'rec-shine-09',
        kind: EvidenceKind.policy,
        asset: 'doc_policy.png',
        label: 'Shikhar policy 2022/23',
        createdAt: at,
      ),
      _evidence(
        id: 'ev-shine-service-2',
        recordId: 'rec-shine-11',
        kind: EvidenceKind.bill,
        asset: 'bill_service_b.png',
        label: 'Service bill — Nov 2022',
        createdAt: at,
      ),
      _evidence(
        id: 'ev-shine-tax-1',
        recordId: 'rec-shine-13',
        kind: EvidenceKind.paymentSlip,
        asset: 'doc_tax.png',
        label: 'Road tax receipt 2079/80',
        createdAt: at,
      ),
      _evidence(
        id: 'ev-shine-repair',
        recordId: 'rec-shine-15',
        kind: EvidenceKind.bill,
        asset: 'bill_repair.png',
        label: 'Brake replacement bill',
        createdAt: at,
      ),
      _evidence(
        id: 'ev-shine-service-3',
        recordId: 'rec-shine-17',
        kind: EvidenceKind.bill,
        asset: 'bill_service_c.png',
        label: 'Annual service bill',
        createdAt: at,
      ),
      _evidence(
        id: 'ev-shine-service-4',
        recordId: 'rec-shine-29',
        kind: EvidenceKind.bill,
        asset: 'bill_service_b.png',
        label: 'Checkup bill — May 2026',
        createdAt: at,
      ),
      _evidence(
        id: 'ev-shine-pollution',
        recordId: 'rec-shine-28',
        kind: EvidenceKind.paymentSlip,
        asset: 'doc_pollution.png',
        label: 'Pollution certificate',
        createdAt: at,
      ),
    ];
  }

  static List<Evidence> _fzsEvidence() {
    final at = DateTime(2026, 11, 1, 9);
    return [
      _evidence(
        id: 'ev-fzs-service-1',
        recordId: 'rec-fzs-05',
        kind: EvidenceKind.bill,
        asset: 'bill_service_a.png',
        label: 'Yamaha service bill 2021',
        createdAt: at,
      ),
      _evidence(
        id: 'ev-fzs-service-2',
        recordId: 'rec-fzs-09',
        kind: EvidenceKind.bill,
        asset: 'bill_service_d.png',
        label: 'Post-storage service bill',
        createdAt: at,
      ),
    ];
  }

  static String newId() => const Uuid().v4();
}
