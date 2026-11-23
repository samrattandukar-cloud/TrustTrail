import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/prefs/app_prefs.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../core/widgets/tt_text_field.dart';
import '../../data/local/seed/seed_data.dart';
import '../../data/repositories/repositories.dart';
import '../report/report_providers.dart';
import 'buyer_result_screen.dart';
import 'saved_reports_screen.dart';
import 'scan_screen.dart';

class BuyerSearchScreen extends ConsumerStatefulWidget {
  const BuyerSearchScreen({super.key});

  @override
  ConsumerState<BuyerSearchScreen> createState() => _BuyerSearchScreenState();
}

class _BuyerSearchScreenState extends ConsumerState<BuyerSearchScreen> {
  final _controller = TextEditingController();
  var _busy = false;
  var _miss = false;
  var _recent = <String>[];

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(sharedPrefsProvider);
    _recent = prefs.getStringList(PrefKeys.recentSearches) ?? const [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search([String? input]) async {
    final query = (input ?? _controller.text).trim();
    if (query.isEmpty) return;
    setState(() {
      _busy = true;
      _miss = false;
    });
    try {
      final match = await ref.read(reportRepositoryProvider).search(query);
      if (!mounted) return;
      if (match == null) {
        setState(() => _miss = true);
      } else {
        await _remember(query);
        if (!mounted) return;
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BuyerResultScreen(token: match.snapshot.token),
          ),
        );
        if (mounted) setState(() {});
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remember(String query) async {
    final trimmed = query.trim();
    final next = [
      trimmed,
      ..._recent.where((item) => item != trimmed),
    ].take(5).toList();
    setState(() => _recent = next);
    await ref
        .read(sharedPrefsProvider)
        .setStringList(PrefKeys.recentSearches, next);
  }

  Future<void> _scan() async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(builder: (_) => const ScanScreen()),
    );
    if (code == null || code.isEmpty) return;
    _controller.text = code;
    await _search(code);
  }

  Future<void> _openSaved() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SavedReportsScreen()));
    ref.invalidate(savedReportsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final saved = ref.watch(savedReportsProvider).value ?? const [];

    return SafeArea(
      bottom: false,
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
            eyebrow: l10n.modeBuyer,
            title: l10n.buyerSearchTitle,
            subtitle: l10n.buyerRoleBody,
          ),
          const SizedBox(height: TtSpace.x4),
          TtSearchField(
            hint: l10n.searchHint,
            controller: _controller,
            onSubmitted: (_) => _search(),
          ),
          const SizedBox(height: TtSpace.x2),
          Row(
            children: [
              Expanded(
                child: TtPrimaryButton(
                  label: l10n.searchButton,
                  icon: Icons.search_rounded,
                  loading: _busy,
                  onPressed: () => _search(),
                ),
              ),
              const SizedBox(width: 8),
              TtCircleIconButton(
                icon: Icons.qr_code_scanner_rounded,
                tooltip: l10n.scanQr,
                filled: true,
                onPressed: _scan,
              ),
            ],
          ),
          if (_miss) ...[
            const SizedBox(height: TtSpace.x3),
            TtStatusBanner(
              message: '${l10n.lookupMissTitle}. ${l10n.lookupMissBody}',
              tone: TtBannerTone.warning,
            ),
            const SizedBox(height: TtSpace.x2),
            Text(
              l10n.tryDemoToken,
              style: TtType.caption(palette.textSecondary),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final token in DemoSeeder.demoTokens)
                  ActionChip(
                    label: Text(token),
                    onPressed: () {
                      _controller.text = token;
                      _search(token);
                    },
                  ),
              ],
            ),
          ],
          const SizedBox(height: TtSpace.x5),
          if (saved.isNotEmpty) ...[
            TtSectionHeader(
              title: l10n.savedReports,
              actionLabel: l10n.viewAll,
              onAction: _openSaved,
            ),
            const SizedBox(height: TtSpace.x2),
            TtCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  for (var i = 0; i < saved.length && i < 3; i++) ...[
                    if (i > 0) Divider(height: 1, color: palette.border),
                    ListTile(
                      leading: Icon(
                        Icons.bookmark_rounded,
                        color: palette.primary,
                      ),
                      title: Text(
                        saved[i].vehicleName,
                        style: TtType.label(palette.textPrimary, size: 13),
                      ),
                      subtitle: Text(
                        '${saved[i].plate} · ${saved[i].token}',
                        style: TtType.caption(palette.textSecondary, size: 11),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              BuyerResultScreen(token: saved[i].token),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: TtSpace.x4),
          ],
          if (_recent.isNotEmpty) ...[
            TtSectionHeader(title: l10n.recentSearches),
            const SizedBox(height: TtSpace.x2),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final query in _recent)
                  ActionChip(
                    avatar: const Icon(Icons.history_rounded, size: 16),
                    label: Text(query),
                    onPressed: () {
                      _controller.text = query;
                      _search(query);
                    },
                  ),
              ],
            ),
            const SizedBox(height: TtSpace.x4),
          ],
          TtStatusBanner(message: l10n.oneDeviceNote, tone: TtBannerTone.info),
        ],
      ),
    );
  }
}
