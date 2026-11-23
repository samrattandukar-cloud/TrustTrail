import 'package:flutter_test/flutter_test.dart';
import 'package:trusttrail/domain/completeness.dart';

void main() {
  group('completeness', () {
    test('counts documented sections and lists the rest', () {
      final report = computeCompleteness(
        const CompletenessInput(
          hasBluebook: true,
          hasOwnershipRecord: true,
          hasInsurance: true,
          hasRoadTax: true,
          serviceRecordCount: 4,
          odometerReadingCount: 6,
          hasEngineNumber: true,
          hasChassisNumber: true,
        ),
      );

      expect(report.filled, 8);
      expect(report.total, 10);
      expect(report.percent, 80);
      expect(report.isComplete, isFalse);
      expect(
        report.missing,
        containsAll([
          CompletenessSection.pollution,
          CompletenessSection.photos,
        ]),
      );
    });

    test('a fresh vehicle has no sections filled', () {
      final report = computeCompleteness(const CompletenessInput());
      expect(report.filled, 0);
      expect(report.percent, 0);
      expect(report.missing.length, 10);
    });

    test('is complete when all ten are documented', () {
      final report = computeCompleteness(
        const CompletenessInput(
          hasBluebook: true,
          hasOwnershipRecord: true,
          hasInsurance: true,
          hasRoadTax: true,
          hasPollution: true,
          serviceRecordCount: 3,
          odometerReadingCount: 3,
          hasEngineNumber: true,
          hasChassisNumber: true,
          photoCount: 1,
        ),
      );
      expect(report.isComplete, isTrue);
      expect(report.percent, 100);
      expect(report.missing, isEmpty);
    });
  });
}
