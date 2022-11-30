// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditUserResponse _$CreditUserResponseFromJson(Map<String, dynamic> json) =>
    CreditUserResponse(
      json['error'] as bool?,
      json['errorCode'] as String?,
      json['totalSize'] as int?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => CreditUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreditUserResponseToJson(CreditUserResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'data': instance.data,
    };
