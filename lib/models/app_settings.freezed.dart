// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  double get fontSize => throw _privateConstructorUsedError;
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  @LocaleConverter()
  Locale? get locale => throw _privateConstructorUsedError;
  bool get preventSleepDuringUdp => throw _privateConstructorUsedError;
  bool get demoServerEnabled => throw _privateConstructorUsedError;
  String get demoServerPort => throw _privateConstructorUsedError;
  bool get initialized => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
    AppSettings value,
    $Res Function(AppSettings) then,
  ) = _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    double fontSize,
    ThemeMode themeMode,
    @LocaleConverter() Locale? locale,
    bool preventSleepDuringUdp,
    bool demoServerEnabled,
    String demoServerPort,
    bool initialized,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fontSize = null,
    Object? themeMode = null,
    Object? locale = freezed,
    Object? preventSleepDuringUdp = null,
    Object? demoServerEnabled = null,
    Object? demoServerPort = null,
    Object? initialized = null,
  }) {
    return _then(
      _value.copyWith(
            fontSize: null == fontSize
                ? _value.fontSize
                : fontSize // ignore: cast_nullable_to_non_nullable
                      as double,
            themeMode: null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                      as ThemeMode,
            locale: freezed == locale
                ? _value.locale
                : locale // ignore: cast_nullable_to_non_nullable
                      as Locale?,
            preventSleepDuringUdp: null == preventSleepDuringUdp
                ? _value.preventSleepDuringUdp
                : preventSleepDuringUdp // ignore: cast_nullable_to_non_nullable
                      as bool,
            demoServerEnabled: null == demoServerEnabled
                ? _value.demoServerEnabled
                : demoServerEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            demoServerPort: null == demoServerPort
                ? _value.demoServerPort
                : demoServerPort // ignore: cast_nullable_to_non_nullable
                      as String,
            initialized: null == initialized
                ? _value.initialized
                : initialized // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
    _$AppSettingsImpl value,
    $Res Function(_$AppSettingsImpl) then,
  ) = __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double fontSize,
    ThemeMode themeMode,
    @LocaleConverter() Locale? locale,
    bool preventSleepDuringUdp,
    bool demoServerEnabled,
    String demoServerPort,
    bool initialized,
  });
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
    _$AppSettingsImpl _value,
    $Res Function(_$AppSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fontSize = null,
    Object? themeMode = null,
    Object? locale = freezed,
    Object? preventSleepDuringUdp = null,
    Object? demoServerEnabled = null,
    Object? demoServerPort = null,
    Object? initialized = null,
  }) {
    return _then(
      _$AppSettingsImpl(
        fontSize: null == fontSize
            ? _value.fontSize
            : fontSize // ignore: cast_nullable_to_non_nullable
                  as double,
        themeMode: null == themeMode
            ? _value.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as ThemeMode,
        locale: freezed == locale
            ? _value.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as Locale?,
        preventSleepDuringUdp: null == preventSleepDuringUdp
            ? _value.preventSleepDuringUdp
            : preventSleepDuringUdp // ignore: cast_nullable_to_non_nullable
                  as bool,
        demoServerEnabled: null == demoServerEnabled
            ? _value.demoServerEnabled
            : demoServerEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        demoServerPort: null == demoServerPort
            ? _value.demoServerPort
            : demoServerPort // ignore: cast_nullable_to_non_nullable
                  as String,
        initialized: null == initialized
            ? _value.initialized
            : initialized // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl({
    this.fontSize = 12.0,
    this.themeMode = ThemeMode.system,
    @LocaleConverter() this.locale,
    this.preventSleepDuringUdp = true,
    this.demoServerEnabled = false,
    this.demoServerPort = '50050',
    this.initialized = false,
  });

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @JsonKey()
  final double fontSize;
  @override
  @JsonKey()
  final ThemeMode themeMode;
  @override
  @LocaleConverter()
  final Locale? locale;
  @override
  @JsonKey()
  final bool preventSleepDuringUdp;
  @override
  @JsonKey()
  final bool demoServerEnabled;
  @override
  @JsonKey()
  final String demoServerPort;
  @override
  @JsonKey()
  final bool initialized;

  @override
  String toString() {
    return 'AppSettings(fontSize: $fontSize, themeMode: $themeMode, locale: $locale, preventSleepDuringUdp: $preventSleepDuringUdp, demoServerEnabled: $demoServerEnabled, demoServerPort: $demoServerPort, initialized: $initialized)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.preventSleepDuringUdp, preventSleepDuringUdp) ||
                other.preventSleepDuringUdp == preventSleepDuringUdp) &&
            (identical(other.demoServerEnabled, demoServerEnabled) ||
                other.demoServerEnabled == demoServerEnabled) &&
            (identical(other.demoServerPort, demoServerPort) ||
                other.demoServerPort == demoServerPort) &&
            (identical(other.initialized, initialized) ||
                other.initialized == initialized));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fontSize,
    themeMode,
    locale,
    preventSleepDuringUdp,
    demoServerEnabled,
    demoServerPort,
    initialized,
  );

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(this);
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings({
    final double fontSize,
    final ThemeMode themeMode,
    @LocaleConverter() final Locale? locale,
    final bool preventSleepDuringUdp,
    final bool demoServerEnabled,
    final String demoServerPort,
    final bool initialized,
  }) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  double get fontSize;
  @override
  ThemeMode get themeMode;
  @override
  @LocaleConverter()
  Locale? get locale;
  @override
  bool get preventSleepDuringUdp;
  @override
  bool get demoServerEnabled;
  @override
  String get demoServerPort;
  @override
  bool get initialized;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
