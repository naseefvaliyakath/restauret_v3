import 'package:json_annotation/json_annotation.dart';
import 'notification.dart';


part 'notification_response.g.dart';
@JsonSerializable()
class NotificationResponse{


  @JsonKey(name : "error")
  bool? error;

  @JsonKey(name : "errorCode")
  String? errorCode;

  @JsonKey(name : "totalSize")
  int? totalSize;



  @JsonKey(name : "data")
  List<NotificationModel>? data;




  NotificationResponse(this.error, this.errorCode, this.totalSize, this.data);

  factory NotificationResponse.fromJson(Map<String, dynamic> json) => _$NotificationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);

}
