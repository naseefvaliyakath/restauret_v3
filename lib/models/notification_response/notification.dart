import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class NotificationModel{

  @JsonKey(name : "fdShopId")
  int? fdShopId;

  @JsonKey(name : "description")
  String? description;

  @JsonKey(name : "title")
  String? title;


  @JsonKey(name : "createdAt")
  DateTime? createdAt;



  NotificationModel(
      this.fdShopId,
      this.description,
      this.title,
      this.createdAt,
); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}