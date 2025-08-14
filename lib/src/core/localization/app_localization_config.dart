import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Localization configuration following Single Responsibility Principle
class AppLocalizationConfig {
  // Private constructor (YAGNI)
  AppLocalizationConfig._();

  /// Supported locales (Open/Closed Principle - easy to extend)
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('fa', 'IR'),
  ];

  /// Localization delegates (Interface Segregation)
  static const List<LocalizationsDelegate> delegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// Check if locale is RTL (Single Responsibility)
  static bool isRTL(Locale locale) {
    return locale.languageCode == 'fa';
  }

  /// Get text direction for locale (Single Responsibility)
  static TextDirection getTextDirection(Locale locale) {
    return isRTL(locale) ? TextDirection.rtl : TextDirection.ltr;
  }
}
