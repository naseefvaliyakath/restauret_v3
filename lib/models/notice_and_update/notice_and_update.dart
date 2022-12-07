import 'package:json_annotation/json_annotation.dart';

part 'notice_and_update.g.dart';

@JsonSerializable()
class NoticeAndUpdate{

  @JsonKey(name : "noticeUpdateId")
  int? noticeUpdateId;

  @JsonKey(name : "type")
  String? type;

  @JsonKey(name : "platform")
  List<String>? platform;

  @JsonKey(name : "version")
  List<String>? version;

  @JsonKey(name : "message")
  String? message;

  @JsonKey(name : "dismissable")
  bool? dismissable;

  @JsonKey(name : "nextShowingDate")
  List<int>? nextShowingDate;



  @JsonKey(name : "createdAt")
  DateTime? createdAt;



  NoticeAndUpdate(
      this.noticeUpdateId,
      this.type,
      this.version,
      this.platform,
      this.nextShowingDate,
      this.createdAt,
      this.dismissable,
      this.message,
); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory NoticeAndUpdate.fromJson(Map<String, dynamic> json) => _$NoticeAndUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeAndUpdateToJson(this);
}