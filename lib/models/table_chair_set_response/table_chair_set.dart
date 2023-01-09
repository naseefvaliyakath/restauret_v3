import 'package:json_annotation/json_annotation.dart';

part 'table_chair_set.g.dart';

@JsonSerializable()
class TableChairSet {
  @JsonKey(name: "table_id")
  int tableId;

  @JsonKey(name: "tableShape")
  int tableShape;

  @JsonKey(name: "room_id")
  int room_id;

  @JsonKey(name: "leftChairCount")
  int leftChairCount;

  @JsonKey(name: "rightChairCount")
  int rightChairCount;

  @JsonKey(name: "topChairCount")
  int topChairCount;

  @JsonKey(name: "bottomChairCount")
  int bottomChairCount;

  TableChairSet({
    required this.tableId,
    required this.tableShape,
    required this.room_id,
    required this.leftChairCount,
    required this.rightChairCount,
    required this.topChairCount,
    required this.bottomChairCount,
  }); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory TableChairSet.fromJson(Map<String, dynamic> json) => _$TableChairSetFromJson(json);

  Map<String, dynamic> toJson() => _$TableChairSetToJson(this);
}
