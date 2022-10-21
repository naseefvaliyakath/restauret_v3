import 'package:hive_flutter/adapters.dart';
part 'hive_delivery_address_item.g.dart';

@HiveType(typeId: 1)
class HiveDeliveryAddress extends HiveObject {
  //flutter packages pub run build_runner watch --use-polling-watcher --delete-conflicting-outputs
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final int? number;
  @HiveField(3)
  final String? address;

  HiveDeliveryAddress({required this.id, this.name, this.number, this.address});

}