import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class TtPrimaryButton extends StatelessWidget {
  const TtPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final button = FilledButton(
      onPressed: loading ? () {} : onPressed,
      child: loading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation(palette.onPrimary),
              ),
            )
          : _content(label, icon),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }

  Widget _content(String label, IconData? icon) {
    if (icon == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 19),
        const SizedBox(width: 8),
        Flexible(child: Text(label, textAlign: TextAlign.center)),
      ],
    );
  }
}

class TtSecondaryButton extends StatelessWidget {
  const TtSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: onPressed,
      child: icon == null
          ? Text(label)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 19),
                const SizedBox(width: 8),
                Flexible(child: Text(label, textAlign: TextAlign.center)),
              ],
            ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class TtGhostButton extends StatelessWidget {
  const TtGhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return TextButton(onPressed: onPressed, child: Text(label));
    }
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 19),
      label: Text(label),
    );
  }
}

class TtCircleIconButton extends StatelessWidget {
  const TtCircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final button = Material(
      color: filled ? palette.surfaceRaised : palette.surface,
      shape: CircleBorder(side: BorderSide(color: palette.border)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 21, color: palette.textPrimary),
        ),
      ),
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}
