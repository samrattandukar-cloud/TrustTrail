import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class TtCompletenessMeter extends StatelessWidget {
  const TtCompletenessMeter({
    super.key,
    required this.filled,
    this.total = 10,
    this.showCaption = true,
    this.compact = false,
  });

  final int filled;
  final int total;
  final bool showCaption;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final value = total == 0 ? 0.0 : filled / total;
    final size = compact ? 46.0 : 62.0;
    return Row(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: compact ? 5 : 6.5,
                  backgroundColor: palette.surfaceRaisedAlt,
                  valueColor: AlwaysStoppedAnimation(
                    value >= 0.8
                        ? palette.success
                        : value >= 0.5
                        ? palette.primary
                        : palette.warning,
                  ),
                ),
              ),
              Text(
                '$filled/$total',
                style: TtType.data(
                  palette.textPrimary,
                  size: compact ? 12 : 14,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        if (showCaption)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.completionMeter,
                  style: TtType.label(
                    palette.textPrimary,
                    size: compact ? 12 : 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.notATrustScore,
                  style: TtType.caption(palette.textSecondary, size: 11),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
