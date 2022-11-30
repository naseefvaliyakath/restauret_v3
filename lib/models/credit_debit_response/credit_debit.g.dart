// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_debit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditDebit _$CreditDebitFromJson(Map<String, dynamic> json) => CreditDebit(
      json['creditDebitId'] as int?,
      json['crUserId'] as int?,
      json['creditAmount'] as num?,
      json['debitAmount'] as num?,
      json['fdShopId'] as int?,
      json['description'] as String?,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CreditDebitToJson(CreditDebit instance) =>
    <String, dynamic>{
      'creditDebitId': instance.creditDebitId,
      'crUserId': instance.crUserId,
      'creditAmount': instance.creditAmount,
      'debitAmount': instance.debitAmount,
      'fdShopId': instance.fdShopId,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
