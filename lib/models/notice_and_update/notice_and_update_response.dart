import 'package:json_annotation/json_annotation.dart';
import 'package:rest_verision_3/models/room_response/room.dart';
import 'package:rest_verision_3/models/shop_response/shop.dart';

import 'notice_and_update.dart';

part 'notice_and_update_response.g.dart';
@JsonSerializable()
class NoticeAndUpdateResponse{


  @JsonKey(name : "error")
  bool? error;

  @JsonKey(name : "errorCode")
  String? errorCode;

  @JsonKey(name : "totalSize")
  int? totalSize;



  @JsonKey(name : "data")
  NoticeAndUpdate? data;




  NoticeAndUpdateResponse(this.error, this.errorCode, this.totalSize, this.data);

  factory NoticeAndUpdateResponse.fromJson(Map<String, dynamic> json) => _$NoticeAndUpdateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeAndUpdateResponseToJson(this);

}
