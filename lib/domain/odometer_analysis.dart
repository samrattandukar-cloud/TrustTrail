/// Neutral odometer analysis: gaps between records and readings that do not
/// fit a plausible usage pattern. Wording stays factual — the app reports
/// observations, it does not accuse anyone.
class OdometerReading {
  const OdometerReading({
    required this.date,
    required this.km,
    this.recordId,
    this.label,
  });

  final DateTime date;
  final int km;
  final String? recordId;
  final String? label;
}

enum OdometerIssue { decrease, implausibleRate }

class OdometerGap {
  const OdometerGap({required this.from, required this.to, required this.days});

  final DateTime from;
  final DateTime to;
  final int days;

  double get months => days / 30.44;
}

class OdometerFlag {
  const OdometerFlag({
    required this.from,
    required this.to,
    required this.issue,
    required this.fromKm,
    required this.toKm,
  });

  final DateTime from;
  final DateTime to;
  final OdometerIssue issue;
  final int fromKm;
  final int toKm;

  int get deltaKm => toKm - fromKm;
}

class OdometerAnalysis {
  const OdometerAnalysis({
    required this.readings,
    required this.gaps,
    required this.flags,
    this.averageKmPerMonth,
  });

  final List<OdometerReading> readings;
  final List<OdometerGap> gaps;
  final List<OdometerFlag> flags;
  final double? averageKmPerMonth;

  bool get hasReadings => readings.isNotEmpty;

  int? get latestKm => readings.isEmpty ? null : readings.last.km;

  bool get hasDecrease =>
      flags.any((flag) => flag.issue == OdometerIssue.decrease);

  List<OdometerGap> get significantGaps =>
      gaps.where((gap) => gap.days > 120).toList();
}

OdometerAnalysis analyzeOdometer(
  List<OdometerReading> input, {
  int gapDays = 120,
  double implausibleKmPerMonth = 4000,
}) {
  final readings = [...input]..sort((a, b) => a.date.compareTo(b.date));
  final gaps = <OdometerGap>[];
  final flags = <OdometerFlag>[];

  for (var i = 1; i < readings.length; i++) {
    final previous = readings[i - 1];
    final current = readings[i];
    final days = current.date.difference(previous.date).inDays;

    if (days > gapDays) {
      gaps.add(OdometerGap(from: previous.date, to: current.date, days: days));
    }
    if (current.km < previous.km) {
      flags.add(
        OdometerFlag(
          from: previous.date,
          to: current.date,
          issue: OdometerIssue.decrease,
          fromKm: previous.km,
          toKm: current.km,
        ),
      );
      continue;
    }
    if (days > 0) {
      final perMonth = (current.km - previous.km) * 30.44 / days;
      if (perMonth > implausibleKmPerMonth) {
        flags.add(
          OdometerFlag(
            from: previous.date,
            to: current.date,
            issue: OdometerIssue.implausibleRate,
            fromKm: previous.km,
            toKm: current.km,
          ),
        );
      }
    }
  }

  double? average;
  if (readings.length >= 2) {
    final months =
        readings.last.date.difference(readings.first.date).inDays / 30.44;
    final delta = readings.last.km - readings.first.km;
    if (months > 0 && delta > 0) average = delta / months;
  }

  return OdometerAnalysis(
    readings: readings,
    gaps: gaps,
    flags: flags,
    averageKmPerMonth: average,
  );
}
