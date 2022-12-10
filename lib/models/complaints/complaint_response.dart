import 'package:json_annotation/json_annotation.dart';
import 'package:rest_verision_3/models/complaints/complaint_item.dart';
import 'package:rest_verision_3/models/credit_user_response/credit_user.dart';
import 'package:rest_verision_3/models/purchase_items/purchase_item.dart';
import 'package:rest_verision_3/models/room_response/room.dart';

part 'complaint_response.g.dart';
@JsonSerializable()
class ComplaintResponse{


  @JsonKey(name : "error")
  bool? error;

  @JsonKey(name : "errorCode")
  String? errorCode;

  @JsonKey(name : "totalSize")
  int? totalSize;


  @JsonKey(name : "data")
  List<ComplaintItem>? data;


  ComplaintResponse(this.error, this.errorCode, this.totalSize, this.data);

  factory ComplaintResponse.fromJson(Map<String, dynamic> json) => _$ComplaintResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ComplaintResponseToJson(this);

}
