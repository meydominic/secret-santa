import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing dark/light theme mode.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// Notifier managing application ThemeMode (system, light, dark).
class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const String _themeKey = 'app_theme_mode';

  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_themeKey);
    if (savedMode == 'light') {
      state = ThemeMode.light;
    } else if (savedMode == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  /// Toggles between light and dark modes.
  Future<void> toggleTheme(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;
    state = nextMode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, nextMode == ThemeMode.dark ? 'dark' : 'light');
  }
}

/// Provider for managing app locale.
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

/// Notifier managing application Locale.
class LocaleNotifier extends Notifier<Locale> {
  static const String _localeKey = 'app_locale';

  @override
  Locale build() {
    _loadLocale();
    return const Locale('de');
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey);
    if (savedLocale != null && savedLocale.isNotEmpty) {
      state = Locale(savedLocale);
    }
  }

  /// Sets the application locale.
  Future<void> setLocale(Locale newLocale) async {
    state = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, newLocale.languageCode);
  }

  /// Toggles between German and English.
  Future<void> toggleLanguage() async {
    final nextCode = state.languageCode == 'de' ? 'en' : 'de';
    await setLocale(Locale(nextCode));
  }
}
