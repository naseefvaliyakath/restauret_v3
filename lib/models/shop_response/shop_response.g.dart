// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopResponse _$ShopResponseFromJson(Map<String, dynamic> json) => ShopResponse(
      json['error'] as bool?,
      json['errorCode'] as String?,
      json['totalSize'] as int?,
      json['data'] == null
          ? null
          : Shop.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShopResponseToJson(ShopResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'data': instance.data,
    };
