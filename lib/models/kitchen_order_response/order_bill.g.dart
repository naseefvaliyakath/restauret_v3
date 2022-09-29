// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderBill _$OrderBillFromJson(Map<String, dynamic> json) => OrderBill(
      json['fdId'] as int?,
      json['name'] as String?,
      json['qnt'] as int?,
      json['price'] as num?,
      json['ktNote'] as String,
      json['ordStatus'] as String,
    );

Map<String, dynamic> _$OrderBillToJson(OrderBill instance) => <String, dynamic>{
      'fdId': instance.fdId,
      'name': instance.name,
      'qnt': instance.qnt,
      'price': instance.price,
      'ktNote': instance.ktNote,
      'ordStatus': instance.ordStatus,
    };
