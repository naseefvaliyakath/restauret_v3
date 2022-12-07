import 'package:json_annotation/json_annotation.dart';

part 'purchase_item.g.dart';

@JsonSerializable()
class PurchaseItem{

  @JsonKey(name : "purchaseId")
  int? purchaseId;

  @JsonKey(name : "description")
  String? description;

  @JsonKey(name : "price")
  num? price;

  @JsonKey(name : "fdShopId")
  int? fdShopId;

  @JsonKey(name : "createdAt")
  DateTime? createdAt;




  PurchaseItem(
      this.purchaseId,
      this.description,
      this.price,
      this.fdShopId,
      this.createdAt,
); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory PurchaseItem.fromJson(Map<String, dynamic> json) => _$PurchaseItemFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseItemToJson(this);
}