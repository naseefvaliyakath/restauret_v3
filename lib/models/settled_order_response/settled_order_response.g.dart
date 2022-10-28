// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settled_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettledOrderResponse _$SettledOrderResponseFromJson(
        Map<String, dynamic> json) =>
    SettledOrderResponse(
      error: json['error'] as bool?,
      errorCode: json['errorCode'] as String?,
      totalSize: json['totalSize'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SettledOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SettledOrderResponseToJson(
        SettledOrderResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'data': instance.data,
    };
