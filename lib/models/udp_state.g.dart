// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'udp_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UdpMessageImpl _$$UdpMessageImplFromJson(Map<String, dynamic> json) =>
    _$UdpMessageImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      address: json['address'] as String,
      port: (json['port'] as num).toInt(),
      message: json['message'] as String,
      systemMessageKey: json['systemMessageKey'] as String?,
      systemMessageArgs: json['systemMessageArgs'] as String?,
      isOutgoing: json['isOutgoing'] as bool? ?? false,
      isSystem: json['isSystem'] as bool? ?? false,
    );

Map<String, dynamic> _$$UdpMessageImplToJson(_$UdpMessageImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'address': instance.address,
      'port': instance.port,
      'message': instance.message,
      'systemMessageKey': instance.systemMessageKey,
      'systemMessageArgs': instance.systemMessageArgs,
      'isOutgoing': instance.isOutgoing,
      'isSystem': instance.isSystem,
    };
