import 'package:json_annotation/json_annotation.dart';
import 'online_app.dart';
part 'online_app_response.g.dart';

@JsonSerializable()
class OnlineAppResponse{


  @JsonKey(name : "error")
  bool error;

  @JsonKey(name : "errorCode")
  String errorCode;

  @JsonKey(name : "totalSize")
  int totalSize;



  @JsonKey(name : "data")
  List<OnlineApp>? data;




  OnlineAppResponse(this.error, this.errorCode, this.totalSize, this.data);

  factory OnlineAppResponse.fromJson(Map<String, dynamic> json) => _$OnlineAppResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OnlineAppResponseToJson(this);

}
