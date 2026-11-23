import 'package:flutter_test/flutter_test.dart';
import 'package:trusttrail/domain/odometer_analysis.dart';

OdometerReading reading(String date, int km) =>
    OdometerReading(date: DateTime.parse(date), km: km);

void main() {
  group('odometer analysis', () {
    test('sorts readings and computes the average monthly use', () {
      final analysis = analyzeOdometer([
        reading('2023-05-01', 10000),
        reading('2023-01-01', 8000),
        reading('2023-03-01', 9000),
      ]);

      expect(analysis.readings.first.km, 8000);
      expect(analysis.readings.last.km, 10000);
      expect(analysis.averageKmPerMonth, closeTo(507, 2));
      expect(analysis.significantGaps, isEmpty);
    });

    test('flags a gap longer than 120 days without inventing causes', () {
      final analysis = analyzeOdometer([
        reading('2024-02-12', 18000),
        reading('2025-06-26', 21500),
      ]);

      expect(analysis.significantGaps, hasLength(1));
      expect(analysis.significantGaps.single.days, greaterThan(400));
      expect(analysis.significantGaps.single.months, greaterThan(14));
      expect(analysis.flags, isEmpty);
    });

    test('flags an odometer decrease with both readings', () {
      final analysis = analyzeOdometer([
        reading('2024-01-01', 50000),
        reading('2024-06-01', 47000),
      ]);

      expect(analysis.hasDecrease, isTrue);
      final flag = analysis.flags.single;
      expect(flag.issue, OdometerIssue.decrease);
      expect(flag.fromKm, 50000);
      expect(flag.toKm, 47000);
    });

    test('flags an implausible monthly rate', () {
      final analysis = analyzeOdometer([
        reading('2024-01-01', 10000),
        reading('2024-01-11', 12000),
      ]);

      expect(analysis.flags.single.issue, OdometerIssue.implausibleRate);
    });

    test('handles empty input', () {
      final analysis = analyzeOdometer([]);
      expect(analysis.hasReadings, isFalse);
      expect(analysis.latestKm, isNull);
    });
  });
}
