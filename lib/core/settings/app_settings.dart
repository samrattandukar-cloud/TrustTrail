import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../prefs/app_prefs.dart';

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final raw = ref.read(sharedPrefsProvider).getString(PrefKeys.themeMode);
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref
        .read(sharedPrefsProvider)
        .setString(PrefKeys.themeMode, mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() {
    final code = ref.read(sharedPrefsProvider).getString(PrefKeys.locale);
    return code == null ? null : Locale(code);
  }

  Future<void> set(String? languageCode) async {
    state = languageCode == null ? null : Locale(languageCode);
    final prefs = ref.read(sharedPrefsProvider);
    if (languageCode == null) {
      await prefs.remove(PrefKeys.locale);
    } else {
      await prefs.setString(PrefKeys.locale, languageCode);
    }
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);
