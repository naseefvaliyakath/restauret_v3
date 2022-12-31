// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TutorialResponse _$TutorialResponseFromJson(Map<String, dynamic> json) =>
    TutorialResponse(
      json['error'] as bool?,
      json['errorCode'] as String?,
      json['totalSize'] as int?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => Tutorial.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TutorialResponseToJson(TutorialResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'data': instance.data,
    };
