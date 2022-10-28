import 'package:json_annotation/json_annotation.dart';
part 'order_bill.g.dart';

@JsonSerializable()
class OrderBill{

  @JsonKey(name : "fdId")
  int? fdId;

  @JsonKey(name : "name")
  String? name;


  @JsonKey(name : "qnt")
  int? qnt;

  @JsonKey(name : "price")
  num? price;



  @JsonKey(name : "ktNote")
  String? ktNote;

  @JsonKey(name : "ordStatus")
  String? ordStatus;



  OrderBill(
      this.fdId,
      this.name,
      this.qnt,
      this.price,
      this.ktNote,
      this.ordStatus,
      ); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory OrderBill.fromJson(Map<String, dynamic> json) => _$OrderBillFromJson(json);
  Map<String, dynamic> toJson() => _$OrderBillToJson(this);
}