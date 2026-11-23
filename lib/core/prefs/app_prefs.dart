import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Injected in `main()` so settings can be read synchronously.
final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPrefsProvider must be overridden'),
);

abstract final class PrefKeys {
  static const locale = 'settings.locale';
  static const themeMode = 'settings.themeMode';
  static const onboarded = 'session.onboarded';
  static const lastRole = 'session.lastRole';
  static const userId = 'session.userId';
  static const demoSeeded = 'demo.seededVersion';
  static const recentSearches = 'buyer.recentSearches';
}
