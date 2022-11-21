import 'package:hive_flutter/hive_flutter.dart';

import '../constants/hive_constants/hive_costants.dart';
import 'hive_model/delivery_address/hive_delivery_address_item.dart';
import 'hive_model/hold_item/hive_hold_item.dart';




class BoxRepository {

  //? hold items box
  static openHoldBillingBox() async => await Hive.openBox<HiveHoldItem>(HIVE_DATABASE_BILLING_ITEMS);

  static Box getHoldBillingBox() => Hive.box<HiveHoldItem>(HIVE_DATABASE_BILLING_ITEMS);

  static closeHoldBillingBox() async => await Hive.box(HIVE_DATABASE_BILLING_ITEMS).close();

  //? delivery address box
  static openDeliveryAddressBox() async => await Hive.openBox<HiveDeliveryAddress>(HIVE_DATABASE_DELIVERY_ADDRESS_ITEMS);

  static Box getDeliveryAddressBox() => Hive.box<HiveDeliveryAddress>(HIVE_DATABASE_DELIVERY_ADDRESS_ITEMS);

  static closeDeliveryAddressBox() async => await Hive.box(HIVE_DATABASE_DELIVERY_ADDRESS_ITEMS).close();


}