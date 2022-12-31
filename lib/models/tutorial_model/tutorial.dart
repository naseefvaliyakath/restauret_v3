import 'package:json_annotation/json_annotation.dart';

part 'tutorial.g.dart';

@JsonSerializable()
class Tutorial{

  @JsonKey(name : "tutorial_id")
  int? tutorial_id;

  @JsonKey(name : "appPlan")
  int? appPlan;

  @JsonKey(name : "title")
  String? title;

  @JsonKey(name : "link")
  String? link;

  @JsonKey(name : "createdAt")
  String? createdAt;




  Tutorial(
      this.tutorial_id,
      this.appPlan,
      this.title,
      this.link,
      this.createdAt,
); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory Tutorial.fromJson(Map<String, dynamic> json) => _$TutorialFromJson(json);
  Map<String, dynamic> toJson() => _$TutorialToJson(this);
}