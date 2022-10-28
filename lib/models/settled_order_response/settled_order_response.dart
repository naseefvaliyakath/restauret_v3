import 'package:json_annotation/json_annotation.dart';
import 'package:rest_verision_3/models/settled_order_response/settled_order.dart';
part 'settled_order_response.g.dart';

@JsonSerializable()
class SettledOrderResponse {
//flutter pub run build_runner build --delete-conflicting-outputs


  @JsonKey(name: "error")
  bool? error;

  @JsonKey(name: "errorCode")
  String? errorCode;

  @JsonKey(name: "totalSize")
  int? totalSize;




  @JsonKey(name: "data")
  List<SettledOrder>? data;

  SettledOrderResponse({
    required this.error,
    required this.errorCode,
    required this.totalSize,
    this.data,
  });

  factory SettledOrderResponse.fromJson(Map<String, dynamic> json) => _$SettledOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SettledOrderResponseToJson(this);
}
