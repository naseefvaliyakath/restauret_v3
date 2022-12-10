// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComplaintItem _$ComplaintItemFromJson(Map<String, dynamic> json) =>
    ComplaintItem(
      json['complaintId'] as int?,
      json['description'] as String?,
      json['phone'] as int?,
      json['complaintType'] as String?,
      json['fdShopId'] as int?,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ComplaintItemToJson(ComplaintItem instance) =>
    <String, dynamic>{
      'complaintId': instance.complaintId,
      'description': instance.description,
      'phone': instance.phone,
      'complaintType': instance.complaintType,
      'fdShopId': instance.fdShopId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
