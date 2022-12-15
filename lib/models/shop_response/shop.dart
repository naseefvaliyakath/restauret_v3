import 'package:json_annotation/json_annotation.dart';

part 'shop.g.dart';

@JsonSerializable()
class Shop{

  @JsonKey(name : "fdShopId")
  int? fdShopId;

  @JsonKey(name : "shopName")
  String? shopName;

  @JsonKey(name : "shopNumber")
  int? shopNumber;

  @JsonKey(name : "shopAddr")
  String? shopAddr;

  @JsonKey(name : "applicationPlan")
  int? applicationPlan;

  @JsonKey(name : "subcId")
  String? subcId;

  @JsonKey(name : "subcIdStatus")
  String? subcIdStatus;

  @JsonKey(name : "password")
  String? password;

  @JsonKey(name : "expiryDate")
  DateTime? expiryDate;

  @JsonKey(name : "logoImg")
  String? logoImg;

  @JsonKey(name : "createdAt")
  DateTime? createdAt;



  Shop(
      this.fdShopId,
      this.shopName,
      this.shopNumber,
      this.shopAddr,
      this.applicationPlan,
      this.subcId,
      this.password,
      this.expiryDate,
      this.logoImg,
); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
  Map<String, dynamic> toJson() => _$ShopToJson(this);
}