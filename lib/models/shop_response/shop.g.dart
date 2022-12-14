// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shop _$ShopFromJson(Map<String, dynamic> json) => Shop(
      json['fdShopId'] as int?,
      json['shopName'] as String?,
      json['shopNumber'] as int?,
      json['shopAddr'] as String?,
      json['applicationPlan'] as int?,
      json['token'] as String?,
      json['subcIdStatus'] as String?,
      json['subcId'] as String?,
      json['password'] as String?,
      json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      json['logoImg'] as String?,
    )..createdAt = json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String);

Map<String, dynamic> _$ShopToJson(Shop instance) => <String, dynamic>{
      'fdShopId': instance.fdShopId,
      'shopName': instance.shopName,
      'shopNumber': instance.shopNumber,
      'shopAddr': instance.shopAddr,
      'applicationPlan': instance.applicationPlan,
      'subcId': instance.subcId,
      'token': instance.token,
      'subcIdStatus': instance.subcIdStatus,
      'password': instance.password,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'logoImg': instance.logoImg,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
