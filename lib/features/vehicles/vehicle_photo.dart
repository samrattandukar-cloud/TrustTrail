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
    final image = asset == null
        ? fallback
        : Image.asset(
            asset!,
            width: width,
            height: height,
            fit: BoxFit.cover,
            cacheWidth: (MediaQuery.sizeOf(context).width * 2).round(),
            errorBuilder: (_, _, _) => fallback,
          );
    if (radius <= 0) return image;
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: image);
  }
}
