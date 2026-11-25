import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/bs_date.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_completeness_meter.dart';
import '../../core/widgets/tt_odometer_chart.dart';
import '../../core/widgets/tt_pills.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../data/repositories/report_repository.dart';
import '../../domain/odometer_analysis.dart';
import '../records/category_style.dart';
import '../vehicles/section_labels.dart';
import '../vehicles/vehicle_photo.dart';

/// The in-app dossier, used by the owner preview and the buyer result.
class ReportDossier extends StatelessWidget {
  const ReportDossier({
    super.key,
    required this.match,
    this.onRecordTap,
    this.showObservations = true,
    this.categoryFilter,
    this.showVehicleCard = true,
    this.showCompletenessCard = true,
  });

  final ReportMatch match;
  final void Function(Map<String, Object?> record)? onRecordTap;
  final bool showObservations;
  final String? categoryFilter;
  final bool showVehicleCard;
  final bool showCompletenessCard;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final payload = match.payload;
    final vehicle = (payload['vehicle'] as Map).cast<String, Object?>();
    final records = (payload['records'] as List).cast<Map<String, Object?>>();
    final visibleRecords = categoryFilter == null
        ? records
        : records
              .where((record) => record['category'] == categoryFilter)
              .toList();
    final completeness = (payload['completeness'] as Map)
        .cast<String, Object?>();
    final odometer = (payload['odometer'] as Map).cast<String, Object?>();
    final includeCosts = payload['includeCosts'] == true;
    final generated =
        DateTime.tryParse(payload['generatedAt'] as String? ?? '') ??
        match.snapshot.createdAt;
    final missing = (completeness['missing'] as List).cast<String>();
    final readings = [
      for (final item
          in (odometer['readings'] as List).cast<Map<String, Object?>>())
        OdometerReading(
          date: DateTime.parse(item['date'] as String),
          km: item['km'] as int,
          recordId: item['recordId'] as String?,
        ),
    ];
    final flags = [
      for (final item
          in (odometer['flags'] as List).cast<Map<String, Object?>>())
        OdometerFlag(
          from: DateTime.parse(item['from'] as String),
          to: DateTime.parse(item['to'] as String),
          issue: item['issue'] == 'decrease'
              ? OdometerIssue.decrease
              : OdometerIssue.implausibleRate,
          fromKm: item['fromKm'] as int,
          toKm: item['toKm'] as int,
        ),
    ];
    final gaps = (odometer['gaps'] as List).cast<Map<String, Object?>>();
    final photo = vehicle['photo_asset'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showVehicleCard) ...[
          TtCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VehiclePhoto(
                  asset: photo == null
                      ? null
                      : photo.startsWith('asset:')
                      ? photo.substring(6)
                      : photo,
                  height: 168,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${vehicle['make']} ${vehicle['model']}',
                              style: TtType.title(
                                palette.textPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                          TtPill(
                            label: match.snapshot.token,
                            icon: Icons.qr_code_2_rounded,
                            foreground: palette.primary,
                            background: palette.surfaceRaised,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${vehicle['plate_roman']} · ${vehicle['year_ad']} · '
                        '${fuelLabel('${vehicle['fuel']}', l10n)} · '
                        '${transmissionLabel('${vehicle['transmission']}', l10n)}',
                        style: TtType.caption(palette.textSecondary),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          TtPill(
                            label:
                                '${Fmt.number(vehicle['latestKm'] as int? ?? 0)} km',
                            icon: Icons.speed_rounded,
                          ),
                          TtPill(
                            label: l10n.recordsCount(records.length),
                            icon: Icons.receipt_long_outlined,
                          ),
                          if (vehicle['province'] != null)
                            TtPill(
                              label: provinceLabel(
                                '${vehicle['province']}',
                                l10n,
                              ),
                              icon: Icons.place_outlined,
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.generatedOn(
                          BsDate.both(generated, nepali: context.isNepali),
                        ),
                        style: TtType.caption(palette.textSecondary, size: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: TtSpace.x3),
        ],
        if (showCompletenessCard) ...[
          TtCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TtCompletenessMeter(
                  filled: completeness['filled'] as int,
                  total: completeness['total'] as int,
                ),
                const SizedBox(height: 8),
                Text(
                  missing.isEmpty
                      ? l10n.allSectionsPresent
                      : l10n.missingListLabel(
                          missing
                              .map((raw) => sectionLabel(raw, l10n))
                              .join(', '),
                        ),
                  style: TtType.caption(
                    missing.isEmpty ? palette.success : palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: TtSpace.x3),
        ],
        TtCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.odometerTrend,
                style: TtType.section(palette.textPrimary),
              ),
              const SizedBox(height: 8),
              TtOdometerChart(readings: readings, flags: flags),
              if (odometer['averageKmPerMonth'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.odometerAverageSummary(
                      Fmt.number(
                        ((odometer['averageKmPerMonth'] as num).round()),
                      ),
                      readings.length,
                    ),
                    style: TtType.caption(palette.textSecondary),
                  ),
                ),
              if (showObservations && gaps.isNotEmpty) ...[
                const SizedBox(height: 10),
                for (final gap in gaps)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '• ${l10n.gapNoteSentence(BsDate.both(DateTime.parse(gap['from'] as String), nepali: context.isNepali), BsDate.both(DateTime.parse(gap['to'] as String), nepali: context.isNepali), ((gap['months'] as num).toDouble()).toStringAsFixed(1))}',
                      style: TtType.caption(palette.textPrimary),
                    ),
                  ),
              ],
              if (showObservations && flags.isNotEmpty) ...[
                const SizedBox(height: 4),
                for (final flag in flags)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      flag.issue == OdometerIssue.decrease
                          ? '• ${l10n.odometerDecreaseSentence(Fmt.number(flag.fromKm), Fmt.number(flag.toKm), BsDate.both(flag.from, nepali: context.isNepali), BsDate.both(flag.to, nepali: context.isNepali))}'
                          : '• ${l10n.highUsageSentence(BsDate.both(flag.from, nepali: context.isNepali), BsDate.both(flag.to, nepali: context.isNepali))}',
                      style: TtType.caption(palette.error),
                    ),
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: TtSpace.x3),
        Text(l10n.recordedTimeline, style: TtType.section(palette.textPrimary)),
        const SizedBox(height: 8),
        if (visibleRecords.isEmpty)
          TtCard(
            child: Text(
              l10n.noSharedRecords,
              style: TtType.bodyMedium(palette.textSecondary),
            ),
          )
        else
          for (final record in visibleRecords) ...[
            _RecordTile(
              record: record,
              includeCosts: includeCosts,
              onTap: onRecordTap == null ? null : () => onRecordTap!(record),
            ),
            const SizedBox(height: 8),
          ],
        const SizedBox(height: TtSpace.x2),
        TtStatusBanner(
          message: l10n.dossierDisclaimer,
          tone: TtBannerTone.info,
        ),
      ],
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({
    required this.record,
    required this.includeCosts,
    this.onTap,
  });

  final Map<String, Object?> record;
  final bool includeCosts;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    final date = DateTime.parse(record['event_date'] as String);
    final evidence = (record['evidence'] as List).length;
    return TtCard(
      onTap: onTap,
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record['title'] as String,
                      style: TtType.label(palette.textPrimary, size: 13.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      BsDate.both(date, nepali: context.isNepali),
                      style: TtType.caption(palette.textSecondary, size: 11),
                    ),
                  ],
                ),
              ),
              if (includeCosts && record['cost_npr'] != null)
                Text(
                  Fmt.npr(record['cost_npr'] as int),
                  style: TtType.data(palette.textPrimary, size: 11.5),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              TtPill(
                label: categoryLabel('${record['category']}', context.l10n),
                compact: true,
                foreground: palette.primary,
                background: palette.surfaceRaised,
              ),
              if (record['odometer_km'] != null)
                TtPill(
                  label: Fmt.km(record['odometer_km'] as int),
                  icon: Icons.speed_rounded,
                  compact: true,
                ),
              if (evidence > 0)
                TtPill(
                  label: l10n.evidenceAttachedShort(evidence),
                  icon: Icons.attach_file_rounded,
                  compact: true,
                  foreground: palette.success,
                  background: palette.success.withValues(alpha: 0.12),
                )
              else
                const SelfReportedPill(),
            ],
          ),
        ],
      ),
    );
  }
}
