import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_completeness_meter.dart';
import '../../core/widgets/tt_empty_state.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_odometer_chart.dart';
import '../../core/widgets/tt_pills.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../core/widgets/tt_timeline.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/completeness.dart';
import '../../domain/odometer_analysis.dart';
import '../garage/garage_controller.dart';
import '../records/record_detail_screen.dart';
import '../records/record_form_screen.dart';
import '../report/report_prepare_screen.dart';
import 'section_labels.dart';
import 'vehicle_bundle.dart';
import 'vehicle_photo.dart';
import 'vehicle_photo_service.dart';

class VehicleDetailScreen extends ConsumerWidget {
  const VehicleDetailScreen({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final bundle = ref.watch(vehicleBundleProvider(vehicleId));

    return Scaffold(
      body: bundle.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(TtSpace.page),
                child: TtAppHeader(title: ''),
              ),
              TtErrorState(
                title: l10n.errorGeneric,
                body: l10n.errorVehicleLoad,
                retryLabel: l10n.commonRetry,
                onRetry: () => ref.invalidate(vehicleBundleProvider(vehicleId)),
              ),
            ],
          ),
        ),
        data: (data) {
          if (data == null) {
            return SafeArea(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(TtSpace.page),
                    child: TtAppHeader(title: ''),
                  ),
                  TtEmptyState(
                    icon: Icons.directions_car_outlined,
                    title: l10n.lookupMissTitle,
                    body: l10n.lookupMissBody,
                  ),
                ],
              ),
            );
          }
          return _Content(bundle: data);
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.bundle});

  final VehicleBundle bundle;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    final vehicle = bundle.vehicle;
    final completeness = bundle.completeness;
    final odometer = bundle.odometer;
    final evidenceCounts = <String, int>{};
    for (final item in bundle.evidence) {
      evidenceCounts[item.recordId] = (evidenceCounts[item.recordId] ?? 0) + 1;
    }

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              VehiclePhoto(
                asset: vehicle.photoAsset,
                height: 230,
                width: double.infinity,
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.35),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.25),
                      ],
                      stops: const [0, 0.5, 1],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                top: 12,
                child: Row(
                  children: [
                    TtCircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const Spacer(),
                    _PhotoEditButton(
                      vehicleId: vehicle.id,
                      hasPhoto: vehicle.photoAsset != null,
                    ),
                    const SizedBox(width: 8),
                    TtCircleIconButton(
                      icon: Icons.qr_code_2_rounded,
                      tooltip: l10n.shareReport,
                      onPressed: () => _share(context, vehicle.id),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.displayName,
                      style: TtType.headline(Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        TtPlateChip(
                          roman: vehicle.plateRoman,
                          devanagari: vehicle.plateDevanagari,
                        ),
                        const SizedBox(width: 8),
                        TtPill(
                          label: '${vehicle.yearAd}',
                          icon: Icons.calendar_today_outlined,
                          compact: true,
                          foreground: Colors.white,
                          background: Colors.black.withValues(alpha: 0.35),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TtSpace.page,
              TtSpace.x4,
              TtSpace.page,
              TtSpace.x9,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    TtPill(
                      label: fuelLabel(vehicle.fuel, context.l10n),
                      icon: Icons.local_gas_station_outlined,
                    ),
                    TtPill(
                      label: transmissionLabel(
                        vehicle.transmission,
                        context.l10n,
                      ),
                      icon: Icons.settings_outlined,
                    ),
                    if (vehicle.color != null)
                      TtPill(
                        label: vehicle.color!,
                        icon: Icons.palette_outlined,
                      ),
                    if (vehicle.province != null)
                      TtPill(
                        label: provinceLabel(vehicle.province!, context.l10n),
                        icon: Icons.place_outlined,
                      ),
                  ],
                ),
                const SizedBox(height: TtSpace.x4),
                TtCard(
                  color: palette.navy,
                  borderColor: palette.navy,
                  child: Row(
                    children: [
                      _HeroStat(
                        label: l10n.odometer,
                        value: Fmt.number(bundle.latestKm),
                        unit: 'km',
                      ),
                      _HeroDivider(palette: palette),
                      _HeroStat(
                        label: l10n.statRecords,
                        value: '${bundle.records.length}',
                      ),
                      _HeroDivider(palette: palette),
                      _HeroStat(
                        label: l10n.evidenceTitle,
                        value: '${bundle.evidenceCount}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TtSpace.x4),
                Row(
                  children: [
                    Expanded(
                      child: TtPrimaryButton(
                        label: l10n.addRecord,
                        icon: Icons.add_rounded,
                        expand: false,
                        onPressed: () => Navigator.of(context)
                            .push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    RecordFormScreen(vehicleId: vehicle.id),
                              ),
                            )
                            .then((_) {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TtSecondaryButton(
                        label: l10n.shareReport,
                        icon: Icons.ios_share_rounded,
                        expand: false,
                        onPressed: () => _share(context, vehicle.id),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TtSpace.x6),
                TtSectionHeader(title: l10n.completionMeter),
                const SizedBox(height: TtSpace.x2),
                TtCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TtCompletenessMeter(
                        filled: completeness.filled,
                        total: completeness.total,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.incompleteSections(
                          completeness.total - completeness.filled,
                        ),
                        style: TtType.caption(palette.textSecondary),
                      ),
                      const SizedBox(height: TtSpace.x3),
                      for (final section in completeness.sections)
                        _SectionRow(state: section),
                    ],
                  ),
                ),
                const SizedBox(height: TtSpace.x6),
                TtSectionHeader(title: l10n.odometerTrend),
                const SizedBox(height: TtSpace.x2),
                TtCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TtOdometerChart(
                        readings: odometer.readings,
                        flags: odometer.flags,
                      ),
                      if (odometer.averageKmPerMonth != null) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            TtPill(
                              label: l10n.odometerAverage(
                                Fmt.number(odometer.averageKmPerMonth!.round()),
                              ),
                              icon: Icons.trending_up_rounded,
                            ),
                            const SizedBox(width: 6),
                            TtPill(
                              label: l10n.readingsCount(
                                odometer.readings.length,
                              ),
                              icon: Icons.speed_rounded,
                            ),
                          ],
                        ),
                      ],
                      if (odometer.gaps.isNotEmpty) ...[
                        const SizedBox(height: TtSpace.x3),
                        for (final gap in odometer.significantGaps)
                          _GapNote(gap: gap),
                        if (odometer.significantGaps.isEmpty)
                          TtStatusBanner(
                            message: context.l10n.noLongGapsNote,
                            tone: TtBannerTone.success,
                          ),
                      ],
                      if (odometer.flags.isNotEmpty) ...[
                        const SizedBox(height: TtSpace.x3),
                        for (final flag in odometer.flags)
                          _FlagNote(flag: flag),
                      ],
                      if (!odometer.hasReadings) ...[
                        const SizedBox(height: TtSpace.x3),
                        Text(
                          l10n.noRecordsBody,
                          style: TtType.caption(palette.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: TtSpace.x6),
                Row(
                  children: [
                    Expanded(
                      child: TtSectionHeader(title: l10n.recentActivity),
                    ),
                    Text(
                      l10n.recordsCount(bundle.records.length),
                      style: TtType.caption(palette.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: TtSpace.x2),
                if (bundle.records.isEmpty)
                  TtEmptyState(
                    icon: Icons.timeline_rounded,
                    title: l10n.noRecordsTitle,
                    body: l10n.noRecordsBody,
                    compact: true,
                    action: TtSecondaryButton(
                      label: l10n.addRecord,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              RecordFormScreen(vehicleId: vehicle.id),
                        ),
                      ),
                      expand: false,
                    ),
                  )
                else
                  TtTimeline(
                    records: bundle.records,
                    evidenceCounts: evidenceCounts,
                    onTap: (record) => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => RecordDetailScreen(recordId: record.id),
                      ),
                    ),
                  ),
                const SizedBox(height: TtSpace.x4),
                TtStatusBanner(
                  message: context.l10n.ownerRecordedLocalNote,
                  tone: TtBannerTone.info,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _share(BuildContext context, String vehicleId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReportPrepareScreen(vehicleId: vehicleId),
      ),
    );
  }
}

class _PhotoEditButton extends ConsumerStatefulWidget {
  const _PhotoEditButton({required this.vehicleId, required this.hasPhoto});

  final String vehicleId;
  final bool hasPhoto;

  @override
  ConsumerState<_PhotoEditButton> createState() => _PhotoEditButtonState();
}

class _PhotoEditButtonState extends ConsumerState<_PhotoEditButton> {
  var _busy = false;

  void _refresh() {
    ref.invalidate(vehicleBundleProvider(widget.vehicleId));
    ref.invalidate(garageProvider);
    ref.invalidate(garageSummaryProvider);
  }

  Future<void> _save(String? path) async {
    setState(() => _busy = true);
    try {
      await ref
          .read(vehicleRepositoryProvider)
          .setPhoto(widget.vehicleId, path);
      _refresh();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.uploadFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pick(VehiclePhotoSource source) async {
    setState(() => _busy = true);
    try {
      final path = await VehiclePhotoService.pick(source);
      if (path == null) {
        if (mounted) setState(() => _busy = false);
        return;
      }
      await _save(path);
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.uploadFailed)));
    }
  }

  Future<void> _sheet() async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(l10n.evidenceFromCamera),
                onTap: () {
                  Navigator.of(context).pop();
                  _pick(VehiclePhotoSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(l10n.evidenceFromGallery),
                onTap: () {
                  Navigator.of(context).pop();
                  _pick(VehiclePhotoSource.gallery);
                },
              ),
              if (widget.hasPhoto)
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded),
                  title: Text(l10n.removePhoto),
                  onTap: () {
                    Navigator.of(context).pop();
                    _save(null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    if (_busy) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: palette.surface,
          shape: BoxShape.circle,
          border: Border.all(color: palette.border),
        ),
        child: const Padding(
          padding: EdgeInsets.all(13),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return TtCircleIconButton(
      icon: widget.hasPhoto
          ? Icons.photo_camera_rounded
          : Icons.add_a_photo_rounded,
      tooltip: widget.hasPhoto ? l10n.changePhoto : l10n.addPhoto,
      onPressed: _sheet,
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value, this.unit});

  final String label;
  final String value;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TtType.title(
                  palette.surface,
                  size: 21,
                ).copyWith(fontFeatures: TtType.tabular),
              ),
              if (unit != null) ...[
                const SizedBox(width: 3),
                Text(
                  unit!,
                  style: TtType.label(
                    palette.surface.withValues(alpha: 0.65),
                    size: 10,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TtType.label(
              palette.surface.withValues(alpha: 0.7),
              size: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroDivider extends StatelessWidget {
  const _HeroDivider({required this.palette});

  final TtPalette palette;

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 32,
    color: palette.surface.withValues(alpha: 0.2),
  );
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.state});

  final SectionState state;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            state.filled
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: state.filled ? palette.success : palette.border,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              state.section.label(l10n),
              style: TtType.bodyMedium(
                state.filled ? palette.textPrimary : palette.textSecondary,
              ),
            ),
          ),
          if (!state.filled)
            Text(
              l10n.missingSections,
              style: TtType.caption(palette.textSecondary, size: 10.5),
            ),
        ],
      ),
    );
  }
}

class _GapNote extends StatelessWidget {
  const _GapNote({required this.gap});

  final OdometerGap gap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: palette.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: palette.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.timelapse_rounded, size: 17, color: palette.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.gapNote(
                Fmt.dateWithBs(gap.from, nepali: context.isNepali),
                Fmt.dateWithBs(gap.to, nepali: context.isNepali),
                gap.months.ceil(),
              ),
              style: TtType.caption(palette.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlagNote extends StatelessWidget {
  const _FlagNote({required this.flag});

  final OdometerFlag flag;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    final message = flag.issue == OdometerIssue.decrease
        ? l10n.flagDecreaseNote(Fmt.number(flag.fromKm), Fmt.number(flag.toKm))
        : l10n.flagHighUsageNote(
            Fmt.number(
              (flag.deltaKm *
                      30.44 /
                      flag.to.difference(flag.from).inDays.clamp(1, 99999))
                  .round(),
            ),
            Fmt.dateWithBs(flag.from, nepali: context.isNepali),
            Fmt.dateWithBs(flag.to, nepali: context.isNepali),
          );
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: palette.error.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: palette.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.speed_rounded, size: 17, color: palette.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: TtType.caption(palette.textPrimary)),
          ),
        ],
      ),
    );
  }
}
