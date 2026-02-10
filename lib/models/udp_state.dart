import 'package:freezed_annotation/freezed_annotation.dart';

part 'udp_state.freezed.dart';
part 'udp_state.g.dart';

@freezed
class UdpMessage with _$UdpMessage {
  const factory UdpMessage({
    required DateTime timestamp,
    required String address,
    required int port,
    required String message,
    String? systemMessageKey,
    String? systemMessageArgs,
    @Default(false) bool isOutgoing,
    @Default(false) bool isSystem,
  }) = _UdpMessage;

  factory UdpMessage.fromJson(Map<String, dynamic> json) => _$UdpMessageFromJson(json);
}

@freezed
class UdpState with _$UdpState {
  const factory UdpState({
    @Default([]) List<UdpMessage> logs,
    @Default(false) bool isReceiving,
    @Default('12345') String receivePort,
    @Default('127.0.0.1') String sendAddress,
    @Default('12345') String sendPort,
    @Default('') String sendMessage,
    @Default(false) bool isHexMode,
    @Default([]) List<String> sendHistory,
    String? currentLogPath,
    @Default(false) bool initialized,
  }) = _UdpState;
}
