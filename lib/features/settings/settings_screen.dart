import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/settings/app_settings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_pills.dart';
import 'about_screen.dart';
import 'demo_data_screen.dart';
import 'sus_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

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
            TtAppHeader(title: l10n.settingsTitle, eyebrow: l10n.profileTitle),
            const SizedBox(height: TtSpace.x4),
            TtSectionHeader(title: l10n.appearance),
            const SizedBox(height: 8),
            TtCard(
              child: SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l10n.themeLight),
                    icon: const Icon(Icons.light_mode_outlined, size: 17),
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l10n.themeSystem),
                    icon: const Icon(Icons.brightness_auto_outlined, size: 17),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l10n.themeDark),
                    icon: const Icon(Icons.dark_mode_outlined, size: 17),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (selection) =>
                    ref.read(themeModeProvider.notifier).set(selection.first),
              ),
            ),
            const SizedBox(height: TtSpace.x4),
            TtSectionHeader(title: l10n.language),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _LanguageCard(
                    title: l10n.english,
                    subtitle: 'English',
                    selected: locale?.languageCode != 'ne',
                    onTap: () => ref.read(localeProvider.notifier).set('en'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _LanguageCard(
                    title: l10n.nepali,
                    subtitle: 'नेपाली',
                    selected: locale?.languageCode == 'ne',
                    onTap: () => ref.read(localeProvider.notifier).set('ne'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TtSpace.x4),
            TtSectionHeader(title: l10n.feedback),
            const SizedBox(height: 8),
            TtCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _LinkTile(
                    icon: Icons.rate_review_outlined,
                    title: l10n.feedback,
                    subtitle: l10n.feedbackBody,
                    onTap: () => _push(context, const SusScreen()),
                  ),
                  _LinkTile(
                    icon: Icons.storage_outlined,
                    title: l10n.demoData,
                    subtitle: l10n.resetDemoBody,
                    onTap: () => _push(context, const DemoDataScreen()),
                  ),
                  _LinkTile(
                    icon: Icons.info_outline_rounded,
                    title: l10n.aboutTitle,
                    subtitle: l10n.version,
                    onTap: () => _push(context, const AboutScreen()),
                    last: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: TtSpace.x4),
            Center(
              child: TtPill(
                label: l10n.version,
                icon: Icons.phone_android_rounded,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.demoBuild,
              textAlign: TextAlign.center,
              style: TtType.caption(palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TtCard(
      onTap: onTap,
      borderColor: selected ? palette.primary : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TtType.label(
                    selected ? palette.primary : palette.textPrimary,
                    size: 14,
                  ),
                ),
              ),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 18,
                color: selected ? palette.primary : palette.border,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: TtType.caption(palette.textSecondary)),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.last = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          leading: Icon(icon, color: palette.primary, size: 21),
          title: Text(
            title,
            style: TtType.label(palette.textPrimary, size: 13.5),
          ),
          subtitle: Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TtType.caption(palette.textSecondary, size: 11),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: palette.textSecondary,
          ),
        ),
        if (!last) Divider(height: 1, color: palette.border),
      ],
    );
  }
}
