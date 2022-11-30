import 'package:json_annotation/json_annotation.dart';
import 'package:rest_verision_3/models/credit_user_response/credit_user.dart';
import 'package:rest_verision_3/models/room_response/room.dart';

part 'credit_user_response.g.dart';
@JsonSerializable()
class CreditUserResponse{


  @JsonKey(name : "error")
  bool? error;

  @JsonKey(name : "errorCode")
  String? errorCode;

  @JsonKey(name : "totalSize")
  int? totalSize;



  @JsonKey(name : "data")
  List<CreditUser>? data;




  CreditUserResponse(this.error, this.errorCode, this.totalSize, this.data);

  factory CreditUserResponse.fromJson(Map<String, dynamic> json) => _$CreditUserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreditUserResponseToJson(this);

}
