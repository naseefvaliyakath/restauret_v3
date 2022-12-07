import 'package:json_annotation/json_annotation.dart';

part 'foods.g.dart';

@JsonSerializable()
class Foods{

  @JsonKey(name : "fdId")
  int? fdId;

  @JsonKey(name : "fdName")
  String? fdName;

  @JsonKey(name : "fdCategory")
  String? fdCategory;

  @JsonKey(name : "fdFullPrice")
  double? fdFullPrice;

  @JsonKey(name : "fdThreeBiTwoPrsPrice")
  double? fdThreeBiTwoPrsPrice;

  @JsonKey(name : "fdHalfPrice")
  double? fdHalfPrice;

  @JsonKey(name : "fdQtrPrice")
  double? fdQtrPrice;

  @JsonKey(name : "fdIsLoos")
  String? fdIsLoos;

  @JsonKey(name : "cookTime")
  int? cookTime;

  @JsonKey(name : "fdShopId")
  int? fdShopId;

  @JsonKey(name : "fdImg")
  String? fdImg;

  @JsonKey(name : "fdIsToday")
  String? fdIsToday;

  @JsonKey(name : "fdIsQuick")
  String? fdIsQuick;

  @JsonKey(name : "fdIsAvailable")
  String? fdIsAvailable;

  @JsonKey(name : "fdIsSpecial")
  String? fdIsSpecial;

  @JsonKey(name : "createdAt")
  String? createdAt;


  Foods(
      this.fdId,
      this.fdName,
      this.fdCategory,
      this.fdFullPrice,
      this.fdThreeBiTwoPrsPrice,
      this.fdHalfPrice,
      this.fdQtrPrice,
      this.fdIsLoos,
      this.cookTime,
      this.fdShopId,
      this.fdImg,
      this.fdIsToday,
      this.fdIsQuick,
      this.fdIsAvailable,
      this.fdIsSpecial,
      this.createdAt); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory Foods.fromJson(Map<String, dynamic> json) => _$FoodsFromJson(json);
  Map<String, dynamic> toJson() => _$FoodsToJson(this);
}