// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      json['catId'] as int?,
      json['catName'] as String?,
      json['fdShopId'] as int?,
      json['createdAt'] as String?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'catId': instance.catId,
      'catName': instance.catName,
      'fdShopId': instance.fdShopId,
      'createdAt': instance.createdAt,
    };
