import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rest_verision_3/hive_database/controller/hive_frequnt_food_controller.dart';
import 'box_repository.dart';
import 'hive_model/delivery_address/hive_delivery_address_item.dart';
import 'hive_model/frequent_food/frequent_food.dart';
import 'hive_model/hold_item/hive_hold_item.dart';

class MyHiveInit {
  static initMyHive() async {
    var isWeb = kIsWeb;
    if (isWeb) {
      await Hive.initFlutter();
    } else {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      await Hive.initFlutter(appDocPath);
    }
    Hive.registerAdapter(HiveHoldItemAdapter());
    await BoxRepository.openHoldBillingBox();

    Hive.registerAdapter(HiveDeliveryAddressAdapter());
    await BoxRepository.openDeliveryAddressBox();

    Hive.registerAdapter(FrequentFoodAdapter());
    await BoxRepository.openFrequentFoodBox();
  }
}
