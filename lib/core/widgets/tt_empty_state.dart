import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'tt_buttons.dart';

class TtEmptyState extends StatelessWidget {
  const TtEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: compact ? 24 : 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 64 : 84,
            height: compact ? 64 : 84,
            decoration: BoxDecoration(
              color: palette.surfaceRaised,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: compact ? 28 : 36, color: palette.primary),
          ),
          SizedBox(height: compact ? 14 : 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TtType.title(palette.textPrimary, size: compact ? 17 : 20),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            textAlign: TextAlign.center,
            style: TtType.bodyMedium(palette.textSecondary),
          ),
          if (action != null) ...[SizedBox(height: compact ? 16 : 24), action!],
        ],
      ),
    );
  }
}

class TtErrorState extends StatelessWidget {
  const TtErrorState({
    super.key,
    required this.title,
    required this.body,
    this.onRetry,
    this.retryLabel,
    this.compact = false,
  });

  final String title;
  final String body;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return TtEmptyState(
      icon: Icons.error_outline_rounded,
      title: title,
      body: body,
      compact: compact,
      action: onRetry == null
          ? null
          : TtSecondaryButton(
              label:
                  retryLabel ?? MaterialLocalizations.of(context).okButtonLabel,
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
              expand: false,
            ),
    );
  }
}
