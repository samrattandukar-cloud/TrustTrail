import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart' show NepaliUnicode;

import 'bs_calendar.dart';

class BsDateParts {
  const BsDateParts(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;

  @override
  String toString() => '$year-$month-$day';
}

/// Bikram Sambat helpers built on whole-day arithmetic, so results do not
/// depend on the device timezone (the popular converter drifts by a day on
/// Nepal-time machines). All app timestamps stay AD; BS is presentation only.
abstract final class BsDate {
  static const monthNames = [
    'Baisakh',
    'Jestha',
    'Ashadh',
    'Shrawan',
    'Bhadra',
    'Ashwin',
    'Kartik',
    'Mangsir',
    'Poush',
    'Magh',
    'Falgun',
    'Chaitra',
  ];

  static const monthNamesNepali = [
    'बैशाख',
    'जेठ',
    'असार',
    'साउन',
    'भदौ',
    'असोज',
    'कार्तिक',
    'मंसिर',
    'पुष',
    'माघ',
    'फाल्गुन',
    'चैत',
  ];

  static final int _anchorDay =
      DateTime.utc(1913, 4, 13).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;

  static BsDateParts bsOf(DateTime ad) {
    var remaining = _dayNumber(ad) - _anchorDay;
    var year = BsCalendar.firstYear;
    while (year < BsCalendar.lastYear &&
        remaining >= BsCalendar.daysInYear(year)) {
      remaining -= BsCalendar.daysInYear(year);
      year += 1;
    }
    while (year > BsCalendar.firstYear && remaining < 0) {
      year -= 1;
      remaining += BsCalendar.daysInYear(year);
    }
    if (remaining < 0) {
      return BsDateParts(BsCalendar.firstYear, 1, 1);
    }

    var month = 1;
    while (month < 12 && remaining >= BsCalendar.daysInMonth(year, month)) {
      remaining -= BsCalendar.daysInMonth(year, month);
      month += 1;
    }
    final day = remaining + 1;
    if (day > BsCalendar.daysInMonth(year, month)) {
      return BsDateParts(year, month, BsCalendar.daysInMonth(year, month));
    }
    return BsDateParts(year, month, day);
  }

  static DateTime adOf(BsDateParts bs) {
    var days = 0;
    for (var year = BsCalendar.firstYear; year < bs.year; year++) {
      days += BsCalendar.daysInYear(year);
    }
    for (var month = 1; month < bs.month; month++) {
      days += BsCalendar.daysInMonth(bs.year, month);
    }
    days += bs.day - 1;
    final utc = DateTime.utc(1913, 4, 13).add(Duration(days: days));
    return DateTime(utc.year, utc.month, utc.day);
  }

  static int bsYear(DateTime ad) => bsOf(ad).year;

  static String formatBs(
    DateTime ad, {
    bool nepali = false,
    String pattern = 'd MMM yyyy',
  }) {
    return _format(bsOf(ad), pattern, nepali: nepali);
  }

  static String formatAd(DateTime ad, {String pattern = 'd MMM yyyy'}) {
    return DateFormat(pattern).format(ad);
  }

  /// `28 Mar 2024 · 15 Chaitra 2080` (or the Nepali-first variant).
  static String both(DateTime ad, {bool nepali = false}) {
    if (nepali) {
      return '${formatBs(ad, nepali: true)} · ${formatAd(ad)}';
    }
    return '${formatAd(ad)} · ${formatBs(ad)} BS';
  }

  static String monthYear(DateTime ad, {bool nepali = false}) =>
      formatBs(ad, nepali: nepali, pattern: 'MMMM yyyy');

  static String yearLabel(DateTime ad, {bool nepali = false}) {
    final year = bsYear(ad);
    return nepali ? '${_digits('$year')} बि.सं.' : '$year BS';
  }

  static String monthName(int month, {bool nepali = false}) {
    final names = nepali ? monthNamesNepali : monthNames;
    if (month < 1 || month > 12) return '';
    return names[month - 1];
  }

  static String _format(
    BsDateParts parts,
    String pattern, {
    required bool nepali,
  }) {
    final buffer = StringBuffer();
    var index = 0;
    while (index < pattern.length) {
      final char = pattern[index];
      var end = index;
      while (end < pattern.length && pattern[end] == char) {
        end += 1;
      }
      switch (char) {
        case 'd':
          buffer.write(nepali ? _digits('${parts.day}') : '${parts.day}');
        case 'M':
          buffer.write(monthName(parts.month, nepali: nepali));
        case 'y':
          buffer.write(nepali ? _digits('${parts.year}') : '${parts.year}');
        default:
          buffer.write(pattern.substring(index, end));
      }
      index = end;
    }
    return buffer.toString();
  }

  static String _digits(String value) => NepaliUnicode.convert(value);

  static int _dayNumber(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;
}
