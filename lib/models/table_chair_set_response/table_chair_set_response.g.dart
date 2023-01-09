// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_chair_set_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableChairSetResponse _$TableChairSetResponseFromJson(
        Map<String, dynamic> json) =>
    TableChairSetResponse(
      json['error'] as bool,
      json['errorCode'] as String,
      json['totalSize'] as int,
      (json['data'] as List<dynamic>?)
          ?.map((e) => TableChairSet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TableChairSetResponseToJson(
        TableChairSetResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'data': instance.data,
    };
