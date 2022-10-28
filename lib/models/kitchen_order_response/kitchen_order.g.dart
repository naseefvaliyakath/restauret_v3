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
      totalPrice: json['totelPrice'] as num?,
      orderColor: json['orderColor'] as int?,
    )..kotTableChairSet = (json['kotTableChairSet'] as List<dynamic>?)
        ?.map((e) => KotTableChairSet.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$KitchenOrderToJson(KitchenOrder instance) =>
    <String, dynamic>{
      'Kot_id': instance.Kot_id,
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'fdOrderStatus': instance.fdOrderStatus,
      'fdOrderType': instance.fdOrderType,
      'totelPrice': instance.totalPrice,
      'fdOrder': instance.fdOrder,
      'kotTableChairSet': instance.kotTableChairSet,
      'orderColor': instance.orderColor,
    };
