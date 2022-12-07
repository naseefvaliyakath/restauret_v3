// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseItemResponse _$PurchaseItemResponseFromJson(
        Map<String, dynamic> json) =>
    PurchaseItemResponse(
      json['error'] as bool?,
      json['errorCode'] as String?,
      json['totalSize'] as int?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => PurchaseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PurchaseItemResponseToJson(
        PurchaseItemResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'data': instance.data,
    };
