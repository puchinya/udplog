// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_file_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LogFileState {
  List<File> get logFiles => throw _privateConstructorUsedError;
  String get fileContent => throw _privateConstructorUsedError;
  String? get selectedFileName => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of LogFileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogFileStateCopyWith<LogFileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogFileStateCopyWith<$Res> {
  factory $LogFileStateCopyWith(
    LogFileState value,
    $Res Function(LogFileState) then,
  ) = _$LogFileStateCopyWithImpl<$Res, LogFileState>;
  @useResult
  $Res call({
    List<File> logFiles,
    String fileContent,
    String? selectedFileName,
    bool isLoading,
  });
}

/// @nodoc
class _$LogFileStateCopyWithImpl<$Res, $Val extends LogFileState>
    implements $LogFileStateCopyWith<$Res> {
  _$LogFileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogFileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? logFiles = null,
    Object? fileContent = null,
    Object? selectedFileName = freezed,
    Object? isLoading = null,
  }) {
    return _then(
      _value.copyWith(
            logFiles: null == logFiles
                ? _value.logFiles
                : logFiles // ignore: cast_nullable_to_non_nullable
                      as List<File>,
            fileContent: null == fileContent
                ? _value.fileContent
                : fileContent // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedFileName: freezed == selectedFileName
                ? _value.selectedFileName
                : selectedFileName // ignore: cast_nullable_to_non_nullable
                      as String?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LogFileStateImplCopyWith<$Res>
    implements $LogFileStateCopyWith<$Res> {
  factory _$$LogFileStateImplCopyWith(
    _$LogFileStateImpl value,
    $Res Function(_$LogFileStateImpl) then,
  ) = __$$LogFileStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<File> logFiles,
    String fileContent,
    String? selectedFileName,
    bool isLoading,
  });
}

/// @nodoc
class __$$LogFileStateImplCopyWithImpl<$Res>
    extends _$LogFileStateCopyWithImpl<$Res, _$LogFileStateImpl>
    implements _$$LogFileStateImplCopyWith<$Res> {
  __$$LogFileStateImplCopyWithImpl(
    _$LogFileStateImpl _value,
    $Res Function(_$LogFileStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogFileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? logFiles = null,
    Object? fileContent = null,
    Object? selectedFileName = freezed,
    Object? isLoading = null,
  }) {
    return _then(
      _$LogFileStateImpl(
        logFiles: null == logFiles
            ? _value._logFiles
            : logFiles // ignore: cast_nullable_to_non_nullable
                  as List<File>,
        fileContent: null == fileContent
            ? _value.fileContent
            : fileContent // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedFileName: freezed == selectedFileName
            ? _value.selectedFileName
            : selectedFileName // ignore: cast_nullable_to_non_nullable
                  as String?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$LogFileStateImpl implements _LogFileState {
  const _$LogFileStateImpl({
    final List<File> logFiles = const [],
    this.fileContent = '',
    this.selectedFileName,
    this.isLoading = false,
  }) : _logFiles = logFiles;

  final List<File> _logFiles;
  @override
  @JsonKey()
  List<File> get logFiles {
    if (_logFiles is EqualUnmodifiableListView) return _logFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_logFiles);
  }

  @override
  @JsonKey()
  final String fileContent;
  @override
  final String? selectedFileName;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'LogFileState(logFiles: $logFiles, fileContent: $fileContent, selectedFileName: $selectedFileName, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogFileStateImpl &&
            const DeepCollectionEquality().equals(other._logFiles, _logFiles) &&
            (identical(other.fileContent, fileContent) ||
                other.fileContent == fileContent) &&
            (identical(other.selectedFileName, selectedFileName) ||
                other.selectedFileName == selectedFileName) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_logFiles),
    fileContent,
    selectedFileName,
    isLoading,
  );

  /// Create a copy of LogFileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogFileStateImplCopyWith<_$LogFileStateImpl> get copyWith =>
      __$$LogFileStateImplCopyWithImpl<_$LogFileStateImpl>(this, _$identity);
}

abstract class _LogFileState implements LogFileState {
  const factory _LogFileState({
    final List<File> logFiles,
    final String fileContent,
    final String? selectedFileName,
    final bool isLoading,
  }) = _$LogFileStateImpl;

  @override
  List<File> get logFiles;
  @override
  String get fileContent;
  @override
  String? get selectedFileName;
  @override
  bool get isLoading;

  /// Create a copy of LogFileState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogFileStateImplCopyWith<_$LogFileStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
