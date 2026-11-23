import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/settings/app_settings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import 'role_screen.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final current = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.chooseLanguage,
                style: TtType.headline(palette.textPrimary),
              ),
              const SizedBox(height: TtSpace.x2),
              Text(
                l10n.demoBuild,
                style: TtType.bodyMedium(palette.textSecondary),
              ),
              const SizedBox(height: TtSpace.x6),
              _LanguageOption(
                title: 'English',
                subtitle: 'English',
                selected: current != 'ne',
                onTap: () => ref.read(localeProvider.notifier).set('en'),
              ),
              const SizedBox(height: TtSpace.x3),
              _LanguageOption(
                title: 'नेपाली',
                subtitle: 'Nepali · Bikram Sambat dates',
                selected: current == 'ne',
                onTap: () => ref.read(localeProvider.notifier).set('ne'),
              ),
              const Spacer(),
              TtPrimaryButton(
                label: l10n.commonContinue,
                icon: Icons.arrow_forward_rounded,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const RoleScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
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
      borderColor: selected ? palette.primary : palette.border,
      color: selected ? palette.surfaceRaised : palette.surface,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? palette.primary : palette.surfaceRaisedAlt,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              title.startsWith('ने') ? 'अ' : 'A',
              style: TtType.title(
                selected ? palette.onPrimary : palette.textPrimary,
                size: 19,
              ),
            ),
          ),
          const SizedBox(width: TtSpace.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TtType.title(palette.textPrimary, size: 17)),
                const SizedBox(height: 2),
                Text(subtitle, style: TtType.caption(palette.textSecondary)),
              ],
            ),
          ),
          Icon(
            selected ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: selected ? palette.primary : palette.border,
          ),
        ],
      ),
    );
  }
}
