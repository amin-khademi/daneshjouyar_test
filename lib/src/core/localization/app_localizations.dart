import 'package:flutter/material.dart';

class AppLocalizations {
  static const supportedLocales = [
    Locale('en', 'US'),
    Locale('fa', 'IR'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'World Countries 🌍',
      'countries_list': 'Countries List',
      'capital': 'Capital',
      'retry': 'Retry',
      'network_error': 'Network connection problem',
      'parsing_error': 'Data processing error',
      'general_error': 'Error retrieving information',
      'loading': 'Loading...',
      'settings': 'Settings',
      'language': 'Language',
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'english': 'English',
      'persian': 'Persian',
    },
    'fa': {
      'app_title': 'کشورهای جهان 🌍',
      'countries_list': 'لیست کشورها',
      'capital': 'پایتخت',
      'retry': 'تلاش مجدد',
      'network_error': 'مشکل در اتصال اینترنت',
      'parsing_error': 'خطا در پردازش داده‌ها',
      'general_error': 'خطا در دریافت اطلاعات',
      'loading': 'در حال بارگذاری...',
      'settings': 'تنظیمات',
      'language': 'زبان',
      'theme': 'تم',
      'dark_mode': 'حالت تاریک',
      'light_mode': 'حالت روشن',
      'english': 'انگلیسی',
      'persian': 'فارسی',
    },
  };

  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get appTitle => _localizedValues[locale.languageCode]!['app_title']!;
  String get countriesList =>
      _localizedValues[locale.languageCode]!['countries_list']!;
  String get capital => _localizedValues[locale.languageCode]!['capital']!;
  String get retry => _localizedValues[locale.languageCode]!['retry']!;
  String get networkError =>
      _localizedValues[locale.languageCode]!['network_error']!;
  String get parsingError =>
      _localizedValues[locale.languageCode]!['parsing_error']!;
  String get generalError =>
      _localizedValues[locale.languageCode]!['general_error']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get theme => _localizedValues[locale.languageCode]!['theme']!;
  String get darkMode => _localizedValues[locale.languageCode]!['dark_mode']!;
  String get lightMode => _localizedValues[locale.languageCode]!['light_mode']!;
  String get english => _localizedValues[locale.languageCode]!['english']!;
  String get persian => _localizedValues[locale.languageCode]!['persian']!;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fa'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
