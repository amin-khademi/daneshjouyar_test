import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/settings_service.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsService _settingsService;

  SettingsCubit(this._settingsService) : super(const SettingsState());

  Future<void> initialize() async {
    final themeMode = await _settingsService.getThemeMode();
    final locale = await _settingsService.getLocale();
    emit(state.copyWith(themeMode: themeMode, locale: locale));
  }

  Future<void> toggleTheme() async {
    final newTheme =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _settingsService.setThemeMode(newTheme);
    emit(state.copyWith(themeMode: newTheme));
  }

  Future<void> changeLanguage(Locale locale) async {
    await _settingsService.setLocale(locale);
    emit(state.copyWith(locale: locale));
  }
}
