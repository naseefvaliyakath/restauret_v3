// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitchen_order_array.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KitchenOrderArray _$KitchenOrderArrayFromJson(Map<String, dynamic> json) =>
    KitchenOrderArray(
      error: json['error'] as bool,
      errorCode: json['errorCode'] as String,
      totalSize: json['totalSize'] as int,
      kitchenOrder: (json['kitchenOrder'] as List<dynamic>?)
          ?.map((e) => KitchenOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KitchenOrderArrayToJson(KitchenOrderArray instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorCode': instance.errorCode,
      'totalSize': instance.totalSize,
      'kitchenOrder': instance.kitchenOrder,
    };
