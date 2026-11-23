import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/settings/app_settings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_empty_state.dart';
import '../../core/widgets/tt_logo.dart';
import '../../core/widgets/tt_pills.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../core/widgets/tt_text_field.dart';

/// Design-system gallery. Kept as a debug surface to verify tokens visually
/// before feature screens exist.
class ComponentsScreen extends ConsumerWidget {
  const ComponentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final texts = context.texts;
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TtSpace.page),
          children: [
            Row(
              children: [
                const TtLogo(size: 40),
                const Spacer(),
                TtCircleIconButton(
                  icon: isDark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  tooltip: 'Theme',
                  onPressed: () => ref
                      .read(themeModeProvider.notifier)
                      .set(isDark ? ThemeMode.light : ThemeMode.dark),
                ),
              ],
            ),
            const SizedBox(height: TtSpace.x6),
            Text('Design system', style: texts.displaySmall),
            const SizedBox(height: TtSpace.x1),
            Text(
              '${l10n.demoBuild} Tokens: canvas, surface, primary and semantic.',
              style: texts.bodyMedium?.copyWith(color: palette.textSecondary),
            ),
            const SizedBox(height: TtSpace.x6),

            const _Label('Colour tokens'),
            Wrap(
              spacing: TtSpace.x2,
              runSpacing: TtSpace.x2,
              children: [
                _Swatch(name: 'Canvas', color: palette.canvas),
                _Swatch(name: 'Surface', color: palette.surface),
                _Swatch(name: 'Raised', color: palette.surfaceRaised),
                _Swatch(name: 'Primary', color: palette.primary),
                _Swatch(name: 'Navy', color: palette.navy),
                _Swatch(name: 'Border', color: palette.border),
                _Swatch(name: 'Verified', color: palette.success),
                _Swatch(name: 'Amber', color: palette.warning),
                _Swatch(name: 'Sand', color: palette.sand),
                _Swatch(name: 'Error', color: palette.error),
              ],
            ),
            const SizedBox(height: TtSpace.x6),

            const _Label('Typography'),
            Text('Display 32', style: texts.displaySmall),
            Text('Headline 26', style: texts.headlineMedium),
            Text('Title 20', style: texts.titleLarge),
            Text('Section 16', style: texts.titleMedium),
            Text(
              'Body — The odometer series shows no gaps between services.',
              style: texts.bodyLarge,
            ),
            Text(
              'BA 2 PA 1234 · 18,240 km · NPR 1,250',
              style: TtType.plate(palette.textPrimary),
            ),
            const SizedBox(height: TtSpace.x6),

            const _Label('Buttons'),
            TtPrimaryButton(
              label: 'Primary action',
              icon: Icons.add_rounded,
              onPressed: () {},
            ),
            const SizedBox(height: TtSpace.x2),
            TtSecondaryButton(
              label: 'Secondary action',
              icon: Icons.qr_code_rounded,
              onPressed: () {},
            ),
            const SizedBox(height: TtSpace.x2),
            TtGhostButton(label: 'Ghost action', onPressed: () {}),
            const SizedBox(height: TtSpace.x6),

            const _Label('Status pills'),
            Wrap(
              spacing: TtSpace.x2,
              runSpacing: TtSpace.x2,
              children: const [
                EvidenceAttachedPill(3),
                SelfReportedPill(),
                OverduePill(),
                DueSoonPill(),
                TtPill(label: 'Service', icon: Icons.build_outlined),
                TtPlateChip(roman: 'BA 2 PA 1234', devanagari: 'बा २ प १२३४'),
              ],
            ),
            const SizedBox(height: TtSpace.x6),

            const _Label('Inputs'),
            const TtTextField(
              label: 'Workshop',
              hint: 'Sajha Auto Works',
              prefixIcon: Icons.storefront_outlined,
            ),
            const SizedBox(height: TtSpace.x3),
            TtSearchField(hint: l10n.commonSearch),
            const SizedBox(height: TtSpace.x6),

            const _Label('Banners'),
            const TtStatusBanner(
              message: 'Report looks up on this device only.',
              tone: TtBannerTone.info,
            ),
            const SizedBox(height: TtSpace.x2),
            const TtStatusBanner(
              message: 'Evidence stored locally.',
              tone: TtBannerTone.success,
            ),
            const SizedBox(height: TtSpace.x2),
            const TtStatusBanner(
              message: 'Road tax is 4 days overdue.',
              tone: TtBannerTone.warning,
            ),
            const SizedBox(height: TtSpace.x6),

            const _Label('Empty state'),
            TtCard(
              child: TtEmptyState(
                icon: Icons.garage_outlined,
                title: l10n.emptyGarageTitle,
                body: l10n.emptyGarageBody,
                compact: true,
                action: TtPrimaryButton(
                  label: l10n.addVehicle,
                  onPressed: () {},
                  expand: false,
                ),
              ),
            ),
            const SizedBox(height: TtSpace.x6),

            const _Label('Language'),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('English'),
                  selected:
                      Localizations.localeOf(context).languageCode == 'en',
                  onSelected: (_) =>
                      ref.read(localeProvider.notifier).set('en'),
                ),
                const SizedBox(width: TtSpace.x2),
                ChoiceChip(
                  label: const Text('नेपाली'),
                  selected:
                      Localizations.localeOf(context).languageCode == 'ne',
                  onSelected: (_) =>
                      ref.read(localeProvider.notifier).set('ne'),
                ),
              ],
            ),
            const SizedBox(height: TtSpace.x9),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: TtType.eyebrow(context.palette.textSecondary),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: palette.border),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: TtType.caption(palette.textSecondary)),
      ],
    );
  }
}
