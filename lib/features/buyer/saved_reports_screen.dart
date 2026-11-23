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
import '../../data/local/seed/seed_data.dart';
import '../../data/repositories/repositories.dart';
import '../buyer/buyer_result_screen.dart';
import '../report/report_providers.dart';
import 'compare_reports_screen.dart';

class SavedReportsScreen extends ConsumerStatefulWidget {
  const SavedReportsScreen({
    super.key,
    this.embedded = false,
    this.onSelectingChanged,
  });

  final bool embedded;
  final ValueChanged<bool>? onSelectingChanged;

  @override
  ConsumerState<SavedReportsScreen> createState() => _SavedReportsScreenState();
}

class _SavedReportsScreenState extends ConsumerState<SavedReportsScreen> {
  var _selecting = false;
  final _selected = <String>[];

  void _toggleSelecting() {
    setState(() {
      _selecting = !_selecting;
      _selected.clear();
    });
    widget.onSelectingChanged?.call(_selecting);
  }

  void _toggleReport(String token) {
    setState(() {
      if (_selected.contains(token)) {
        _selected.remove(token);
      } else if (_selected.length < 2) {
        _selected.add(token);
      }
    });
  }

  Future<void> _openCompare() async {
    final tokens = [..._selected];
    if (tokens.length != 2) return;
    setState(() {
      _selecting = false;
      _selected.clear();
    });
    widget.onSelectingChanged?.call(false);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            CompareReportsScreen(leftToken: tokens[0], rightToken: tokens[1]),
      ),
    );
  }

  Future<void> _openSample() async {
    final l10n = context.l10n;
    final token = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final palette = sheetContext.palette;
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Text(
                l10n.demoTokensTitle,
                style: TtType.title(palette.textPrimary, size: 18),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.demoTokensBody,
                style: TtType.bodyMedium(palette.textSecondary),
              ),
              const SizedBox(height: 8),
              for (final demoToken in DemoSeeder.demoTokens)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.description_outlined,
                    color: palette.primary,
                  ),
                  title: Text(demoToken),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: palette.textSecondary,
                  ),
                  onTap: () => Navigator.pop(sheetContext, demoToken),
                ),
            ],
          ),
        );
      },
    );
    if (token == null || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => BuyerResultScreen(token: token)),
    );
    if (mounted) ref.invalidate(savedReportsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final async = ref.watch(savedReportsProvider);

    return Scaffold(
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: TtErrorState(
              title: l10n.errorGeneric,
              body: l10n.errorSavedReports,
              retryLabel: l10n.commonRetry,
              onRetry: () => ref.invalidate(savedReportsProvider),
            ),
          ),
          data: (reports) => ListView(
            padding: EdgeInsets.fromLTRB(
              TtSpace.page,
              12,
              TtSpace.page,
              widget.embedded ? TtSpace.bottomClearance : TtSpace.x9,
            ),
            children: [
              TtAppHeader(
                showBack: !widget.embedded,
                title: l10n.savedReports,
                subtitle: _selecting
                    ? l10n.compareSelectTwo
                    : (reports.isEmpty ? null : l10n.savedReportsHint),
                actions: [
                  if (reports.length > 1)
                    TtCircleIconButton(
                      icon: _selecting
                          ? Icons.close_rounded
                          : Icons.compare_arrows_rounded,
                      tooltip: _selecting ? l10n.commonCancel : l10n.compare,
                      onPressed: _toggleSelecting,
                    ),
                ],
              ),
              const SizedBox(height: TtSpace.x4),
              if (reports.isEmpty)
                TtCard(
                  child: TtEmptyState(
                    icon: Icons.bookmark_border_rounded,
                    title: l10n.noSavedTitle,
                    body: l10n.noSavedBody,
                    compact: true,
                    action: TtSecondaryButton(
                      label: l10n.trySampleReport,
                      icon: Icons.visibility_outlined,
                      expand: false,
                      onPressed: _openSample,
                    ),
                  ),
                )
              else
                for (final report in reports) ...[
                  _SavedReportCard(
                    report: report,
                    selecting: _selecting,
                    selected: _selected.contains(report.token),
                    onTap: () {
                      if (_selecting) {
                        _toggleReport(report.token);
                        return;
                      }
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  BuyerResultScreen(token: report.token),
                            ),
                          )
                          .then((_) {
                            if (mounted) ref.invalidate(savedReportsProvider);
                          });
                    },
                    onRemove: () async {
                      await ref
                          .read(reportRepositoryProvider)
                          .removeSaved(report.token);
                      ref.invalidate(savedReportsProvider);
                    },
                  ),
                  const SizedBox(height: TtSpace.x2),
                ],
              if (!widget.embedded) ...[
                const SizedBox(height: TtSpace.x4),
                TtSecondaryButton(
                  label: l10n.buyerSearchTitle,
                  icon: Icons.search_rounded,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: _selecting
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  TtSpace.page,
                  8,
                  TtSpace.page,
                  16,
                ),
                child: TtPrimaryButton(
                  label: l10n.compare,
                  icon: Icons.compare_arrows_rounded,
                  onPressed: _selected.length == 2 ? _openCompare : null,
                ),
              ),
            )
          : null,
    );
  }
}

class _SavedReportCard extends StatelessWidget {
  const _SavedReportCard({
    required this.report,
    required this.selecting,
    required this.selected,
    required this.onTap,
    required this.onRemove,
  });

  final SavedReportSummary report;
  final bool selecting;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    return TtCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: palette.surfaceRaised,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.description_outlined, color: palette.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.vehicleName,
                  style: TtType.label(palette.textPrimary, size: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  '${report.plate} · ${report.token}',
                  style: TtType.caption(palette.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '${report.filled}/${report.total} · '
                  '${l10n.savedOn(Fmt.dateWithBs(report.savedAt, nepali: context.isNepali))}',
                  style: TtType.caption(palette.textSecondary, size: 10.5),
                ),
              ],
            ),
          ),
          if (selecting)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? palette.primary : palette.textSecondary,
              ),
            )
          else
            IconButton(
              tooltip: l10n.removeSaved,
              icon: const Icon(Icons.bookmark_remove_outlined),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
