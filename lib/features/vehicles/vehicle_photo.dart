import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class VehiclePhoto extends StatelessWidget {
  const VehiclePhoto({
    super.key,
    this.asset,
    this.width = double.infinity,
    this.height = 200,
    this.radius = 0,
  });

  /// Either a bundled asset path (`assets/...`), an already prefixed
  /// (`asset:assets/...`), or an absolute file path picked by the owner.
  final String? asset;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final fallback = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.navy, palette.primary],
        ),
      ),
      child: Icon(
        Icons.directions_car_filled_rounded,
        size: height * 0.34,
        color: palette.surface.withValues(alpha: 0.72),
      ),
    );
    final source = asset == null || asset!.isEmpty
        ? null
        : asset!.startsWith('asset:')
        ? asset!.substring(6)
        : asset;
    final cacheWidth = (MediaQuery.sizeOf(context).width * 2).round();
    final image = source == null
        ? fallback
        : source.startsWith('assets/')
        ? Image.asset(
            source,
            width: width,
            height: height,
            fit: BoxFit.cover,
            cacheWidth: cacheWidth,
            errorBuilder: (_, _, _) => fallback,
          )
        : Image.file(
            File(source),
            width: width,
            height: height,
            fit: BoxFit.cover,
            cacheWidth: cacheWidth,
            errorBuilder: (_, _, _) => fallback,
          );
    if (radius <= 0) return image;
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: image);
  }
}
