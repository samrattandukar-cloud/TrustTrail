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
import '../../core/widgets/tt_pills.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../features/auth/session.dart';
import '../../features/vehicles/add_vehicle_screen.dart';
import '../../features/vehicles/section_labels.dart';
import '../../features/vehicles/vehicle_detail_screen.dart';
import '../../features/vehicles/vehicle_photo.dart';
import '../settings/settings_screen.dart';
import 'garage_controller.dart';

class GarageScreen extends ConsumerWidget {
  const GarageScreen({
    super.key,
    required this.onOpenReminders,
    required this.onOpenProfile,
  });

  final VoidCallback onOpenReminders;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final session = ref.watch(sessionProvider).value;
    final garage = ref.watch(garageProvider);
    final summary = ref.watch(garageSummaryProvider).value;
    final user = session?.user;

    final entries = garage.value ?? const <GarageEntry>[];
    final attention = entries.fold<int>(
      0,
      (sum, entry) => sum + entry.attentionCount(DateTime.now()),
    );
    final lastEvents =
        entries.where((entry) => entry.lastEvent != null).toList()
          ..sort((a, b) => b.lastEvent!.compareTo(a.lastEvent!));

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: () => ref.read(garageProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            TtSpace.page,
            12,
            TtSpace.page,
            TtSpace.bottomClearance,
          ),
          children: [
            TtAppHeader(
              showBack: false,
              eyebrow: l10n.yourGarage,
              title: l10n.namasteUser(user?.firstName ?? ''),
              subtitle: l10n.garageSubtitle,
              actions: [
                TtCircleIconButton(
                  icon: Icons.settings_outlined,
                  tooltip: l10n.settingsTitle,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SettingsScreen(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TtSpace.x4),
            if (garage.isLoading && entries.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (garage.hasError)
              TtErrorState(
                title: l10n.errorGeneric,
                body: l10n.errorDatabase,
                retryLabel: l10n.commonRetry,
                onRetry: () => ref.invalidate(garageProvider),
              )
            else ...[
              _SummaryStrip(
                records: entries.fold<int>(0, (sum, e) => sum + e.recordCount),
                evidence: entries.fold<int>(
                  0,
                  (sum, e) => sum + e.evidenceCount,
                ),
                reports: summary?.reports ?? 0,
              ),
              if (attention > 0) ...[
                const SizedBox(height: TtSpace.x3),
                TtStatusBanner(
                  message: l10n.overdueReminderBanner(attention, l10n.overdue),
                  tone: TtBannerTone.warning,
                  action: TextButton(
                    onPressed: onOpenReminders,
                    child: Text(l10n.viewAll),
                  ),
                ),
              ],
              const SizedBox(height: TtSpace.x5),
              TtSectionHeader(
                title: l10n.navGarage,
                actionLabel: l10n.addVehicle,
                onAction: () => _addVehicle(context, ref),
              ),
              const SizedBox(height: TtSpace.x2),
              if (entries.isEmpty)
                TtCard(
                  child: TtEmptyState(
                    icon: Icons.garage_outlined,
                    title: l10n.emptyGarageTitle,
                    body: l10n.emptyGarageBody,
                    compact: true,
                    action: TtPrimaryButton(
                      label: l10n.addVehicle,
                      icon: Icons.add_rounded,
                      onPressed: () => _addVehicle(context, ref),
                      expand: false,
                    ),
                  ),
                )
              else
                for (final entry in entries) ...[
                  _VehicleCard(entry: entry),
                  const SizedBox(height: TtSpace.x3),
                ],
              if (lastEvents.isNotEmpty) ...[
                const SizedBox(height: TtSpace.x4),
                TtSectionHeader(title: l10n.recentActivity),
                const SizedBox(height: TtSpace.x2),
                TtCard(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      for (var i = 0; i < lastEvents.length && i < 4; i++)
                        _ActivityRow(entry: lastEvents[i], showDivider: i != 0),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: TtSpace.x4),
              Center(
                child: TextButton.icon(
                  onPressed: onOpenProfile,
                  icon: const Icon(Icons.person_outline_rounded, size: 18),
                  label: Text(l10n.profileTitle),
                ),
              ),
              const SizedBox(height: TtSpace.x2),
              Text(
                l10n.demoBuild,
                textAlign: TextAlign.center,
                style: TtType.caption(palette.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _addVehicle(BuildContext context, WidgetRef ref) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AddVehicleScreen()));
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({
    required this.records,
    required this.evidence,
    required this.reports,
  });

  final int records;
  final int evidence;
  final int reports;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    return TtCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      color: palette.navy,
      borderColor: palette.navy,
      child: Row(
        children: [
          _Stat(value: '$records', label: l10n.statRecords),
          _Divider(color: palette.surface.withValues(alpha: 0.2)),
          _Stat(value: '$evidence', label: l10n.evidenceTitle),
          _Divider(color: palette.surface.withValues(alpha: 0.2)),
          _Stat(value: '$reports', label: l10n.statReports),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TtType.title(
              palette.surface,
              size: 22,
            ).copyWith(fontFeatures: TtType.tabular),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TtType.label(
              palette.surface.withValues(alpha: 0.72),
              size: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 30, color: color);
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.entry});

  final GarageEntry entry;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    final vehicle = entry.vehicle;
    return TtCard(
      padding: const EdgeInsets.all(12),
      onTap: () => _open(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VehiclePhoto(
            asset: vehicle.photoAsset,
            width: 96,
            height: 96,
            radius: 12,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        vehicle.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TtType.title(palette.textPrimary, size: 16),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: palette.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${vehicle.yearAd} · '
                  '${fuelLabel(vehicle.fuel, context.l10n)} · '
                  '${transmissionLabel(vehicle.transmission, context.l10n)}',
                  style: TtType.caption(palette.textSecondary),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    TtPlateChip(
                      roman: vehicle.plateRoman,
                      devanagari: vehicle.plateDevanagari,
                      compact: true,
                    ),
                    TtPill(
                      label: Fmt.km(entry.latestKm),
                      icon: Icons.speed_rounded,
                      compact: true,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    TtCompletenessMeter(
                      filled: entry.completeness.filled,
                      total: entry.completeness.total,
                      showCaption: false,
                      compact: true,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.completionMeter,
                            style: TtType.label(
                              palette.textPrimary,
                              size: 11.5,
                            ),
                          ),
                          Text(
                            l10n.recordEvidenceSummary(
                              entry.recordCount,
                              entry.evidenceCount,
                            ),
                            style: TtType.caption(
                              palette.textSecondary,
                              size: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VehicleDetailScreen(vehicleId: entry.vehicle.id),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.entry, required this.showDivider});

  final GarageEntry entry;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final date = entry.lastEvent;
    return Column(
      children: [
        if (showDivider) Divider(height: 1, color: palette.border),
        ListTile(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => VehicleDetailScreen(vehicleId: entry.vehicle.id),
            ),
          ),
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: palette.surfaceRaised,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 19,
              color: palette.primary,
            ),
          ),
          title: Text(
            entry.vehicle.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TtType.label(palette.textPrimary, size: 13),
          ),
          subtitle: Text(
            date == null ? '—' : Fmt.dateWithBs(date, nepali: context.isNepali),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TtType.caption(palette.textSecondary, size: 11),
          ),
          trailing: Text(
            Fmt.km(entry.latestKm),
            style: TtType.data(palette.textSecondary, size: 11.5),
          ),
        ),
      ],
    );
  }
}
