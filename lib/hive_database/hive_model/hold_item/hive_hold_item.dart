import 'package:hive_flutter/adapters.dart';

part 'hive_hold_item.g.dart';

@HiveType(typeId: 0)
class HiveHoldItem {
  //flutter packages pub run build_runner watch --use-polling-watcher --delete-conflicting-outputs
  @HiveField(0)
  final int id;
  @HiveField(1)
  final List<dynamic>? holdItem;
  @HiveField(2)
  final String? date;
  @HiveField(3)
  final String? time;
  @HiveField(4)
  final num? totel;
  @HiveField(5)
  final String? orderType;

  HiveHoldItem({required this.id, this.holdItem, this.date, this.time,this.totel,this.orderType});


}