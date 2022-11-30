// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_debit_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditDebitResponse _$CreditDebitResponseFromJson(Map<String, dynamic> json) =>
    CreditDebitResponse(
      json['error'] as bool?,
      json['errorCode'] as String?,
      json['totalSize'] as int?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => CreditDebit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreditDebitResponseToJson(
        CreditDebitResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'data': instance.data,
    };
