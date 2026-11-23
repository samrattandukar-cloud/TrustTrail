import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum TtBannerTone { info, success, warning, error }

class TtStatusBanner extends StatelessWidget {
  const TtStatusBanner({
    super.key,
    required this.message,
    this.tone = TtBannerTone.info,
    this.icon,
    this.action,
  });

  final String message;
  final TtBannerTone tone;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = switch (tone) {
      TtBannerTone.info => palette.primary,
      TtBannerTone.success => palette.success,
      TtBannerTone.warning => palette.warning,
      TtBannerTone.error => palette.error,
    };
    final defaultIcon = switch (tone) {
      TtBannerTone.info => Icons.info_outline_rounded,
      TtBannerTone.success => Icons.check_circle_outline_rounded,
      TtBannerTone.warning => Icons.warning_amber_rounded,
      TtBannerTone.error => Icons.error_outline_rounded,
    };
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? defaultIcon, size: 19, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TtType.bodyMedium(palette.textPrimary)
                  .copyWith(height: 1.4),
            ),
          ),
          if (action != null) ...[const SizedBox(width: 8), action!],
        ],
      ),
    );
  }
}
