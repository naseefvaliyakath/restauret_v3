// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settled_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettledOrder _$SettledOrderFromJson(Map<String, dynamic> json) => SettledOrder(
      settled_id: json['settled_id'] as int?,
      fdShopId: json['fdShopId'] as int?,
      fdOrder: (json['fdOrder'] as List<dynamic>?)
          ?.map((e) => OrderBill.fromJson(e as Map<String, dynamic>))
          .toList(),
      fdOrderKot: json['fdOrderKot'] as int?,
      fdOrderStatus: json['fdOrderStatus'] as String?,
      fdOrderType: json['fdOrderType'] as String?,
      fdDelAddress: json['fdDelAddress'] as Map<String, dynamic>?,
      netAmount: json['netAmount'] as num?,
      discountPersent: json['discountPersent'] as num?,
      discountCash: json['discountCash'] as num?,
      charges: json['charges'] as num?,
      grandTotal: json['grandTotal'] as num?,
      paymentType: json['paymentType'] as String?,
      cashReceived: json['cashReceived'] as num?,
      change: json['change'] as num?,
    )
      ..fdOnlineApp = json['fdOnlineApp'] as String?
      ..settledTime = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String);

Map<String, dynamic> _$SettledOrderToJson(SettledOrder instance) =>
    <String, dynamic>{
      'settled_id': instance.settled_id,
      'fdShopId': instance.fdShopId,
      'fdOrder': instance.fdOrder,
      'fdOrderKot': instance.fdOrderKot,
      'fdOrderStatus': instance.fdOrderStatus,
      'fdOrderType': instance.fdOrderType,
      'fdDelAddress': instance.fdDelAddress,
      'fdOnlineApp': instance.fdOnlineApp,
      'netAmount': instance.netAmount,
      'discountPersent': instance.discountPersent,
      'discountCash': instance.discountCash,
      'charges': instance.charges,
      'grandTotal': instance.grandTotal,
      'paymentType': instance.paymentType,
      'cashReceived': instance.cashReceived,
      'change': instance.change,
      'createdAt': instance.settledTime?.toIso8601String(),
    };
