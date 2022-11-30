import 'package:json_annotation/json_annotation.dart';
import 'package:rest_verision_3/models/credit_debit_response/credit_debit.dart';
import 'package:rest_verision_3/models/credit_user_response/credit_user.dart';
import 'package:rest_verision_3/models/room_response/room.dart';

part 'credit_debit_response.g.dart';
@JsonSerializable()
class CreditDebitResponse{


  @JsonKey(name : "error")
  bool? error;

  @JsonKey(name : "errorCode")
  String? errorCode;

  @JsonKey(name : "totalSize")
  int? totalSize;



  @JsonKey(name : "data")
  List<CreditDebit>? data;




  CreditDebitResponse(this.error, this.errorCode, this.totalSize, this.data);

  factory CreditDebitResponse.fromJson(Map<String, dynamic> json) => _$CreditDebitResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreditDebitResponseToJson(this);

}
