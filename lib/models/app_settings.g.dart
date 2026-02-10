// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 12.0,
      themeMode:
          $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      locale: const LocaleConverter().fromJson(json['locale'] as String?),
      preventSleepDuringUdp: json['preventSleepDuringUdp'] as bool? ?? true,
      demoServerEnabled: json['demoServerEnabled'] as bool? ?? false,
      demoServerPort: json['demoServerPort'] as String? ?? '12345',
      initialized: json['initialized'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'fontSize': instance.fontSize,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'locale': const LocaleConverter().toJson(instance.locale),
      'preventSleepDuringUdp': instance.preventSleepDuringUdp,
      'demoServerEnabled': instance.demoServerEnabled,
      'demoServerPort': instance.demoServerPort,
      'initialized': instance.initialized,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
