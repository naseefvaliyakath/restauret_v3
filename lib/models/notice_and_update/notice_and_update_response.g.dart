// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_and_update_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeAndUpdateResponse _$NoticeAndUpdateResponseFromJson(
        Map<String, dynamic> json) =>
    NoticeAndUpdateResponse(
      json['error'] as bool?,
      json['errorCode'] as String?,
      json['totalSize'] as int?,
      json['data'] == null
          ? null
          : NoticeAndUpdate.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NoticeAndUpdateResponseToJson(
        NoticeAndUpdateResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'data': instance.data,
    };
