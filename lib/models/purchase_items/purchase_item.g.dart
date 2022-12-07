// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseItem _$PurchaseItemFromJson(Map<String, dynamic> json) => PurchaseItem(
      json['purchaseId'] as int?,
      json['description'] as String?,
      json['price'] as num?,
      json['fdShopId'] as int?,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PurchaseItemToJson(PurchaseItem instance) =>
    <String, dynamic>{
      'purchaseId': instance.purchaseId,
      'description': instance.description,
      'price': instance.price,
      'fdShopId': instance.fdShopId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
