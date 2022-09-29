import 'package:json_annotation/json_annotation.dart';
import '../kitchen_order_response/order_bill.dart';
part 'settled_order.g.dart';

@JsonSerializable()
class SettledOrder {
//flutter pub run build_runner build --delete-conflicting-outputs

  @JsonKey(name: "settled_id")
  int? settled_id;

  @JsonKey(name: "fdShopId")
  int? fdShopId;

  @JsonKey(name: "fdOrder")
  List<OrderBill>? fdOrder;

  @JsonKey(name: "fdOrderKot")
  int? fdOrderKot;

  @JsonKey(name: "fdOrderStatus")
  String? fdOrderStatus;

  @JsonKey(name: "fdOrderType")
  String? fdOrderType;

  @JsonKey(name: "netAmount")
  num? netAmount;

  @JsonKey(name: "discountPersent")
  num? discountPersent;

  @JsonKey(name: "discountCash")
  num? discountCash;

  @JsonKey(name: "charges")
  num? charges;

  @JsonKey(name: "grandTotal")
  num? grandTotal;

  @JsonKey(name: "paymentType")
  String? paymentType;

  @JsonKey(name: "cashReceived")
  num? cashReceived;

  @JsonKey(name: "change")
  num? change;

  SettledOrder(
      { this.settled_id,
       this.fdShopId,
       this.fdOrder,
       this.fdOrderKot,
       this.fdOrderStatus,
       this.fdOrderType,
       this.netAmount,
       this.discountPersent,
       this.discountCash,
       this.charges,
       this.grandTotal,
       this.paymentType,
       this.cashReceived,
       this.change});

  factory SettledOrder.fromJson(Map<String, dynamic> json) => _$SettledOrderFromJson(json);

  Map<String, dynamic> toJson() => _$SettledOrderToJson(this);
}
