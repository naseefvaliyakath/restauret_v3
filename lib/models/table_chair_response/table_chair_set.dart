import 'package:json_annotation/json_annotation.dart';

part 'table_chair_set.g.dart';

@JsonSerializable()
class TableChairSet {
  @JsonKey(name: "table_id")
  int? tableId;

  @JsonKey(name: "tableShape")
  int? tableShape;

  @JsonKey(name: "room_id")
  int? room_id;

  @JsonKey(name: "roomName")
  String? roomName;

  @JsonKey(name: "tableNumber")
  int? tableNumber;

  @JsonKey(name: "leftChairCount")
  int? leftChairCount;

  @JsonKey(name: "rightChairCount")
  int? rightChairCount;

  @JsonKey(name: "topChairCount")
  int? topChairCount;

  @JsonKey(name: "bottomChairCount")
  int? bottomChairCount;

  @JsonKey(name: "createdAt")
  String? createdAt;

  TableChairSet({
     this.tableId,
     this.tableShape,
     this.room_id,
      this.roomName,
     this.leftChairCount,
     this.rightChairCount,
     this.topChairCount,
     this.bottomChairCount,
     this.createdAt,
  }); // DateTime get getPublishedAtDate => DateTime.tryParse(publishedAt);

  factory TableChairSet.fromJson(Map<String, dynamic> json) => _$TableChairSetFromJson(json);

  Map<String, dynamic> toJson() => _$TableChairSetToJson(this);
}
