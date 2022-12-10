// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComplaintResponse _$ComplaintResponseFromJson(Map<String, dynamic> json) =>
    ComplaintResponse(
      json['error'] as bool?,
      json['errorCode'] as String?,
      json['totalSize'] as int?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => ComplaintItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ComplaintResponseToJson(ComplaintResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'data': instance.data,
    };
