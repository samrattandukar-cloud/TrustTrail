import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/bs_date.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_empty_state.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../data/repositories/report_repository.dart';
import '../report/report_providers.dart';

class CompareReportsScreen extends ConsumerWidget {
  const CompareReportsScreen({
    super.key,
    required this.leftToken,
    required this.rightToken,
  });

  final String leftToken;
  final String rightToken;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final left = ref.watch(reportMatchProvider(leftToken));
    final right = ref.watch(reportMatchProvider(rightToken));

    Widget body;
    if (left.isLoading || right.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (left.hasError || right.hasError) {
      body = Center(
        child: TtErrorState(
          title: l10n.errorGeneric,
          body: l10n.errorReportOpen,
          retryLabel: l10n.commonRetry,
          onRetry: () {
            ref.invalidate(reportMatchProvider(leftToken));
            ref.invalidate(reportMatchProvider(rightToken));
          },
        ),
      );
    } else if (left.value == null || right.value == null) {
      body = Center(
        child: TtEmptyState(
          icon: Icons.search_off_rounded,
          title: l10n.lookupMissTitle,
          body: l10n.lookupMissBody,
        ),
      );
    } else {
      body = ListView(
        padding: const EdgeInsets.all(TtSpace.page),
        children: [
          TtAppHeader(title: l10n.compareTitle, subtitle: l10n.compareSubtitle),
          const SizedBox(height: TtSpace.x3),
          _CompareTable(left: left.value!, right: right.value!, l10n: l10n),
          const SizedBox(height: TtSpace.x3),
          TtStatusBanner(
            message: l10n.compareNeutralNote,
            tone: TtBannerTone.info,
          ),
          const SizedBox(height: TtSpace.x4),
          Text(
            l10n.completionNotScore,
            textAlign: TextAlign.center,
            style: TtType.caption(palette.textSecondary),
          ),
          const SizedBox(height: TtSpace.x4),
        ],
      );
    }

    return Scaffold(body: SafeArea(child: body));
  }
}

class _CompareTable extends StatelessWidget {
  const _CompareTable({
    required this.left,
    required this.right,
    required this.l10n,
  });

  final ReportMatch left;
  final ReportMatch right;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final stats = _stats(context, l10n);
    return TtCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 5, child: SizedBox()),
                Expanded(
                  flex: 4,
                  child: _ColumnTitle(
                    name: _vehicleName(left),
                    token: left.snapshot.token,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: _ColumnTitle(
                    name: _vehicleName(right),
                    token: right.snapshot.token,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: palette.border),
          for (var i = 0; i < stats.length; i++) ...[
            if (i > 0) Divider(height: 1, color: palette.border),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      stats[i].label,
                      style: TtType.caption(palette.textSecondary),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      stats[i].left,
                      textAlign: TextAlign.center,
                      style: TtType.label(palette.textPrimary, size: 12.5),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      stats[i].right,
                      textAlign: TextAlign.center,
                      style: TtType.label(palette.textPrimary, size: 12.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<_Stat> _stats(BuildContext context, AppLocalizations l10n) {
    final leftPayload = left.payload;
    final rightPayload = right.payload;
    final leftOdometer = (leftPayload['odometer'] as Map)
        .cast<String, Object?>();
    final rightOdometer = (rightPayload['odometer'] as Map)
        .cast<String, Object?>();
    final leftRecords = (leftPayload['records'] as List)
        .cast<Map<String, Object?>>();
    final rightRecords = (rightPayload['records'] as List)
        .cast<Map<String, Object?>>();
    final leftCompleteness = (leftPayload['completeness'] as Map)
        .cast<String, Object?>();
    final rightCompleteness = (rightPayload['completeness'] as Map)
        .cast<String, Object?>();

    return [
      _Stat(
        l10n.metricCompletion,
        '${leftCompleteness['filled']}/${leftCompleteness['total']}',
        '${rightCompleteness['filled']}/${rightCompleteness['total']}',
      ),
      _Stat(
        l10n.metricRecords,
        '${leftRecords.length}',
        '${rightRecords.length}',
      ),
      _Stat(
        l10n.metricEvidence,
        '${_evidenceCount(leftRecords)}',
        '${_evidenceCount(rightRecords)}',
      ),
      _Stat(l10n.metricLatestKm, _km(leftPayload), _km(rightPayload)),
      _Stat(
        l10n.metricAvgKmMonth,
        _average(leftOdometer),
        _average(rightOdometer),
      ),
      _Stat(
        l10n.metricOdometerFlags,
        '${(leftOdometer['flags'] as List).length}',
        '${(rightOdometer['flags'] as List).length}',
      ),
      _Stat(
        l10n.metricGaps,
        '${(leftOdometer['gaps'] as List).length}',
        '${(rightOdometer['gaps'] as List).length}',
      ),
      _Stat(
        l10n.metricFirstRecord,
        _firstRecord(leftRecords, context),
        _firstRecord(rightRecords, context),
      ),
    ];
  }

  static String _vehicleName(ReportMatch match) {
    final vehicle = (match.payload['vehicle'] as Map).cast<String, Object?>();
    return '${vehicle['make']} ${vehicle['model']}';
  }

  static int _evidenceCount(List<Map<String, Object?>> records) {
    var total = 0;
    for (final record in records) {
      total += (record['evidence'] as List?)?.length ?? 0;
    }
    return total;
  }

  static String _km(Map<String, Object?> payload) {
    final vehicle = (payload['vehicle'] as Map).cast<String, Object?>();
    final km = vehicle['latestKm'] as int?;
    return km == null ? '—' : Fmt.number(km);
  }

  static String _average(Map<String, Object?> odometer) {
    final average = odometer['averageKmPerMonth'] as num?;
    return average == null ? '—' : Fmt.number(average.round());
  }

  static String _firstRecord(
    List<Map<String, Object?>> records,
    BuildContext context,
  ) {
    if (records.isEmpty) return '—';
    final dates = [
      for (final record in records)
        DateTime.parse(record['event_date'] as String),
    ]..sort();
    return BsDate.formatBs(dates.first, nepali: context.isNepali);
  }
}

class _ColumnTitle extends StatelessWidget {
  const _ColumnTitle({required this.name, required this.token});

  final String name;
  final String token;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      children: [
        Text(
          name,
          textAlign: TextAlign.center,
          style: TtType.label(palette.textPrimary, size: 12.5),
        ),
        const SizedBox(height: 2),
        Text(
          token,
          textAlign: TextAlign.center,
          style: TtType.caption(palette.textSecondary, size: 9.5),
        ),
      ],
    );
  }
}

class _Stat {
  const _Stat(this.label, this.left, this.right);

  final String label;
  final String left;
  final String right;
}
