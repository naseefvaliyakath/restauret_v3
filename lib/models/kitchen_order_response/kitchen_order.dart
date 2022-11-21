import 'package:json_annotation/json_annotation.dart';

import 'order_bill.dart';

part 'kitchen_order.g.dart';

@JsonSerializable()
class KitchenOrder {
//flutter pub run build_runner build --delete-conflicting-outputs

  @JsonKey(name: "Kot_id")
  int? Kot_id;

  @JsonKey(name: "error")
  bool? error;

  @JsonKey(name: "errorCode")
  String? errorCode;

  @JsonKey(name: "totalSize")
  int? totalSize;

  @JsonKey(name: "fdOrderStatus")
  String? fdOrderStatus;

  @JsonKey(name: "fdOrderType")
  String? fdOrderType;

  @JsonKey(name: "fdDelAddress")
  Map<String,dynamic>? fdDelAddress;

  @JsonKey(name: "fdOnlineApp")
  String? fdOnlineApp;

  @JsonKey(name: "totelPrice")
  num? totalPrice;

  @JsonKey(name: "fdOrder")
  List<OrderBill>? fdOrder;



  @JsonKey(name: "kotTableChairSet")
  List<dynamic>? kotTableChairSet;

  @JsonKey(name: "orderColor")
  int? orderColor;

  @JsonKey(name: "createdAt")
  DateTime? kotTime;

  KitchenOrder({
    required this.Kot_id,
    required this.error,
    required this.errorCode,
    required this.totalSize,
    this.fdOrder,
    required this.fdOrderStatus,
    required this.fdOrderType,
    required this.fdDelAddress,
    required this.totalPrice,
    required this.orderColor,
  });

  factory KitchenOrder.fromJson(Map<String, dynamic> json) => _$KitchenOrderFromJson(json);

  Map<String, dynamic> toJson() => _$KitchenOrderToJson(this);
}
