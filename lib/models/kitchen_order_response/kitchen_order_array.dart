import 'package:json_annotation/json_annotation.dart';
import 'kitchen_order.dart';
part 'kitchen_order_array.g.dart';

@JsonSerializable()
class KitchenOrderArray {
//flutter pub run build_runner build --delete-conflicting-outputs


  @JsonKey(name: "error")
  bool error;

  @JsonKey(name: "errorCode")
  String errorCode;

  @JsonKey(name: "totalSize")
  int totalSize;



  @JsonKey(name: "kitchenOrder")
  List<KitchenOrder>? kitchenOrder;

  KitchenOrderArray({
    required this.error,
    required this.errorCode,
    required this.totalSize,
    this.kitchenOrder,
  });

  factory KitchenOrderArray.fromJson(Map<String, dynamic> json) => _$KitchenOrderArrayFromJson(json);

  Map<String, dynamic> toJson() => _$KitchenOrderArrayToJson(this);
}
