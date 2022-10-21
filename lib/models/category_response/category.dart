import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category{

  @JsonKey(name : "CatId")
  int? CatId;

  @JsonKey(name : "catName")
  String? catName;

  @JsonKey(name : "fdShopId")
  int? fdShopId;

  @JsonKey(name : "createdAt")
  String? createdAt;



  Category(
      this.CatId,
      this.catName,
      this.fdShopId,
      this.createdAt,
); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}