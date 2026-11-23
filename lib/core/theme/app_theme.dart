import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_shapes.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(
    palette: TtPalette.light,
    semantic: TtSemanticColors.lightColors,
    brightness: Brightness.light,
  );

  static ThemeData dark() => _build(
    palette: TtPalette.dark,
    semantic: TtSemanticColors.darkColors,
    brightness: Brightness.dark,
  );

  static ThemeData _build({
    required TtPalette palette,
    required TtSemanticColors semantic,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: palette.primary,
          brightness: brightness,
        ).copyWith(
          primary: palette.primary,
          onPrimary: palette.onPrimary,
          primaryContainer: palette.surfaceRaised,
          onPrimaryContainer: palette.navy,
          secondary: palette.navy,
          onSecondary: isDark ? palette.canvas : const Color(0xFFFFFFFF),
          secondaryContainer: palette.surfaceRaised,
          onSecondaryContainer: palette.textPrimary,
          tertiary: palette.sand,
          onTertiary: isDark
              ? const Color(0xFF2A1708)
              : const Color(0xFF2B1A0C),
          error: palette.error,
          onError: isDark ? const Color(0xFF690005) : const Color(0xFFFFFFFF),
          surface: palette.surface,
          onSurface: palette.textPrimary,
          onSurfaceVariant: palette.textSecondary,
          outline: palette.border,
          outlineVariant: palette.border,
          shadow: palette.shadow,
        );

    final textTheme = TextTheme(
      displayLarge: TtType.display(palette.textPrimary),
      displayMedium: TtType.display(palette.textPrimary).copyWith(fontSize: 30),
      displaySmall: TtType.display(palette.textPrimary).copyWith(fontSize: 28),
      headlineLarge: TtType.headline(palette.textPrimary),
      headlineMedium: TtType.headline(palette.textPrimary),
      headlineSmall: TtType.title(palette.textPrimary, size: 22),
      titleLarge: TtType.title(palette.textPrimary, size: 20),
      titleMedium: TtType.title(palette.textPrimary, size: 16),
      titleSmall: TtType.title(palette.textPrimary, size: 14),
      bodyLarge: TtType.body(palette.textPrimary),
      bodyMedium: TtType.bodyMedium(palette.textPrimary),
      bodySmall: TtType.caption(palette.textSecondary),
      labelLarge: TtType.button(palette.textPrimary),
      labelMedium: TtType.label(palette.textSecondary),
      labelSmall: TtType.label(palette.textSecondary, size: 11),
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: TtRadius.fieldBorder,
      borderSide: BorderSide(color: palette.border),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.canvas,
      canvasColor: palette.canvas,
      textTheme: textTheme,
      extensions: [semantic],
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.canvas,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: palette.textPrimary, size: 22),
        titleTextStyle: TtType.section(palette.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: TtRadius.cardBorder,
          side: BorderSide(color: palette.border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.border,
        thickness: 1,
        space: 24,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          disabledBackgroundColor: palette.surfaceRaisedAlt,
          disabledForegroundColor: palette.textSecondary,
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: TtRadius.buttonBorder),
          textStyle: TtType.button(palette.onPrimary),
          elevation: 0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.surface,
          foregroundColor: palette.textPrimary,
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: TtRadius.buttonBorder),
          textStyle: TtType.button(palette.textPrimary),
          elevation: 1,
          shadowColor: palette.shadow,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          side: BorderSide(color: palette.border),
          shape: RoundedRectangleBorder(borderRadius: TtRadius.buttonBorder),
          textStyle: TtType.button(palette.textPrimary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: TtType.button(palette.primary),
          minimumSize: const Size(48, 48),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: palette.surface,
        hintStyle: TtType.bodyMedium(palette.textSecondary),
        labelStyle: TtType.label(palette.textSecondary),
        floatingLabelStyle: TtType.label(palette.primary),
        errorStyle: TtType.caption(palette.error),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: palette.primary, width: 1.6),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: palette.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: palette.error, width: 1.6),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.surfaceRaised,
        selectedColor: palette.surfaceRaised,
        labelStyle: TtType.label(palette.textPrimary),
        secondaryLabelStyle: TtType.label(palette.textPrimary),
        side: BorderSide.none,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: palette.surface,
        shape: RoundedRectangleBorder(borderRadius: TtRadius.sheetBorder),
        showDragHandle: true,
        dragHandleColor: palette.border,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: TtType.title(palette.textPrimary, size: 18),
        contentTextStyle: TtType.bodyMedium(palette.textSecondary),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? palette.surfaceRaised : palette.navy,
        contentTextStyle: TtType.bodyMedium(
          isDark ? palette.textPrimary : const Color(0xFFFFFFFF),
        ),
        actionTextColor: isDark ? palette.primary : const Color(0xFF9CCBF0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.all(16),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primary,
        linearTrackColor: palette.surfaceRaised,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.textSecondary,
        textColor: palette.textPrimary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.surface,
        selectedItemColor: palette.primary,
        unselectedItemColor: palette.textSecondary,
      ),
    );
  }
}
