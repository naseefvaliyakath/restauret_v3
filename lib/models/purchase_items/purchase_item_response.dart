import 'package:json_annotation/json_annotation.dart';
import 'package:rest_verision_3/models/purchase_items/purchase_item.dart';

part 'purchase_item_response.g.dart';
@JsonSerializable()
class PurchaseItemResponse{


  @JsonKey(name : "error")
  bool? error;

  @JsonKey(name : "errorCode")
  String? errorCode;

  @JsonKey(name : "totalSize")
  int? totalSize;



  @JsonKey(name : "data")
  List<PurchaseItem>? data;




  PurchaseItemResponse(this.error, this.errorCode, this.totalSize, this.data);

  factory PurchaseItemResponse.fromJson(Map<String, dynamic> json) => _$PurchaseItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseItemResponseToJson(this);

}
