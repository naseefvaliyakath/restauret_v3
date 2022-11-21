// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitchen_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KitchenOrder _$KitchenOrderFromJson(Map<String, dynamic> json) => KitchenOrder(
      Kot_id: json['Kot_id'] as int?,
      error: json['error'] as bool?,
      errorCode: json['errorCode'] as String?,
      totalSize: json['totalSize'] as int?,
      fdOrder: (json['fdOrder'] as List<dynamic>?)
          ?.map((e) => OrderBill.fromJson(e as Map<String, dynamic>))
          .toList(),
      fdOrderStatus: json['fdOrderStatus'] as String?,
      fdOrderType: json['fdOrderType'] as String?,
      fdDelAddress: json['fdDelAddress'] as Map<String, dynamic>?,
      totalPrice: json['totelPrice'] as num?,
      orderColor: json['orderColor'] as int?,
    )
      ..fdOnlineApp = json['fdOnlineApp'] as String?
      ..kotTableChairSet = json['kotTableChairSet'] as List<dynamic>?
      ..kotTime = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String);

Map<String, dynamic> _$KitchenOrderToJson(KitchenOrder instance) =>
    <String, dynamic>{
      'Kot_id': instance.Kot_id,
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'fdOrderStatus': instance.fdOrderStatus,
      'fdOrderType': instance.fdOrderType,
      'fdDelAddress': instance.fdDelAddress,
      'fdOnlineApp': instance.fdOnlineApp,
      'totelPrice': instance.totalPrice,
      'fdOrder': instance.fdOrder,
      'kotTableChairSet': instance.kotTableChairSet,
      'orderColor': instance.orderColor,
      'createdAt': instance.kotTime?.toIso8601String(),
    };
