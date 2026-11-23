import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/reminder.dart';
import '../../data/repositories/insights.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/completeness.dart';
import '../../domain/odometer_analysis.dart';
import '../../domain/reminder_engine.dart';
import '../auth/session.dart';
import '../vehicles/vehicle_bundle.dart';
import '../../data/models/vehicle.dart';

class GarageEntry {
  const GarageEntry({
    required this.vehicle,
    required this.completeness,
    required this.odometer,
    required this.latestKm,
    required this.recordCount,
    required this.evidenceCount,
    required this.lastEvent,
    required this.reminders,
  });

  final Vehicle vehicle;
  final CompletenessReport completeness;
  final OdometerAnalysis odometer;
  final int latestKm;
  final int recordCount;
  final int evidenceCount;
  final DateTime? lastEvent;
  final List<Reminder> reminders;

  int attentionCount(DateTime today) => reminders
      .where(
        (reminder) => assessReminder(
          type: reminder.type,
          dueDate: reminder.dueDate,
          done: reminder.isDone,
          today: today,
          targetOdometer: reminder.targetOdometer,
          currentOdometer: latestKm,
        ).needsAttention,
      )
      .length;
}

class GarageController extends AsyncNotifier<List<GarageEntry>> {
  @override
  Future<List<GarageEntry>> build() async {
    final session = await ref.watch(sessionProvider.future);
    if (session.user == null) return const [];
    return _load(session.user!.id);
  }

  Future<void> refresh() async {
    final session = await ref.read(sessionProvider.future);
    if (session.user == null) {
      state = const AsyncData([]);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(session.user!.id));
  }

  Future<List<GarageEntry>> _load(String ownerId) async {
    final vehicles = await ref
        .read(vehicleRepositoryProvider)
        .listByOwner(ownerId);
    final garage = <GarageEntry>[];
    for (final vehicle in vehicles) {
      final records = await ref
          .read(recordRepositoryProvider)
          .listForVehicle(vehicle.id);
      final evidence = await ref
          .read(evidenceRepositoryProvider)
          .listForVehicle(vehicle.id);
      final reminders = await ref
          .read(reminderRepositoryProvider)
          .listForVehicle(vehicle.id);
      garage.add(
        GarageEntry(
          vehicle: vehicle,
          completeness: completenessFor(vehicle, records, evidence),
          odometer: odometerFor(records),
          latestKm: latestOdometer(vehicle, records),
          recordCount: records.length,
          evidenceCount: evidence.length,
          lastEvent: records.isEmpty ? null : records.first.eventDate,
          reminders: reminders,
        ),
      );
    }
    return garage;
  }
}

final garageProvider =
    AsyncNotifierProvider<GarageController, List<GarageEntry>>(
      GarageController.new,
    );

final garageSummaryProvider =
    FutureProvider.autoDispose<({int vehicles, int records, int reports})>((
      ref,
    ) async {
      final session = await ref.watch(sessionProvider.future);
      final user = session.user;
      if (user == null) return (vehicles: 0, records: 0, reports: 0);
      final vehicles = await ref
          .watch(vehicleRepositoryProvider)
          .listByOwner(user.id);
      var records = 0;
      var reports = 0;
      for (final vehicle in vehicles) {
        records += await ref
            .watch(recordRepositoryProvider)
            .countForVehicle(vehicle.id);
        reports +=
            (await ref
                    .watch(reportRepositoryProvider)
                    .listForVehicle(vehicle.id))
                .length;
      }
      return (vehicles: vehicles.length, records: records, reports: reports);
    });

/// Rebuilds a bundle after edits outside its provider.
void invalidateVehicle(WidgetRef ref, String vehicleId) {
  ref.invalidate(vehicleBundleProvider(vehicleId));
  ref.invalidate(garageProvider);
  ref.invalidate(garageSummaryProvider);
}
