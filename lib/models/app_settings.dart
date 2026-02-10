import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

class LocaleConverter implements JsonConverter<Locale?, String?> {
  const LocaleConverter();

  @override
  Locale? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;
    return Locale(json);
  }

  @override
  String? toJson(Locale? object) {
    return object?.languageCode;
  }
}

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(12.0) double fontSize,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @LocaleConverter() Locale? locale,
    @Default(true) bool preventSleepDuringUdp,
    @Default(false) bool initialized,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
}
