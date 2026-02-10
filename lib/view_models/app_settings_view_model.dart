import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

part 'app_settings_view_model.g.dart';

@riverpod
class AppSettingsViewModel extends _$AppSettingsViewModel {
  @override
  AppSettings build() {
    _loadSettings();
    return const AppSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final fontSize = prefs.getDouble('fontSize') ?? 12.0;
    final themeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
    final preventSleepDuringUdp = prefs.getBool('preventSleepDuringUdp') ?? true;
    final languageCode = prefs.getString('languageCode');

    state = state.copyWith(
      fontSize: fontSize,
      themeMode: ThemeMode.values[themeIndex],
      preventSleepDuringUdp: preventSleepDuringUdp,
      locale: (languageCode != null && languageCode.isNotEmpty) ? Locale(languageCode) : null,
      initialized: true,
    );
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> updateFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
    state = state.copyWith(fontSize: size);
  }

  Future<void> updateLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove('languageCode');
    } else {
      await prefs.setString('languageCode', locale.languageCode);
    }
    state = state.copyWith(locale: locale);
  }

  Future<void> updatePreventSleepDuringUdp(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('preventSleepDuringUdp', value);
    state = state.copyWith(preventSleepDuringUdp: value);
  }
}
