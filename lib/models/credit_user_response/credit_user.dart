import 'package:json_annotation/json_annotation.dart';

part 'credit_user.g.dart';

@JsonSerializable()
class CreditUser{

  @JsonKey(name : "crUserId")
  int? crUserId;

  @JsonKey(name : "crUserName")
  String? crUserName;

  @JsonKey(name : "fdShopId")
  int? fdShopId;

  @JsonKey(name : "total")
  num? total;

  @JsonKey(name : "createdAt")
  String? createdAt;




  CreditUser(
      this.crUserId,
      this.crUserName,
      this.fdShopId,
      this.total,
      this.createdAt,
); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory CreditUser.fromJson(Map<String, dynamic> json) => _$CreditUserFromJson(json);
  Map<String, dynamic> toJson() => _$CreditUserToJson(this);
}