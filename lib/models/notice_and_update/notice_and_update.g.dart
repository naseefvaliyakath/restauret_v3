// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_and_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeAndUpdate _$NoticeAndUpdateFromJson(Map<String, dynamic> json) =>
    NoticeAndUpdate(
      json['noticeUpdateId'] as int?,
      json['type'] as String?,
      (json['version'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['platform'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['nextShowingDate'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      json['timeInterval'] as int?,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      json['dismissable'] as bool?,
      json['message'] as String?,
    );

Map<String, dynamic> _$NoticeAndUpdateToJson(NoticeAndUpdate instance) =>
    <String, dynamic>{
      'noticeUpdateId': instance.noticeUpdateId,
      'type': instance.type,
      'platform': instance.platform,
      'version': instance.version,
      'message': instance.message,
      'dismissable': instance.dismissable,
      'nextShowingDate': instance.nextShowingDate,
      'timeInterval': instance.timeInterval,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
