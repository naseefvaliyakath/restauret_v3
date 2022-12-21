import 'package:hive_flutter/adapters.dart';

part 'frequent_food.g.dart';

@HiveType(typeId: 2)
class FrequentFood extends HiveObject{
  //flutter packages pub run build_runner watch --use-polling-watcher --delete-conflicting-outputs
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int? fdId;
  @HiveField(2)
  final int? count;


  FrequentFood({required this.id, this.fdId, this.count});


}