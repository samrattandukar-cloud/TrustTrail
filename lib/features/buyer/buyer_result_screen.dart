import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_empty_state.dart';
import '../../core/widgets/tt_headers.dart';
import '../../data/repositories/report_repository.dart';
import '../../data/repositories/repositories.dart';
import '../records/category_style.dart';
import '../records/record_detail_screen.dart';
import '../report/report_dossier.dart';
import '../report/report_providers.dart';
import '../report/report_share_screen.dart';

class BuyerResultScreen extends ConsumerStatefulWidget {
  const BuyerResultScreen({super.key, required this.token});

  final String token;

  @override
  ConsumerState<BuyerResultScreen> createState() => _BuyerResultScreenState();
}

class _BuyerResultScreenState extends ConsumerState<BuyerResultScreen> {
  String? _category;
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

  Future<void> _toggleSaved(bool saved) async {
    final repo = ref.read(reportRepositoryProvider);
    if (saved) {
      await repo.removeSaved(widget.token);
    } else {
      await repo.saveReport(widget.token);
    }
    ref.invalidate(reportSavedProvider(widget.token));
    ref.invalidate(savedReportsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final async = ref.watch(reportMatchProvider(widget.token));
    final saved = ref.watch(reportSavedProvider(widget.token)).value ?? false;

    return Scaffold(
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: TtErrorState(
              title: l10n.errorGeneric,
              body: l10n.errorReportOpen,
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
                    action: TtSecondaryButton(
                      label: l10n.commonBack,
                      onPressed: () => Navigator.of(context).maybePop(),
                      expand: false,
                    ),
                  ),
                ],
              );
            }
            final records = (match.payload['records'] as List)
                .cast<Map<String, Object?>>();
            final categories = <String>{
              for (final record in records) record['category'] as String,
            }.toList()..sort();
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(TtSpace.page),
                    children: [
                      TtAppHeader(
                        title: l10n.reportPreviewTitle,
                        subtitle:
                            '${match.vehicle.displayName} · ${match.snapshot.token}',
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
                      const SizedBox(height: TtSpace.x2),
                      Row(
                        children: [
                          Expanded(
                            child: TtSecondaryButton(
                              label: saved ? l10n.removeSaved : l10n.saveReport,
                              icon: saved
                                  ? Icons.bookmark_remove_outlined
                                  : Icons.bookmark_add_outlined,
                              onPressed: () => _toggleSaved(saved),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TtPrimaryButton(
                              label: l10n.downloadPdf,
                              icon: Icons.picture_as_pdf_rounded,
                              loading: _busy,
                              onPressed: () => _sharePdf(match),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TtSpace.x3),
                      if (categories.length > 1)
                        SizedBox(
                          height: 38,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ChoiceChip(
                                label: Text(l10n.viewAll),
                                selected: _category == null,
                                onSelected: (_) =>
                                    setState(() => _category = null),
                              ),
                              const SizedBox(width: 6),
                              for (final category in categories) ...[
                                ChoiceChip(
                                  label: Text(categoryLabel(category, l10n)),
                                  selected: _category == category,
                                  onSelected: (_) =>
                                      setState(() => _category = category),
                                ),
                                const SizedBox(width: 6),
                              ],
                            ],
                          ),
                        ),
                      const SizedBox(height: TtSpace.x3),
                      ReportDossier(
                        match: match,
                        categoryFilter: _category,
                        onRecordTap: (record) => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => RecordDetailScreen(
                              recordId: record['id'] as String,
                              readOnly: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: TtSpace.x3),
                      Text(
                        l10n.completionNotScore,
                        textAlign: TextAlign.center,
                        style: TtType.caption(palette.textSecondary),
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
