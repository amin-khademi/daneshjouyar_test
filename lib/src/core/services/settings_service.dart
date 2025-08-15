import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _themeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  Future<ThemeMode> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themeKey) ?? 'dark';
      switch (themeModeString) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        default:
          return ThemeMode.dark;
      }
    } catch (e) {
      return ThemeMode.dark; // Fallback
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, themeMode.name);
    } catch (e) {
      // Ignore error for now
    }
  }

  Future<Locale> getLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeString = prefs.getString(_localeKey) ?? 'fa';
      switch (localeString) {
        case 'en':
          return const Locale('en', 'US');
        case 'fa':
          return const Locale('fa', 'IR');
        default:
          return const Locale('fa', 'IR');
      }
    } catch (e) {
      return const Locale('fa', 'IR'); // Fallback
    }
  }

  Future<void> setLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      // Ignore error for now
    }
  }
}
