import 'package:json_annotation/json_annotation.dart';
import 'package:rest_verision_3/models/shop_response/shop.dart';

part 'shop_response.g.dart';
@JsonSerializable()
class ShopResponse{


  @JsonKey(name : "error")
  bool? error;

  @JsonKey(name : "errorCode")
  String? errorCode;

  @JsonKey(name : "totalSize")
  int? totalSize;



  @JsonKey(name : "data")
  Shop? data;




  ShopResponse(this.error, this.errorCode, this.totalSize, this.data);

  factory ShopResponse.fromJson(Map<String, dynamic> json) => _$ShopResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ShopResponseToJson(this);

}
