import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'tt_buttons.dart';

class TtAppHeader extends StatelessWidget {
  const TtAppHeader({
    super.key,
    this.title,
    this.subtitle,
    this.eyebrow,
    this.showBack = true,
    this.actions = const [],
    this.onBack,
  });

  final String? title;
  final String? subtitle;
  final String? eyebrow;
  final bool showBack;
  final List<Widget> actions;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBack) ...[
          TtCircleIconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    eyebrow!.toUpperCase(),
                    style: TtType.eyebrow(palette.textSecondary),
                  ),
                ),
              if (title != null)
                Text(
                  title!,
                  style: TtType.headline(palette.textPrimary)
                      .copyWith(fontSize: 24),
                ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle!,
                    style: TtType.caption(palette.textSecondary),
                  ),
                ),
            ],
          ),
        ),
        if (actions.isNotEmpty) ...[
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < actions.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                actions[i],
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class TtSectionHeader extends StatelessWidget {
  const TtSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.padding,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: TtType.section(palette.textPrimary)),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                actionLabel!,
                style: TtType.label(palette.primary, size: 12.5),
              ),
            ),
        ],
      ),
    );
  }
}
