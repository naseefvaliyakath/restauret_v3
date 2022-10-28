import 'package:json_annotation/json_annotation.dart';

part 'kot_tableChairSet.g.dart';

@JsonSerializable()
class KotTableChairSet{


  @JsonKey(name : "Kot_id")
  int? Kot_id;

  @JsonKey(name : "tableId")
  int tableId;

  @JsonKey(name : "position")
  String? position;


  @JsonKey(name : "chrIndex")
  int? chrIndex;


  @JsonKey(name : "tbChrIndexInDb")
  int? tbChrIndexInDb;

  KotTableChairSet(
      this.Kot_id,
      this.tableId,
      this.position,
      this.chrIndex,
      this.tbChrIndexInDb,); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory KotTableChairSet.fromJson(Map<String, dynamic> json) => _$KotTableChairSetFromJson(json);
  Map<String, dynamic> toJson() => _$KotTableChairSetToJson(this);
}