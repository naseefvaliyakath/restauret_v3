import 'package:json_annotation/json_annotation.dart';
import 'foods.dart';
part 'food_response.g.dart';

@JsonSerializable()
class FoodResponse{
//flutter pub run build_runner build --delete-conflicting-outputs

  @JsonKey(name : "error")
  bool error;

  @JsonKey(name : "errorCode")
  String errorCode;

  @JsonKey(name : "totalSize")
  int totalSize;


  @JsonKey(name : "data")
  List<Foods>? data;




  FoodResponse(this.error, this.errorCode, this.totalSize, this.data);

  factory FoodResponse.fromJson(Map<String, dynamic> json) => _$FoodResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FoodResponseToJson(this);

}