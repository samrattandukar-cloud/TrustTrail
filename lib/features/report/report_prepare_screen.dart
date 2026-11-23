import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_completeness_meter.dart';
import '../../core/widgets/tt_empty_state.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../data/repositories/repositories.dart';
import '../garage/garage_controller.dart';
import '../vehicles/vehicle_bundle.dart';
import 'report_generating_screen.dart';

class ReportPrepareScreen extends ConsumerStatefulWidget {
  const ReportPrepareScreen({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  ConsumerState<ReportPrepareScreen> createState() =>
      _ReportPrepareScreenState();
}

class _ReportPrepareScreenState extends ConsumerState<ReportPrepareScreen> {
  var _includeCosts = true;
  var _includeEvidence = true;
  var _busy = false;

  Future<void> _generate() async {
    final bundle = ref.read(vehicleBundleProvider(widget.vehicleId)).value;
    if (bundle == null) return;
    setState(() => _busy = true);
    try {
      final snapshot = await ref
          .read(reportRepositoryProvider)
          .create(
            vehicle: bundle.vehicle,
            records: bundle.records,
            evidence: bundle.evidence,
            includeCosts: _includeCosts,
            includeEvidence: _includeEvidence,
          );
      ref.invalidate(garageSummaryProvider);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ReportGeneratingScreen(token: snapshot.token),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final bundle = ref.watch(vehicleBundleProvider(widget.vehicleId));

    return Scaffold(
      body: SafeArea(
        child: bundle.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: TtErrorState(
              title: l10n.errorGeneric,
              body: l10n.errorPrepareVehicle,
              retryLabel: l10n.commonRetry,
              onRetry: () =>
                  ref.invalidate(vehicleBundleProvider(widget.vehicleId)),
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
            final completeness = data.completeness;
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(TtSpace.page),
                    children: [
                      TtAppHeader(
                        title: l10n.reportPrepareTitle,
                        subtitle: l10n.reportPrepareBody,
                      ),
                      const SizedBox(height: TtSpace.x4),
                      TtCard(
                        color: palette.surfaceRaised,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TtCompletenessMeter(
                              filled: completeness.filled,
                              total: completeness.total,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${l10n.documentedPercent(completeness.percent)} · '
                              '${l10n.recordEvidenceSummary(data.records.length, data.evidenceCount)}',
                              style: TtType.caption(palette.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: TtSpace.x4),
                      TtCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            SwitchListTile(
                              value: _includeCosts,
                              onChanged: (value) =>
                                  setState(() => _includeCosts = value),
                              title: Text(
                                l10n.includeCosts,
                                style: TtType.label(
                                  palette.textPrimary,
                                  size: 14,
                                ),
                              ),
                              subtitle: Text(
                                l10n.includeCostsBody,
                                style: TtType.caption(palette.textSecondary),
                              ),
                              secondary: const Icon(Icons.payments_outlined),
                            ),
                            Divider(height: 1, color: palette.border),
                            SwitchListTile(
                              value: _includeEvidence,
                              onChanged: (value) =>
                                  setState(() => _includeEvidence = value),
                              title: Text(
                                l10n.includeEvidence,
                                style: TtType.label(
                                  palette.textPrimary,
                                  size: 14,
                                ),
                              ),
                              subtitle: Text(
                                l10n.includeEvidenceBody,
                                style: TtType.caption(palette.textSecondary),
                              ),
                              secondary: const Icon(
                                Icons.photo_library_outlined,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: TtSpace.x4),
                      TtStatusBanner(
                        message: l10n.snapshotFreezeNote,
                        tone: TtBannerTone.info,
                      ),
                      const SizedBox(height: TtSpace.x2),
                      TtStatusBanner(
                        message: l10n.completionNotScore,
                        tone: TtBannerTone.success,
                      ),
                      const SizedBox(height: TtSpace.x4),
                      Text(
                        '${data.vehicle.displayName} · ${data.vehicle.plateRoman}',
                        style: TtType.caption(palette.textSecondary),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    TtSpace.page,
                    8,
                    TtSpace.page,
                    16,
                  ),
                  child: TtPrimaryButton(
                    label: l10n.generateReport,
                    icon: Icons.auto_awesome_rounded,
                    loading: _busy,
                    onPressed: _generate,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
