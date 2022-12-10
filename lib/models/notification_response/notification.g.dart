// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      json['fdShopId'] as int?,
      json['description'] as String?,
      json['title'] as String?,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'fdShopId': instance.fdShopId,
      'description': instance.description,
      'title': instance.title,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
