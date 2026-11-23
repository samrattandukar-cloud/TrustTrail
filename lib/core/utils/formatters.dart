import 'package:intl/intl.dart';

import 'bs_date.dart';

abstract final class Fmt {
  static final _decimal = NumberFormat.decimalPattern('en');

  static String number(int value) => _decimal.format(value);

  static String km(int value) => '${_decimal.format(value)} km';

  static String npr(int? value) =>
      value == null ? '—' : 'NPR ${_decimal.format(value)}';

  static String percent(int value) => '$value%';

  static String shortDate(DateTime date) =>
      DateFormat('d MMM yyyy').format(date);

  static String dayMonth(DateTime date) => DateFormat('d MMM').format(date);

  static String monthYear(DateTime date) => DateFormat('MMM yyyy').format(date);

  static String dateWithBs(DateTime date, {bool nepali = false}) =>
      BsDate.both(date, nepali: nepali);

  static String plate(String value) =>
      value.trim().toUpperCase().replaceAll(RegExp(r'\s+'), ' ');

  static String months(double months) {
    final rounded = months < 10
        ? (months * 10).round() / 10
        : months.roundToDouble();
    final text = rounded == rounded.roundToDouble()
        ? rounded.toInt().toString()
        : rounded.toStringAsFixed(1);
    return rounded == 1 ? '$text month' : '$text months';
  }

  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
