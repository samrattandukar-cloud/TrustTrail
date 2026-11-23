import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_empty_state.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../data/repositories/report_repository.dart';
import 'report_dossier.dart';
import 'report_providers.dart';
import 'report_share_screen.dart';

class ReportPreviewScreen extends ConsumerStatefulWidget {
  const ReportPreviewScreen({super.key, required this.token});

  final String token;

  @override
  ConsumerState<ReportPreviewScreen> createState() =>
      _ReportPreviewScreenState();
}

class _ReportPreviewScreenState extends ConsumerState<ReportPreviewScreen> {
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final async = ref.watch(reportMatchProvider(widget.token));

    return Scaffold(
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: TtErrorState(
              title: l10n.errorGeneric,
              body: l10n.errorReportLoad,
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
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(TtSpace.page),
                    children: [
                      TtAppHeader(
                        title: l10n.reportPreviewTitle,
                        subtitle: l10n.completionNotScore,
                        actions: [
                          TtCircleIconButton(
                            icon: Icons.ios_share_rounded,
                            tooltip: l10n.shareReport,
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    ReportShareScreen(token: widget.token),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TtSpace.x3),
                      ReportDossier(match: match),
                      const SizedBox(height: TtSpace.x4),
                      Row(
                        children: [
                          Expanded(
                            child: TtPrimaryButton(
                              label: l10n.downloadPdf,
                              icon: Icons.picture_as_pdf_rounded,
                              loading: _busy,
                              onPressed: () => _sharePdf(match),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TtSecondaryButton(
                              label: l10n.shareReport,
                              icon: Icons.qr_code_2_rounded,
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      ReportShareScreen(token: widget.token),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TtSpace.x3),
                      TtStatusBanner(
                        message: l10n.oneDeviceNote,
                        tone: TtBannerTone.info,
                      ),
                      const SizedBox(height: TtSpace.x4),
                    ],
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
