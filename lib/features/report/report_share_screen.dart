import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_empty_state.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../data/repositories/report_repository.dart';
import '../../data/repositories/repositories.dart';
import 'report_providers.dart';

class ReportShareScreen extends ConsumerStatefulWidget {
  const ReportShareScreen({super.key, required this.token});

  final String token;

  @override
  ConsumerState<ReportShareScreen> createState() => _ReportShareScreenState();
}

class _ReportShareScreenState extends ConsumerState<ReportShareScreen> {
  var _busy = false;

  Future<void> _sharePdf(ReportMatch match) async {
    setState(() => _busy = true);
    try {
      await ReportExporter.sharePdf(ref, match);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _copy(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.copiedToClipboard)));
  }

  Future<void> _toggleSaved(bool currentlySaved) async {
    final repo = ref.read(reportRepositoryProvider);
    if (currentlySaved) {
      await repo.removeSaved(widget.token);
    } else {
      await repo.saveReport(widget.token);
    }
    ref.invalidate(reportSavedProvider(widget.token));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          currentlySaved ? context.l10n.removeSaved : context.l10n.saveReport,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final async = ref.watch(reportMatchProvider(widget.token));
    final saved = ref.watch(reportSavedProvider(widget.token));

    return Scaffold(
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: TtErrorState(
              title: l10n.errorGeneric,
              body: l10n.errorShareSheet,
              retryLabel: l10n.commonRetry,
              onRetry: () => ref.invalidate(reportMatchProvider(widget.token)),
            ),
          ),
          data: (match) {
            if (match == null) {
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
            final uri = ReportExporter.qrUri(widget.token);
            return ListView(
              padding: const EdgeInsets.all(TtSpace.page),
              children: [
                TtAppHeader(title: l10n.reportShareTitle),
                const SizedBox(height: TtSpace.x4),
                Center(
                  child: TtCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        QrImageView(
                          data: uri,
                          version: QrVersions.auto,
                          size: 190,
                          backgroundColor: Colors.white,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Color(0xFF0F2A4A),
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Color(0xFF0F2A4A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.token,
                          style: TtType.plate(palette.textPrimary, size: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${match.vehicle.make} ${match.vehicle.model} · '
                          '${ReportExporter.dates(match)}',
                          textAlign: TextAlign.center,
                          style: TtType.caption(palette.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: TtSpace.x4),
                Row(
                  children: [
                    Expanded(
                      child: TtSecondaryButton(
                        label: l10n.copyCode,
                        icon: Icons.copy_rounded,
                        onPressed: () => _copy(widget.token),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TtSecondaryButton(
                        label: l10n.copyLink,
                        icon: Icons.link_rounded,
                        onPressed: () => _copy(uri),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TtSpace.x2),
                TtPrimaryButton(
                  label: l10n.downloadPdf,
                  icon: Icons.picture_as_pdf_rounded,
                  loading: _busy,
                  onPressed: () => _sharePdf(match),
                ),
                const SizedBox(height: TtSpace.x2),
                TtSecondaryButton(
                  label: l10n.shareText,
                  icon: Icons.message_outlined,
                  onPressed: () => ReportExporter.shareText(match),
                ),
                const SizedBox(height: TtSpace.x2),
                saved.when(
                  loading: () => const SizedBox.shrink(),
                  error: (error, stack) => const SizedBox.shrink(),
                  data: (isSaved) => TtSecondaryButton(
                    label: isSaved ? l10n.removeSaved : l10n.saveReport,
                    icon: isSaved
                        ? Icons.bookmark_remove_outlined
                        : Icons.bookmark_add_outlined,
                    onPressed: () => _toggleSaved(isSaved),
                  ),
                ),
                const SizedBox(height: TtSpace.x4),
                TtStatusBanner(
                  message: l10n.oneDeviceNote,
                  tone: TtBannerTone.info,
                ),
                const SizedBox(height: TtSpace.x2),
                Text(
                  l10n.demoTokenNote,
                  style: TtType.caption(palette.textSecondary),
                ),
                const SizedBox(height: TtSpace.x4),
              ],
            );
          },
        ),
      ),
    );
  }
}
