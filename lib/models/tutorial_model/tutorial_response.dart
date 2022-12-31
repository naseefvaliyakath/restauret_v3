import 'package:json_annotation/json_annotation.dart';
import 'package:rest_verision_3/models/room_response/room.dart';
import 'package:rest_verision_3/models/tutorial_model/tutorial.dart';

part 'tutorial_response.g.dart';
@JsonSerializable()
class TutorialResponse{


  @JsonKey(name : "error")
  bool? error;

  @JsonKey(name : "errorCode")
  String? errorCode;

  @JsonKey(name : "totalSize")
  int? totalSize;



  @JsonKey(name : "data")
  List<Tutorial>? data;




  TutorialResponse(this.error, this.errorCode, this.totalSize, this.data);

  factory TutorialResponse.fromJson(Map<String, dynamic> json) => _$TutorialResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TutorialResponseToJson(this);

}
