import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_shapes.dart';
import '../theme/app_typography.dart';

class TtPill extends StatelessWidget {
  const TtPill({
    super.key,
    required this.label,
    this.icon,
    this.foreground,
    this.background,
    this.compact = false,
  });

  final String label;
  final IconData? icon;
  final Color? foreground;
  final Color? background;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final fg = foreground ?? palette.textSecondary;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: background ?? palette.surfaceRaised,
        borderRadius: TtRadius.pillBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: compact ? 12 : 13, color: fg),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TtType.label(fg, size: compact ? 10.5 : 11.5),
            ),
          ),
        ],
      ),
    );
  }
}

class EvidenceAttachedPill extends StatelessWidget {
  const EvidenceAttachedPill(this.count, {super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    final color = context.palette.success;
    return TtPill(
      label: context.l10n.evidenceAttached(count),
      icon: Icons.attach_file_rounded,
      foreground: color,
      background: color.withValues(alpha: 0.12),
    );
  }
}

class SelfReportedPill extends StatelessWidget {
  const SelfReportedPill({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.palette.sand;
    return TtPill(
      label: context.l10n.selfReported,
      icon: Icons.person_outline_rounded,
      foreground: color,
      background: color.withValues(alpha: 0.14),
    );
  }
}

class OverduePill extends StatelessWidget {
  const OverduePill({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.palette.error;
    return TtPill(
      label: context.l10n.overdue,
      icon: Icons.error_outline_rounded,
      foreground: color,
      background: color.withValues(alpha: 0.12),
    );
  }
}

class DueSoonPill extends StatelessWidget {
  const DueSoonPill({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.palette.warning;
    return TtPill(
      label: context.l10n.dueSoon,
      icon: Icons.schedule_rounded,
      foreground: color,
      background: color.withValues(alpha: 0.16),
    );
  }
}

class TtPlateChip extends StatelessWidget {
  const TtPlateChip({
    super.key,
    required this.roman,
    this.devanagari,
    this.compact = false,
  });

  final String roman;
  final String? devanagari;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceRaisedAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            roman,
            style: TtType.plate(palette.textPrimary, size: compact ? 11 : 13),
          ),
          if (devanagari != null &&
              devanagari!.isNotEmpty &&
              devanagari != roman)
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                devanagari!,
                style: TtType.plate(
                  palette.textSecondary,
                  size: compact ? 9.5 : 11,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
