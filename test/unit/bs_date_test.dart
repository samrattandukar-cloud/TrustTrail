import 'package:flutter_test/flutter_test.dart';
import 'package:trusttrail/core/utils/bs_date.dart';

void main() {
  group('BsDate', () {
    test('converts the 2024 Nepali New Year boundary', () {
      final bs = BsDate.bsOf(DateTime(2024, 4, 13));
      expect(bs.year, 2081);
      expect(bs.month, 1);
      expect(bs.day, 1);
    });

    test('converts a Chaitra date from the design example', () {
      final bs = BsDate.bsOf(DateTime(2024, 3, 28));
      expect(bs.year, 2080);
      expect(bs.month, 12);
      expect(bs.day, 15);
    });

    test('round-trips across a year of dates', () {
      for (var day = 0; day < 365; day += 17) {
        final ad = DateTime(2023, 1, 1).add(Duration(days: day));
        expect(BsDate.adOf(BsDate.bsOf(ad)).isAtSameMomentAs(ad), isTrue);
      }
    });

    test('formats both calendars', () {
      final text = BsDate.both(DateTime(2024, 3, 28));
      expect(text, contains('28 Mar 2024'));
      expect(text, contains('2080'));
      expect(text, contains('BS'));
    });

    test('labels BS years with Nepali digits when requested', () {
      final label = BsDate.yearLabel(DateTime(2024, 4, 13), nepali: true);
      expect(label, contains('२०८१'));
    });
  });
}
