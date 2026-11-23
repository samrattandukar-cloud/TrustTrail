import 'package:flutter_test/flutter_test.dart';
import 'package:trusttrail/domain/sus_scoring.dart';

void main() {
  group('SUS scoring', () {
    test('all best answers score 100', () {
      expect(susScore([5, 1, 5, 1, 5, 1, 5, 1, 5, 1]), 100);
    });

    test('all neutral answers score 50', () {
      expect(susScore(List<int>.filled(10, 3)), 50);
    });

    test('all worst answers score 0', () {
      expect(susScore([1, 5, 1, 5, 1, 5, 1, 5, 1, 5]), 0);
    });

    test('mixed answers follow the odd/even formula', () {
      // Odd items: 4 → 3 each (5 items = 15). Even items: 2 → 3 each (15).
      expect(susScore([4, 2, 4, 2, 4, 2, 4, 2, 4, 2]), 75);
    });

    test('rejects a short response', () {
      expect(() => susScore([5, 1, 5]), throwsArgumentError);
    });

    test('rejects out-of-range values', () {
      expect(
        () => susScore([6, 1, 5, 1, 5, 1, 5, 1, 5, 1]),
        throwsArgumentError,
      );
    });

    test('bands match the published interpretation', () {
      expect(susBand(90), 'Excellent');
      expect(susBand(75), 'Good');
      expect(susBand(60), 'OK');
      expect(susBand(30), 'Needs work');
    });
  });
}
