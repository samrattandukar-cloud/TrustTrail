import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class TtLogo extends StatelessWidget {
  const TtLogo({
    super.key,
    this.text,
    this.size = 44,
    this.showText = true,
    this.dark = false,
  });

  final String? text;
  final double size;
  final bool showText;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final mark = ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: Image.asset(
        'assets/images/trusttrail_mark.png',
        width: size,
        height: size,
        cacheWidth: (size * 3).round(),
        filterQuality: FilterQuality.medium,
      ),
    );
    if (!showText) return mark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        SizedBox(width: size * 0.26),
        Text(
          text ?? 'TrustTrail',
          style: TtType.headline(
            dark ? const Color(0xFFFFFFFF) : palette.textPrimary,
          ).copyWith(fontSize: size * 0.5, letterSpacing: -0.3),
        ),
      ],
    );
  }
}

class TtAvatar extends StatelessWidget {
  const TtAvatar({
    super.key,
    required this.name,
    this.size = 48,
    this.background,
    this.foreground,
  });

  final String name;
  final double size;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1).toUpperCase())
        .join();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? palette.surfaceRaised,
        shape: BoxShape.circle,
        border: Border.all(color: palette.border),
      ),
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: TtType.title(foreground ?? palette.primary, size: size * 0.34),
      ),
    );
  }
}
