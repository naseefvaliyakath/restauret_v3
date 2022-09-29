import 'package:json_annotation/json_annotation.dart';

part 'online_app.g.dart';

@JsonSerializable()
class OnlineApp {
  @JsonKey(name: "onlineApp_id")
  int? onlineApp_id;

  @JsonKey(name: "fdShopId")
  int? fdShopId;

  @JsonKey(name: "appName")
  String? appName;
  @JsonKey(name: "appImg")
  String? appImg;

  OnlineApp(
    this.onlineApp_id,
    this.fdShopId,
    this.appName,
  this.appImg
  ); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory OnlineApp.fromJson(Map<String, dynamic> json) => _$OnlineAppFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineAppToJson(this);
}
