import 'package:json_annotation/json_annotation.dart';
import 'package:rest_verision_3/models/complaints/complaint_item.dart';

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
