import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/formatters.dart';
import '../l10n/l10n.dart';
import '../../domain/odometer_analysis.dart';

class TtOdometerChart extends StatelessWidget {
  const TtOdometerChart({
    super.key,
    required this.readings,
    this.flags = const [],
    this.height = 210,
  });

  final List<OdometerReading> readings;
  final List<OdometerFlag> flags;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    if (readings.length < 2) {
      return Container(
        height: 140,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: palette.surfaceRaised,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(20),
        child: Text(
          context.l10n.chartNeedsReadings,
          textAlign: TextAlign.center,
          style: TtType.bodyMedium(palette.textSecondary),
        ),
      );
    }

    final first = readings.first.date;
    final last = readings.last.date;
    final spanDays = last.difference(first).inDays.clamp(1, 100000);
    double xOf(DateTime date) => date.difference(first).inDays / spanDays * 12;

    final spots = [
      for (final reading in readings)
        FlSpot(xOf(reading.date), reading.km.toDouble()),
    ];
    final minKm = readings.map((r) => r.km).reduce((a, b) => a < b ? a : b);
    final maxKm = readings.map((r) => r.km).reduce((a, b) => a > b ? a : b);
    final padding = ((maxKm - minKm) * 0.18).clamp(400, 4000).toDouble();
    final maxY = maxKm + padding;
    final minY = (minKm - padding).clamp(0, double.infinity).toDouble();
    final maxX = 12.0;

    final locale = Localizations.localeOf(context).toString();
    String xLabel(double value) {
      final date = first.add(Duration(days: (value / 12 * spanDays).round()));
      return DateFormat('MMM yy', locale).format(date);
    }

    return Semantics(
      label: context.l10n.odometerTrendSemantics(Fmt.km(minKm), Fmt.km(maxKm)),
      child: SizedBox(
        height: height,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
            clipData: const FlClipData.all(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: (maxY - minY) / 4,
              getDrawingHorizontalLine: (value) =>
                  FlLine(color: palette.border, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 46,
                  interval: (maxY - minY) / 4,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      value >= 1000
                          ? '${(value / 1000).toStringAsFixed(1)}k'
                          : value.toStringAsFixed(0),
                      textAlign: TextAlign.right,
                      style: TtType.data(palette.textSecondary, size: 10),
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  interval: 6,
                  getTitlesWidget: (value, meta) {
                    if (value > 0 && value < maxX - 0.1) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        xLabel(value.clamp(0, maxX)),
                        style: TtType.data(palette.textSecondary, size: 10),
                      ),
                    );
                  },
                ),
              ),
            ),
            lineTouchData: const LineTouchData(enabled: false),
            extraLinesData: ExtraLinesData(
              verticalLines: [
                for (final flag in flags)
                  VerticalLine(
                    x: xOf(flag.to).clamp(0, maxX),
                    color: palette.error.withValues(alpha: 0.55),
                    strokeWidth: 1.4,
                    dashArray: [4, 4],
                  ),
              ],
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false,
                color: palette.primary,
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) =>
                      FlDotCirclePainter(
                        radius: 3,
                        color: palette.primary,
                        strokeWidth: 1.5,
                        strokeColor: palette.surface,
                      ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      palette.primary.withValues(alpha: 0.22),
                      palette.primary.withValues(alpha: 0.02),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
