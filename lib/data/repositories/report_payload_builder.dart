import '../models/evidence.dart';
import '../models/vehicle.dart';
import '../models/vehicle_record.dart';
import 'insights.dart';

/// Freezes everything a buyer sees into one JSON document. Later edits to the
/// owner's records never mutate a report that was already shared.
Map<String, Object?> buildReportPayload({
  required String token,
  required Vehicle vehicle,
  required List<VehicleRecord> records,
  required List<Evidence> evidence,
  required DateTime generatedAt,
  bool includeCosts = true,
  bool includeEvidence = true,
}) {
  final sorted = newestFirst(records);
  final completeness = completenessFor(vehicle, records, evidence);
  final odometer = odometerFor(records);

  return {
    'token': token,
    'generatedAt': generatedAt.toIso8601String(),
    'vehicle': {
      ...vehicle.toMap(),
      'latestKm': latestOdometer(vehicle, records),
    },
    'records': [
      for (final record in sorted)
        {
          ...record.toMap(),
          'evidence': includeEvidence
              ? [
                  for (final item in evidence)
                    if (item.recordId == record.id) item.toMap(),
                ]
              : <Map<String, Object?>>[],
        },
    ],
    'completeness': {
      'filled': completeness.filled,
      'total': completeness.total,
      'percent': completeness.percent,
      'missing': completeness.missing.map((section) => section.name).toList(),
    },
    'odometer': {
      'readings': [
        for (final reading in odometer.readings)
          {
            'date': reading.date.toIso8601String(),
            'km': reading.km,
            'recordId': reading.recordId,
          },
      ],
      'gaps': [
        for (final gap in odometer.gaps)
          {
            'from': gap.from.toIso8601String(),
            'to': gap.to.toIso8601String(),
            'days': gap.days,
            'months': gap.months,
          },
      ],
      'flags': [
        for (final flag in odometer.flags)
          {
            'from': flag.from.toIso8601String(),
            'to': flag.to.toIso8601String(),
            'issue': flag.issue.name,
            'fromKm': flag.fromKm,
            'toKm': flag.toKm,
          },
      ],
      'averageKmPerMonth': odometer.averageKmPerMonth,
    },
    'includeCosts': includeCosts,
    'includeEvidence': includeEvidence,
  };
}
