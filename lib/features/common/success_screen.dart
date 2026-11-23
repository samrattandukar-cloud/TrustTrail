import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_logo.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.title,
    required this.body,
    this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.icon = Icons.check_rounded,
    this.tone,
  });

  final String title;
  final String body;
  final String? primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final IconData icon;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    final color = tone ?? palette.success;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: TtLogo(size: 36),
              ),
              const Spacer(),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.6, end: 1),
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeOutBack,
                builder: (context, value, child) =>
                    Transform.scale(scale: value, child: child),
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.13),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Icon(icon, size: 52, color: color),
                ),
              ),
              const SizedBox(height: TtSpace.x6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TtType.headline(palette.textPrimary),
              ),
              const SizedBox(height: TtSpace.x2),
              Text(
                body,
                textAlign: TextAlign.center,
                style: TtType.body(palette.textSecondary),
              ),
              const Spacer(),
              TtPrimaryButton(
                label: primaryLabel ?? l10n.commonContinue,
                onPressed: onPrimary,
              ),
              if (secondaryLabel != null) ...[
                const SizedBox(height: TtSpace.x2),
                TtGhostButton(label: secondaryLabel!, onPressed: onSecondary),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
