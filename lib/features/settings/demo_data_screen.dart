import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/bootstrap.dart';
import '../../core/l10n/l10n.dart';
import '../../core/prefs/app_prefs.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/repositories.dart';
import '../auth/session.dart';
import '../garage/garage_controller.dart';

class DemoDataScreen extends ConsumerStatefulWidget {
  const DemoDataScreen({super.key});

  @override
  ConsumerState<DemoDataScreen> createState() => _DemoDataScreenState();
}

class _DemoDataScreenState extends ConsumerState<DemoDataScreen> {
  late Future<({int count, int bytes})> _usage;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _usage = ref.read(evidenceRepositoryProvider).usage();
  }

  Future<void> _reset() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetDemo),
        content: Text('${l10n.resetDemoBody}\n\n${l10n.deleteRecordBody}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.resetDemo),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      await resetDemoData(ref.read(databaseProvider));
      await ref.read(sharedPrefsProvider).remove(PrefKeys.recentSearches);
      ref.invalidate(sessionProvider);
      ref.invalidate(garageProvider);
      ref.invalidate(garageSummaryProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.resetDone)));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            TtSpace.page,
            8,
            TtSpace.page,
            TtSpace.page,
          ),
          children: [
            TtAppHeader(title: l10n.demoData, eyebrow: l10n.settingsTitle),
            const SizedBox(height: TtSpace.x4),
            TtStatusBanner(
              message: l10n.demoBuild,
              tone: TtBannerTone.info,
              icon: Icons.science_outlined,
            ),
            const SizedBox(height: TtSpace.x4),
            TtCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.stats,
                    style: TtType.label(palette.textPrimary, size: 14),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<({int count, int bytes})>(
                    future: _usage,
                    builder: (context, snapshot) {
                      final usage = snapshot.data;
                      return Row(
                        children: [
                          Icon(
                            Icons.folder_outlined,
                            size: 18,
                            color: palette.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              usage == null
                                  ? l10n.commonLoading
                                  : '${l10n.storageUsage}: '
                                        '${l10n.storageFiles(usage.count)} · '
                                        '${Fmt.fileSize(usage.bytes)}',
                              style: TtType.body(
                                palette.textSecondary,
                                size: 12.5,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.demoDataNote,
                    style: TtType.caption(palette.textSecondary, size: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TtSpace.x4),
            TtPrimaryButton(
              label: l10n.resetDemo,
              icon: Icons.restore_rounded,
              loading: _busy,
              onPressed: _reset,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.resetDemoBody,
              textAlign: TextAlign.center,
              style: TtType.caption(palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
