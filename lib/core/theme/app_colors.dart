import 'package:flutter/material.dart';

/// Exact design-system colours from the Stitch source of truth.
@immutable
class TtPalette {
  const TtPalette({
    required this.canvas,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceRaisedAlt,
    required this.primary,
    required this.onPrimary,
    required this.navy,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.success,
    required this.warning,
    required this.sand,
    required this.error,
    required this.shadow,
  });

  final Color canvas;
  final Color surface;
  final Color surfaceRaised;
  final Color surfaceRaisedAlt;
  final Color primary;
  final Color onPrimary;
  final Color navy;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color success;
  final Color warning;
  final Color sand;
  final Color error;
  final Color shadow;

  static const light = TtPalette(
    canvas: Color(0xFFF4F7FA),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFDCEBF5),
    surfaceRaisedAlt: Color(0xFFE1E7ED),
    primary: Color(0xFF226B9F),
    onPrimary: Color(0xFFFFFFFF),
    navy: Color(0xFF0F2A4A),
    textPrimary: Color(0xFF0F1B2D),
    textSecondary: Color(0xFF5B6B7A),
    border: Color(0xFFE1E7ED),
    success: Color(0xFF1F9D63),
    warning: Color(0xFFF2A93B),
    sand: Color(0xFFD9A273),
    error: Color(0xFFC93B3B),
    shadow: Color(0x140F2A4A),
  );

  static const dark = TtPalette(
    canvas: Color(0xFF0B1622),
    surface: Color(0xFF14263A),
    surfaceRaised: Color(0xFF223D5C),
    surfaceRaisedAlt: Color(0xFF2C4258),
    primary: Color(0xFF6BB4E3),
    onPrimary: Color(0xFF06253A),
    navy: Color(0xFFE8EEF4),
    textPrimary: Color(0xFFE8EEF4),
    textSecondary: Color(0xFF9FB2C8),
    border: Color(0xFF2C4258),
    success: Color(0xFF34D399),
    warning: Color(0xFFF59E0B),
    sand: Color(0xFFE5A168),
    error: Color(0xFFFFB4AB),
    shadow: Color(0x33000000),
  );
}

/// Colours Material 3's [ColorScheme] does not model directly.
@immutable
class TtSemanticColors extends ThemeExtension<TtSemanticColors> {
  const TtSemanticColors({
    required this.success,
    required this.warning,
    required this.sand,
    required this.border,
    required this.textSecondary,
    required this.surfaceRaised,
    required this.surfaceRaisedAlt,
  });

  final Color success;
  final Color warning;
  final Color sand;
  final Color border;
  final Color textSecondary;
  final Color surfaceRaised;
  final Color surfaceRaisedAlt;

  static const lightColors = TtSemanticColors(
    success: Color(0xFF1F9D63),
    warning: Color(0xFFF2A93B),
    sand: Color(0xFFD9A273),
    border: Color(0xFFE1E7ED),
    textSecondary: Color(0xFF5B6B7A),
    surfaceRaised: Color(0xFFDCEBF5),
    surfaceRaisedAlt: Color(0xFFE1E7ED),
  );

  static const darkColors = TtSemanticColors(
    success: Color(0xFF34D399),
    warning: Color(0xFFF59E0B),
    sand: Color(0xFFE5A168),
    border: Color(0xFF2C4258),
    textSecondary: Color(0xFF9FB2C8),
    surfaceRaised: Color(0xFF223D5C),
    surfaceRaisedAlt: Color(0xFF2C4258),
  );

  @override
  TtSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? sand,
    Color? border,
    Color? textSecondary,
    Color? surfaceRaised,
    Color? surfaceRaisedAlt,
  }) {
    return TtSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      sand: sand ?? this.sand,
      border: border ?? this.border,
      textSecondary: textSecondary ?? this.textSecondary,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceRaisedAlt: surfaceRaisedAlt ?? this.surfaceRaisedAlt,
    );
  }

  @override
  TtSemanticColors lerp(TtSemanticColors? other, double t) {
    if (other == null) return this;
    return TtSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      sand: Color.lerp(sand, other.sand, t)!,
      border: Color.lerp(border, other.border, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceRaisedAlt: Color.lerp(
        surfaceRaisedAlt,
        other.surfaceRaisedAlt,
        t,
      )!,
    );
  }
}

extension TtThemeX on BuildContext {
  TtPalette get palette => Theme.of(this).brightness == Brightness.dark
      ? TtPalette.dark
      : TtPalette.light;

  TtSemanticColors get semantic =>
      Theme.of(this).extension<TtSemanticColors>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? TtSemanticColors.darkColors
          : TtSemanticColors.lightColors);

  TextTheme get texts => Theme.of(this).textTheme;
}
