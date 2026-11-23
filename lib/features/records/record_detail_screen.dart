import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_empty_state.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_pills.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../data/models/vehicle_record.dart';
import '../../data/repositories/repositories.dart';
import '../evidence/evidence_section.dart';
import '../evidence/evidence_service.dart';
import '../garage/garage_controller.dart';
import '../vehicles/vehicle_bundle.dart';
import 'category_style.dart';
import 'record_detail_controller.dart';
import 'record_form_screen.dart';

class RecordDetailScreen extends ConsumerWidget {
  const RecordDetailScreen({
    super.key,
    required this.recordId,
    this.justSaved = false,
    this.readOnly = false,
  });

  final String recordId;
  final bool justSaved;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final detail = ref.watch(recordDetailProvider(recordId));

    return Scaffold(
      body: SafeArea(
        child: detail.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: TtErrorState(
              title: l10n.errorGeneric,
              body: l10n.errorRecordLoad,
              retryLabel: l10n.commonRetry,
              onRetry: () => ref.invalidate(recordDetailProvider(recordId)),
            ),
          ),
          data: (data) {
            if (data == null) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(TtSpace.page),
                    child: TtAppHeader(title: ''),
                  ),
                  TtEmptyState(
                    icon: Icons.search_off_rounded,
                    title: l10n.lookupMissTitle,
                    body: l10n.lookupMissBody,
                  ),
                ],
              );
            }
            final record = data.record;
            return ListView(
              padding: const EdgeInsets.all(TtSpace.page),
              children: [
                TtAppHeader(
                  title: l10n.recordDetails,
                  actions: readOnly
                      ? const []
                      : [
                          TtCircleIconButton(
                            icon: Icons.edit_outlined,
                            tooltip: l10n.commonEdit,
                            onPressed: () => Navigator.of(context)
                                .push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => RecordFormScreen(
                                      vehicleId: record.vehicleId,
                                      existing: record,
                                    ),
                                  ),
                                )
                                .then(
                                  (_) => ref.invalidate(
                                    recordDetailProvider(recordId),
                                  ),
                                ),
                          ),
                          TtCircleIconButton(
                            icon: Icons.delete_outline_rounded,
                            tooltip: l10n.commonDelete,
                            onPressed: () => _confirmDelete(context, ref, data),
                          ),
                        ],
                ),
                const SizedBox(height: TtSpace.x3),
                if (justSaved) ...[
                  TtStatusBanner(
                    message: l10n.recordSaved,
                    tone: TtBannerTone.success,
                  ),
                  const SizedBox(height: TtSpace.x3),
                ],
                TtCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          TtPill(
                            label: record.category.label(l10n),
                            icon: record.category.icon,
                            foreground: context.palette.primary,
                            background: context.palette.surfaceRaised,
                          ),
                          if (record.source == RecordSource.ownerRecorded)
                            const SelfReportedPill(),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        record.title,
                        style: TtType.title(
                          context.palette.textPrimary,
                          size: 19,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Fmt.dateWithBs(
                          record.eventDate,
                          nepali: context.isNepali,
                        ),
                        style: TtType.caption(context.palette.textSecondary),
                      ),
                      const SizedBox(height: TtSpace.x4),
                      _Row(
                        label: l10n.category,
                        value: record.category.label(l10n),
                      ),
                      _Row(
                        label: l10n.odometer,
                        value: record.odometerKm == null
                            ? '—'
                            : Fmt.km(record.odometerKm!),
                      ),
                      _Row(label: l10n.workshop, value: record.workshop ?? '—'),
                      _Row(label: l10n.cost, value: Fmt.npr(record.costNpr)),
                      _Row(
                        label: l10n.documentNo,
                        value: record.documentNo ?? '—',
                      ),
                      _Row(
                        label: l10n.source,
                        value: switch (record.source) {
                          RecordSource.ownerRecorded => l10n.sourceOwner,
                          RecordSource.workshopReceipt => l10n.sourceWorkshop,
                          RecordSource.officialDocument => l10n.sourceOfficial,
                        },
                        last:
                            record.description == null ||
                            record.description!.isEmpty,
                      ),
                      if (record.description != null &&
                          record.description!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          record.description!,
                          style: TtType.bodyMedium(
                            context.palette.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: TtSpace.x4),
                EvidenceSection(
                  recordId: record.id,
                  vehicleId: record.vehicleId,
                  evidence: data.evidence,
                  readOnly: readOnly,
                ),
                const SizedBox(height: TtSpace.x4),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    RecordDetail data,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteRecord),
        content: Text(l10n.deleteRecordBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await EvidenceService.deleteFiles(data.evidence);
    await ref.read(recordRepositoryProvider).delete(data.record.id);
    ref.invalidate(recordDetailProvider(recordId));
    ref.invalidate(vehicleBundleProvider(data.record.vehicleId));
    ref.invalidate(garageProvider);
    ref.invalidate(garageSummaryProvider);
    if (context.mounted) Navigator.of(context).pop();
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.last = false});

  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(label, style: TtType.caption(palette.textSecondary)),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TtType.label(palette.textPrimary, size: 12.5),
              ),
            ),
          ],
        ),
        if (!last) Divider(height: 16, color: palette.border),
      ],
    );
  }
}
