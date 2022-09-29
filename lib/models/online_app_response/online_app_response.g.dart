// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_app_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnlineAppResponse _$OnlineAppResponseFromJson(Map<String, dynamic> json) =>
    OnlineAppResponse(
      json['error'] as bool,
      json['errorCode'] as String,
      json['totalSize'] as int,
      (json['data'] as List<dynamic>?)
          ?.map((e) => OnlineApp.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OnlineAppResponseToJson(OnlineAppResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'data': instance.data,
    };
