import 'package:json_annotation/json_annotation.dart';

part 'credit_debit.g.dart';

@JsonSerializable()
class CreditDebit{

  @JsonKey(name : "creditDebitId")
  int? creditDebitId;

  @JsonKey(name : "crUserId")
  int? crUserId;

  @JsonKey(name : "creditAmount")
  num? creditAmount;

  @JsonKey(name : "debitAmount")
  num? debitAmount;

  @JsonKey(name : "fdShopId")
  int? fdShopId;

  @JsonKey(name : "description")
  String? description;

  @JsonKey(name : "createdAt")
  DateTime? createdAt;




  CreditDebit(
      this.creditDebitId,
      this.crUserId,
      this.creditAmount,
      this.debitAmount,
      this.fdShopId,
      this.description,
      this.createdAt,
); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory CreditDebit.fromJson(Map<String, dynamic> json) => _$CreditDebitFromJson(json);
  Map<String, dynamic> toJson() => _$CreditDebitToJson(this);
}