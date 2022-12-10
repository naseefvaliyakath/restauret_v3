// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditUser _$CreditUserFromJson(Map<String, dynamic> json) => CreditUser(
      json['crUserId'] as int?,
      json['crUserName'] as String?,
      json['fdShopId'] as int?,
      json['total'] as num?,
      json['createdAt'] as String?,
    );

Map<String, dynamic> _$CreditUserToJson(CreditUser instance) =>
    <String, dynamic>{
      'crUserId': instance.crUserId,
      'crUserName': instance.crUserName,
      'fdShopId': instance.fdShopId,
      'total': instance.total,
      'createdAt': instance.createdAt,
    };
