import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/backup_codec.dart';
import '../auth/session.dart';
import '../garage/garage_controller.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  late Future<BackupCounts> _summary;
  var _exporting = false;
  var _restoring = false;

  @override
  void initState() {
    super.initState();
    _summary = ref.read(backupRepositoryProvider).summary();
  }

  Future<void> _export() async {
    final l10n = context.l10n;
    setState(() => _exporting = true);
    try {
      final result = await ref.read(backupRepositoryProvider).exportArchive();
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/trusttrail_backup_'
        '${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await file.writeAsString(result.json);
      await SharePlus.instance.share(
        ShareParams(
          text: l10n.backupExportShare(
            result.counts.vehicles,
            result.counts.records,
          ),
          files: [XFile(file.path)],
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _restore() async {
    final l10n = context.l10n;
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (picked == null || picked.path == null || !mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.backupRestoreConfirmTitle),
        content: Text(l10n.backupRestoreConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.backupImportAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _restoring = true);
    try {
      final rawJson = await File(picked.path!).readAsString();
      final counts = await ref
          .read(backupRepositoryProvider)
          .restoreArchive(rawJson);
      ref.invalidate(sessionProvider);
      ref.invalidate(garageProvider);
      ref.invalidate(garageSummaryProvider);
      if (!mounted) return;
      setState(() {
        _summary = ref.read(backupRepositoryProvider).summary();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.backupRestoreDone(counts.vehicles, counts.records),
          ),
        ),
      );
    } on FormatException {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.backupInvalidFile)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    } finally {
      if (mounted) setState(() => _restoring = false);
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
            TtAppHeader(title: l10n.backupTitle, eyebrow: l10n.settingsTitle),
            const SizedBox(height: TtSpace.x4),
            TtStatusBanner(
              message: l10n.backupIntro,
              tone: TtBannerTone.info,
              icon: Icons.verified_user_outlined,
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
                  FutureBuilder<BackupCounts>(
                    future: _summary,
                    builder: (context, snapshot) {
                      final data = snapshot.data;
                      return Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 18,
                            color: palette.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              data == null
                                  ? l10n.commonLoading
                                  : l10n.backupSummary(
                                      data.vehicles,
                                      data.records,
                                      data.reminders,
                                    ),
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
                ],
              ),
            ),
            const SizedBox(height: TtSpace.x4),
            TtPrimaryButton(
              label: l10n.backupExportAction,
              icon: Icons.ios_share_rounded,
              loading: _exporting,
              onPressed: _restoring ? null : _export,
            ),
            const SizedBox(height: TtSpace.x3),
            TtSecondaryButton(
              label: _restoring ? l10n.commonLoading : l10n.backupImportAction,
              icon: Icons.file_open_outlined,
              onPressed: (_exporting || _restoring) ? null : _restore,
            ),
          ],
        ),
      ),
    );
  }
}
