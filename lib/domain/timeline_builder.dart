import '../core/utils/bs_date.dart';

class TimelineGroup<T> {
  const TimelineGroup({required this.bsYear, required this.items});

  final int bsYear;
  final List<T> items;
}

/// Groups items newest-first by Bikram Sambat year so the timeline reads like
/// a ledger rather than a flat log.
List<TimelineGroup<T>> groupByBsYear<T>(
  List<T> items,
  DateTime Function(T item) dateOf,
) {
  final groups = <int, List<T>>{};
  for (final item in items) {
    final year = BsDate.bsYear(dateOf(item));
    groups.putIfAbsent(year, () => []).add(item);
  }
  final years = groups.keys.toList()..sort((a, b) => b.compareTo(a));
  return [
    for (final year in years)
      TimelineGroup(
        bsYear: year,
        items: groups[year]!..sort((a, b) => dateOf(b).compareTo(dateOf(a))),
      ),
  ];
}
