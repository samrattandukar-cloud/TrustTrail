import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A file path may be an absolute local file or an `asset:` demo URI.
class EvidenceImage extends StatelessWidget {
  const EvidenceImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.cacheWidth,
  });

  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final placeholder = Container(
      width: width,
      height: height,
      color: palette.surfaceRaised,
      alignment: Alignment.center,
      child: Icon(Icons.description_outlined, color: palette.textSecondary),
    );
    if (path.startsWith('asset:')) {
      return Image.asset(
        path.substring('asset:'.length),
        fit: fit,
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        errorBuilder: (_, _, _) => placeholder,
      );
    }
    return Image.file(
      File(path),
      fit: fit,
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}
