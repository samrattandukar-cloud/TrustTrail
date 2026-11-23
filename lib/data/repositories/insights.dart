import '../../domain/completeness.dart';
import '../../domain/odometer_analysis.dart';
import '../models/evidence.dart';
import '../models/vehicle.dart';
import '../models/vehicle_record.dart';

CompletenessReport completenessFor(
  Vehicle vehicle,
  List<VehicleRecord> records,
  List<Evidence> evidence,
) {
  final kinds = evidence.map((item) => item.kind).toSet();
  return computeCompleteness(
    CompletenessInput(
      hasBluebook: kinds.contains(EvidenceKind.bluebook),
      hasOwnershipRecord: records.any(
        (record) => record.category == RecordCategory.ownership,
      ),
      hasInsurance: records.any(
        (record) => record.category == RecordCategory.insurance,
      ),
      hasRoadTax: records.any(
        (record) => record.category == RecordCategory.tax,
      ),
      hasPollution: records.any(
        (record) => record.category == RecordCategory.pollution,
      ),
      serviceRecordCount: records
          .where((record) => record.category == RecordCategory.service)
          .length,
      odometerReadingCount: records
          .where((record) => record.odometerKm != null)
          .length,
      hasEngineNumber: (vehicle.engineMasked ?? '').trim().isNotEmpty,
      hasChassisNumber: (vehicle.chassisMasked ?? '').trim().isNotEmpty,
      photoCount: evidence
          .where((item) => item.kind == EvidenceKind.photo)
          .length,
    ),
  );
}

OdometerAnalysis odometerFor(List<VehicleRecord> records) {
  return analyzeOdometer([
    for (final record in records)
      if (record.odometerKm != null)
        OdometerReading(
          date: record.eventDate,
          km: record.odometerKm!,
          recordId: record.id,
          label: record.title,
        ),
  ]);
}

int latestOdometer(Vehicle vehicle, List<VehicleRecord> records) {
  final withOdometer =
      records.where((record) => record.odometerKm != null).toList()
        ..sort((a, b) => a.eventDate.compareTo(b.eventDate));
  return withOdometer.isEmpty
      ? vehicle.initialOdometer
      : withOdometer.last.odometerKm!;
}

List<VehicleRecord> newestFirst(List<VehicleRecord> records) {
  return [...records]..sort((a, b) => b.eventDate.compareTo(a.eventDate));
}
