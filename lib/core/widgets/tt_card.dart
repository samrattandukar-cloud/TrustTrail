import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shapes.dart';

class TtCard extends StatelessWidget {
  const TtCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.borderColor,
    this.radius = TtRadius.card,
    this.margin,
    this.elevated = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final double radius;
  final EdgeInsetsGeometry? margin;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final borderRadius = BorderRadius.circular(radius);
    Widget content = Padding(padding: padding, child: child);
    // Child ListTiles need a Material closer than the card's painted Container,
    // otherwise their ink/background is hidden behind the card colour.
    content = Material(type: MaterialType.transparency, child: content);
    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: content,
      );
    }
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? palette.surface,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor ?? palette.border),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: palette.shadow,
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: content,
    );
  }
}
