import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';

class BuyerBookmarkButton extends StatelessWidget {
  const BuyerBookmarkButton({
    super.key,
    required this.saved,
    required this.onPressed,
  });

  final bool saved;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    return Tooltip(
      message: saved ? l10n.removeSaved : l10n.saveReport,
      child: Material(
        color: palette.surface.withValues(alpha: 0.92),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              size: 20,
              color: saved ? palette.primary : palette.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
