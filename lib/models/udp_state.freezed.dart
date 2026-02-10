// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'udp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UdpMessage _$UdpMessageFromJson(Map<String, dynamic> json) {
  return _UdpMessage.fromJson(json);
}

/// @nodoc
mixin _$UdpMessage {
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get systemMessageKey => throw _privateConstructorUsedError;
  String? get systemMessageArgs => throw _privateConstructorUsedError;
  bool get isOutgoing => throw _privateConstructorUsedError;
  bool get isSystem => throw _privateConstructorUsedError;

  /// Serializes this UdpMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UdpMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UdpMessageCopyWith<UdpMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UdpMessageCopyWith<$Res> {
  factory $UdpMessageCopyWith(
    UdpMessage value,
    $Res Function(UdpMessage) then,
  ) = _$UdpMessageCopyWithImpl<$Res, UdpMessage>;
  @useResult
  $Res call({
    DateTime timestamp,
    String address,
    int port,
    String message,
    String? systemMessageKey,
    String? systemMessageArgs,
    bool isOutgoing,
    bool isSystem,
  });
}

/// @nodoc
class _$UdpMessageCopyWithImpl<$Res, $Val extends UdpMessage>
    implements $UdpMessageCopyWith<$Res> {
  _$UdpMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UdpMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? address = null,
    Object? port = null,
    Object? message = null,
    Object? systemMessageKey = freezed,
    Object? systemMessageArgs = freezed,
    Object? isOutgoing = null,
    Object? isSystem = null,
  }) {
    return _then(
      _value.copyWith(
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            port: null == port
                ? _value.port
                : port // ignore: cast_nullable_to_non_nullable
                      as int,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            systemMessageKey: freezed == systemMessageKey
                ? _value.systemMessageKey
                : systemMessageKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            systemMessageArgs: freezed == systemMessageArgs
                ? _value.systemMessageArgs
                : systemMessageArgs // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOutgoing: null == isOutgoing
                ? _value.isOutgoing
                : isOutgoing // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSystem: null == isSystem
                ? _value.isSystem
                : isSystem // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UdpMessageImplCopyWith<$Res>
    implements $UdpMessageCopyWith<$Res> {
  factory _$$UdpMessageImplCopyWith(
    _$UdpMessageImpl value,
    $Res Function(_$UdpMessageImpl) then,
  ) = __$$UdpMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime timestamp,
    String address,
    int port,
    String message,
    String? systemMessageKey,
    String? systemMessageArgs,
    bool isOutgoing,
    bool isSystem,
  });
}

/// @nodoc
class __$$UdpMessageImplCopyWithImpl<$Res>
    extends _$UdpMessageCopyWithImpl<$Res, _$UdpMessageImpl>
    implements _$$UdpMessageImplCopyWith<$Res> {
  __$$UdpMessageImplCopyWithImpl(
    _$UdpMessageImpl _value,
    $Res Function(_$UdpMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UdpMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? address = null,
    Object? port = null,
    Object? message = null,
    Object? systemMessageKey = freezed,
    Object? systemMessageArgs = freezed,
    Object? isOutgoing = null,
    Object? isSystem = null,
  }) {
    return _then(
      _$UdpMessageImpl(
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        port: null == port
            ? _value.port
            : port // ignore: cast_nullable_to_non_nullable
                  as int,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        systemMessageKey: freezed == systemMessageKey
            ? _value.systemMessageKey
            : systemMessageKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        systemMessageArgs: freezed == systemMessageArgs
            ? _value.systemMessageArgs
            : systemMessageArgs // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOutgoing: null == isOutgoing
            ? _value.isOutgoing
            : isOutgoing // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSystem: null == isSystem
            ? _value.isSystem
            : isSystem // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UdpMessageImpl implements _UdpMessage {
  const _$UdpMessageImpl({
    required this.timestamp,
    required this.address,
    required this.port,
    required this.message,
    this.systemMessageKey,
    this.systemMessageArgs,
    this.isOutgoing = false,
    this.isSystem = false,
  });

  factory _$UdpMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$UdpMessageImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  final String address;
  @override
  final int port;
  @override
  final String message;
  @override
  final String? systemMessageKey;
  @override
  final String? systemMessageArgs;
  @override
  @JsonKey()
  final bool isOutgoing;
  @override
  @JsonKey()
  final bool isSystem;

  @override
  String toString() {
    return 'UdpMessage(timestamp: $timestamp, address: $address, port: $port, message: $message, systemMessageKey: $systemMessageKey, systemMessageArgs: $systemMessageArgs, isOutgoing: $isOutgoing, isSystem: $isSystem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UdpMessageImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.systemMessageKey, systemMessageKey) ||
                other.systemMessageKey == systemMessageKey) &&
            (identical(other.systemMessageArgs, systemMessageArgs) ||
                other.systemMessageArgs == systemMessageArgs) &&
            (identical(other.isOutgoing, isOutgoing) ||
                other.isOutgoing == isOutgoing) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    timestamp,
    address,
    port,
    message,
    systemMessageKey,
    systemMessageArgs,
    isOutgoing,
    isSystem,
  );

  /// Create a copy of UdpMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UdpMessageImplCopyWith<_$UdpMessageImpl> get copyWith =>
      __$$UdpMessageImplCopyWithImpl<_$UdpMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UdpMessageImplToJson(this);
  }
}

abstract class _UdpMessage implements UdpMessage {
  const factory _UdpMessage({
    required final DateTime timestamp,
    required final String address,
    required final int port,
    required final String message,
    final String? systemMessageKey,
    final String? systemMessageArgs,
    final bool isOutgoing,
    final bool isSystem,
  }) = _$UdpMessageImpl;

  factory _UdpMessage.fromJson(Map<String, dynamic> json) =
      _$UdpMessageImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  String get address;
  @override
  int get port;
  @override
  String get message;
  @override
  String? get systemMessageKey;
  @override
  String? get systemMessageArgs;
  @override
  bool get isOutgoing;
  @override
  bool get isSystem;

  /// Create a copy of UdpMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UdpMessageImplCopyWith<_$UdpMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UdpState {
  List<UdpMessage> get logs => throw _privateConstructorUsedError;
  bool get isReceiving => throw _privateConstructorUsedError;
  String get receivePort => throw _privateConstructorUsedError;
  String get sendAddress => throw _privateConstructorUsedError;
  String get sendPort => throw _privateConstructorUsedError;
  String get sendMessage => throw _privateConstructorUsedError;
  bool get isHexMode => throw _privateConstructorUsedError;
  List<String> get sendHistory => throw _privateConstructorUsedError;
  String? get currentLogPath => throw _privateConstructorUsedError;
  bool get initialized => throw _privateConstructorUsedError;

  /// Create a copy of UdpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UdpStateCopyWith<UdpState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UdpStateCopyWith<$Res> {
  factory $UdpStateCopyWith(UdpState value, $Res Function(UdpState) then) =
      _$UdpStateCopyWithImpl<$Res, UdpState>;
  @useResult
  $Res call({
    List<UdpMessage> logs,
    bool isReceiving,
    String receivePort,
    String sendAddress,
    String sendPort,
    String sendMessage,
    bool isHexMode,
    List<String> sendHistory,
    String? currentLogPath,
    bool initialized,
  });
}

/// @nodoc
class _$UdpStateCopyWithImpl<$Res, $Val extends UdpState>
    implements $UdpStateCopyWith<$Res> {
  _$UdpStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UdpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? logs = null,
    Object? isReceiving = null,
    Object? receivePort = null,
    Object? sendAddress = null,
    Object? sendPort = null,
    Object? sendMessage = null,
    Object? isHexMode = null,
    Object? sendHistory = null,
    Object? currentLogPath = freezed,
    Object? initialized = null,
  }) {
    return _then(
      _value.copyWith(
            logs: null == logs
                ? _value.logs
                : logs // ignore: cast_nullable_to_non_nullable
                      as List<UdpMessage>,
            isReceiving: null == isReceiving
                ? _value.isReceiving
                : isReceiving // ignore: cast_nullable_to_non_nullable
                      as bool,
            receivePort: null == receivePort
                ? _value.receivePort
                : receivePort // ignore: cast_nullable_to_non_nullable
                      as String,
            sendAddress: null == sendAddress
                ? _value.sendAddress
                : sendAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            sendPort: null == sendPort
                ? _value.sendPort
                : sendPort // ignore: cast_nullable_to_non_nullable
                      as String,
            sendMessage: null == sendMessage
                ? _value.sendMessage
                : sendMessage // ignore: cast_nullable_to_non_nullable
                      as String,
            isHexMode: null == isHexMode
                ? _value.isHexMode
                : isHexMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            sendHistory: null == sendHistory
                ? _value.sendHistory
                : sendHistory // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            currentLogPath: freezed == currentLogPath
                ? _value.currentLogPath
                : currentLogPath // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$UdpStateImplCopyWith<$Res>
    implements $UdpStateCopyWith<$Res> {
  factory _$$UdpStateImplCopyWith(
    _$UdpStateImpl value,
    $Res Function(_$UdpStateImpl) then,
  ) = __$$UdpStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<UdpMessage> logs,
    bool isReceiving,
    String receivePort,
    String sendAddress,
    String sendPort,
    String sendMessage,
    bool isHexMode,
    List<String> sendHistory,
    String? currentLogPath,
    bool initialized,
  });
}

/// @nodoc
class __$$UdpStateImplCopyWithImpl<$Res>
    extends _$UdpStateCopyWithImpl<$Res, _$UdpStateImpl>
    implements _$$UdpStateImplCopyWith<$Res> {
  __$$UdpStateImplCopyWithImpl(
    _$UdpStateImpl _value,
    $Res Function(_$UdpStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UdpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? logs = null,
    Object? isReceiving = null,
    Object? receivePort = null,
    Object? sendAddress = null,
    Object? sendPort = null,
    Object? sendMessage = null,
    Object? isHexMode = null,
    Object? sendHistory = null,
    Object? currentLogPath = freezed,
    Object? initialized = null,
  }) {
    return _then(
      _$UdpStateImpl(
        logs: null == logs
            ? _value._logs
            : logs // ignore: cast_nullable_to_non_nullable
                  as List<UdpMessage>,
        isReceiving: null == isReceiving
            ? _value.isReceiving
            : isReceiving // ignore: cast_nullable_to_non_nullable
                  as bool,
        receivePort: null == receivePort
            ? _value.receivePort
            : receivePort // ignore: cast_nullable_to_non_nullable
                  as String,
        sendAddress: null == sendAddress
            ? _value.sendAddress
            : sendAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        sendPort: null == sendPort
            ? _value.sendPort
            : sendPort // ignore: cast_nullable_to_non_nullable
                  as String,
        sendMessage: null == sendMessage
            ? _value.sendMessage
            : sendMessage // ignore: cast_nullable_to_non_nullable
                  as String,
        isHexMode: null == isHexMode
            ? _value.isHexMode
            : isHexMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        sendHistory: null == sendHistory
            ? _value._sendHistory
            : sendHistory // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        currentLogPath: freezed == currentLogPath
            ? _value.currentLogPath
            : currentLogPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        initialized: null == initialized
            ? _value.initialized
            : initialized // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$UdpStateImpl implements _UdpState {
  const _$UdpStateImpl({
    final List<UdpMessage> logs = const [],
    this.isReceiving = false,
    this.receivePort = '12345',
    this.sendAddress = '127.0.0.1',
    this.sendPort = '50050',
    this.sendMessage = '',
    this.isHexMode = false,
    final List<String> sendHistory = const [],
    this.currentLogPath,
    this.initialized = false,
  }) : _logs = logs,
       _sendHistory = sendHistory;

  final List<UdpMessage> _logs;
  @override
  @JsonKey()
  List<UdpMessage> get logs {
    if (_logs is EqualUnmodifiableListView) return _logs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_logs);
  }

  @override
  @JsonKey()
  final bool isReceiving;
  @override
  @JsonKey()
  final String receivePort;
  @override
  @JsonKey()
  final String sendAddress;
  @override
  @JsonKey()
  final String sendPort;
  @override
  @JsonKey()
  final String sendMessage;
  @override
  @JsonKey()
  final bool isHexMode;
  final List<String> _sendHistory;
  @override
  @JsonKey()
  List<String> get sendHistory {
    if (_sendHistory is EqualUnmodifiableListView) return _sendHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sendHistory);
  }

  @override
  final String? currentLogPath;
  @override
  @JsonKey()
  final bool initialized;

  @override
  String toString() {
    return 'UdpState(logs: $logs, isReceiving: $isReceiving, receivePort: $receivePort, sendAddress: $sendAddress, sendPort: $sendPort, sendMessage: $sendMessage, isHexMode: $isHexMode, sendHistory: $sendHistory, currentLogPath: $currentLogPath, initialized: $initialized)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UdpStateImpl &&
            const DeepCollectionEquality().equals(other._logs, _logs) &&
            (identical(other.isReceiving, isReceiving) ||
                other.isReceiving == isReceiving) &&
            (identical(other.receivePort, receivePort) ||
                other.receivePort == receivePort) &&
            (identical(other.sendAddress, sendAddress) ||
                other.sendAddress == sendAddress) &&
            (identical(other.sendPort, sendPort) ||
                other.sendPort == sendPort) &&
            (identical(other.sendMessage, sendMessage) ||
                other.sendMessage == sendMessage) &&
            (identical(other.isHexMode, isHexMode) ||
                other.isHexMode == isHexMode) &&
            const DeepCollectionEquality().equals(
              other._sendHistory,
              _sendHistory,
            ) &&
            (identical(other.currentLogPath, currentLogPath) ||
                other.currentLogPath == currentLogPath) &&
            (identical(other.initialized, initialized) ||
                other.initialized == initialized));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_logs),
    isReceiving,
    receivePort,
    sendAddress,
    sendPort,
    sendMessage,
    isHexMode,
    const DeepCollectionEquality().hash(_sendHistory),
    currentLogPath,
    initialized,
  );

  /// Create a copy of UdpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UdpStateImplCopyWith<_$UdpStateImpl> get copyWith =>
      __$$UdpStateImplCopyWithImpl<_$UdpStateImpl>(this, _$identity);
}

abstract class _UdpState implements UdpState {
  const factory _UdpState({
    final List<UdpMessage> logs,
    final bool isReceiving,
    final String receivePort,
    final String sendAddress,
    final String sendPort,
    final String sendMessage,
    final bool isHexMode,
    final List<String> sendHistory,
    final String? currentLogPath,
    final bool initialized,
  }) = _$UdpStateImpl;

  @override
  List<UdpMessage> get logs;
  @override
  bool get isReceiving;
  @override
  String get receivePort;
  @override
  String get sendAddress;
  @override
  String get sendPort;
  @override
  String get sendMessage;
  @override
  bool get isHexMode;
  @override
  List<String> get sendHistory;
  @override
  String? get currentLogPath;
  @override
  bool get initialized;

  /// Create a copy of UdpState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UdpStateImplCopyWith<_$UdpStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
