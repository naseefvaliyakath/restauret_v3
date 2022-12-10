import 'package:json_annotation/json_annotation.dart';

part 'complaint_item.g.dart';

@JsonSerializable()
class ComplaintItem{

  @JsonKey(name : "complaintId")
  int? complaintId;

  @JsonKey(name : "description")
  String? description;

  @JsonKey(name : "phone")
  int? phone;

  @JsonKey(name : "complaintType")
  String? complaintType;

  @JsonKey(name : "fdShopId")
  int? fdShopId;

  @JsonKey(name : "createdAt")
  DateTime? createdAt;




  ComplaintItem(
      this.complaintId,
      this.description,
      this.phone,
      this.complaintType,
      this.fdShopId,
      this.createdAt,
); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory ComplaintItem.fromJson(Map<String, dynamic> json) => _$ComplaintItemFromJson(json);
  Map<String, dynamic> toJson() => _$ComplaintItemToJson(this);
}