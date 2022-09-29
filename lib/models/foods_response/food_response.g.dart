// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodResponse _$FoodResponseFromJson(Map<String, dynamic> json) => FoodResponse(
      json['error'] as bool,
      json['errorCode'] as String,
      json['totalSize'] as int,
      (json['data'] as List<dynamic>?)
          ?.map((e) => Foods.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FoodResponseToJson(FoodResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'data': instance.data,
    };
