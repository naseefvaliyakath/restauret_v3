import 'package:json_annotation/json_annotation.dart';

import 'category.dart';

part 'category_response.g.dart';

@JsonSerializable()
class CategoryResponse{


  @JsonKey(name : "error")
  bool? error;

  @JsonKey(name : "errorCode")
  String? errorCode;

  @JsonKey(name : "totalSize")
  int? totalSize;



  @JsonKey(name : "data")
  List<Category>? data;




  CategoryResponse(this.error, this.errorCode, this.totalSize, this.data);

  factory CategoryResponse.fromJson(Map<String, dynamic> json) => _$CategoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);

}