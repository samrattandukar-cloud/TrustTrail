import 'package:flutter/material.dart';

abstract final class TtFonts {
  static const sans = 'PlusJakarta';
  static const body = 'Inter';
  static const devanagari = 'NotoDevanagari';
}

/// Typographic roles. Numerals in data roles use tabular figures so plates,
/// odometers and money stay aligned in lists.
abstract final class TtType {
  static const List<FontFeature> tabular = [FontFeature.tabularFigures()];
  static const List<String> fallback = [TtFonts.devanagari];

  static TextStyle display(Color color) => TextStyle(
    fontFamily: TtFonts.sans,
    fontFamilyFallback: fallback,
    fontSize: 32,
    height: 1.15,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.6,
    color: color,
  );

  static TextStyle headline(Color color) => TextStyle(
    fontFamily: TtFonts.sans,
    fontFamilyFallback: fallback,
    fontSize: 26,
    height: 1.2,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
    color: color,
  );

  static TextStyle title(Color color, {double size = 20}) => TextStyle(
    fontFamily: TtFonts.sans,
    fontFamilyFallback: fallback,
    fontSize: size,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: color,
  );

  static TextStyle section(Color color) => TextStyle(
    fontFamily: TtFonts.sans,
    fontFamilyFallback: fallback,
    fontSize: 16,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: color,
  );

  static TextStyle body(
    Color color, {
    double size = 15,
    double height = 1.45,
  }) => TextStyle(
    fontFamily: TtFonts.body,
    fontFamilyFallback: fallback,
    fontSize: size,
    height: height,
    fontWeight: FontWeight.w400,
    color: color,
  );

  static TextStyle bodyMedium(Color color) => body(color, size: 14);

  static TextStyle caption(Color color, {double size = 12.5}) => TextStyle(
    fontFamily: TtFonts.body,
    fontFamilyFallback: fallback,
    fontSize: size,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: color,
  );

  static TextStyle label(Color color, {double size = 12}) => TextStyle(
    fontFamily: TtFonts.sans,
    fontFamilyFallback: fallback,
    fontSize: size,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: color,
  );

  static TextStyle eyebrow(Color color) => TextStyle(
    fontFamily: TtFonts.sans,
    fontFamilyFallback: fallback,
    fontSize: 11.5,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: color,
    fontFeatures: tabular,
  );

  static TextStyle data(
    Color color, {
    double size = 14,
    FontWeight weight = FontWeight.w500,
  }) => TextStyle(
    fontFamily: TtFonts.body,
    fontFamilyFallback: fallback,
    fontSize: size,
    height: 1.35,
    fontWeight: weight,
    color: color,
    fontFeatures: tabular,
  );

  static TextStyle plate(Color color, {double size = 16}) => TextStyle(
    fontFamily: TtFonts.body,
    fontFamilyFallback: fallback,
    fontSize: size,
    height: 1.3,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: color,
    fontFeatures: tabular,
  );

  static TextStyle button(Color color) => TextStyle(
    fontFamily: TtFonts.sans,
    fontFamilyFallback: fallback,
    fontSize: 15.5,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    color: color,
  );
}
