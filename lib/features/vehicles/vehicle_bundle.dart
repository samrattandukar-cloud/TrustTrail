import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/evidence.dart';
import '../../data/models/reminder.dart';
import '../../data/models/vehicle.dart';
import '../../data/models/vehicle_record.dart';
import '../../data/repositories/insights.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/completeness.dart';
import '../../domain/odometer_analysis.dart';

class VehicleBundle {
  const VehicleBundle({
    required this.vehicle,
    required this.records,
    required this.evidence,
    required this.reminders,
  });

  final Vehicle vehicle;
  final List<VehicleRecord> records;
  final List<Evidence> evidence;
  final List<Reminder> reminders;

  CompletenessReport get completeness =>
      completenessFor(vehicle, records, evidence);

  OdometerAnalysis get odometer => odometerFor(records);

  int get latestKm => latestOdometer(vehicle, records);

  int get evidenceCount => evidence.length;
}

final vehicleBundleProvider = FutureProvider.autoDispose
    .family<VehicleBundle?, String>((ref, id) async {
      final vehicles = ref.watch(vehicleRepositoryProvider);
      final vehicle = await vehicles.getById(id);
      if (vehicle == null) return null;

      final records = await ref
          .watch(recordRepositoryProvider)
          .listForVehicle(id);
      final evidence = await ref
          .watch(evidenceRepositoryProvider)
          .listForVehicle(id);
      final reminders = await ref
          .watch(reminderRepositoryProvider)
          .listForVehicle(id);

      return VehicleBundle(
        vehicle: vehicle,
        records: records,
        evidence: evidence,
        reminders: reminders,
      );
    });
