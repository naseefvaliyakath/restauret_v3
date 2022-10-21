import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../box_repository.dart';
import '../hive_model/delivery_address/hive_delivery_address_item.dart';

class HiveDeliveryAddressController extends GetxController {
  ///delivery address
  final Box _deliveryAddressBox = BoxRepository.getDeliveryAddressBox();
  Box get deliveryAddressBox => _deliveryAddressBox;


  ///delivery address
  createDeliveryAddress({required HiveDeliveryAddress deliveryAddressItem}) async {
    try {
      await _deliveryAddressBox.add(deliveryAddressItem);
      update();
    } catch (e) {
      rethrow;
    }
  }

  updateDeliveryAddress({required int key, required HiveDeliveryAddress deliveryAddressItem}) async {
    try {
      await _deliveryAddressBox.put(key, deliveryAddressItem);
      update();
    } catch (e) {
      rethrow;
    }
  }

  List<HiveDeliveryAddress> getDeliveryAddress() {
    try {
      List<HiveDeliveryAddress> deliveryAddressItems = [];
      for (var i = 0; i < _deliveryAddressBox.values.length; i++) {
        deliveryAddressItems.add(_deliveryAddressBox.getAt(i));
      }
      update();
      return deliveryAddressItems;
    } catch (e) {
      rethrow;
    }
    finally{
      update();
    }
  }

  deleteDeliveryAddress({required int index}) async {
    try {
      await _deliveryAddressBox.deleteAt(index);
      update();
    } catch (e) {
      rethrow;
    }
  }

  clearDeliveryAddress({required int index}) async {
    await _deliveryAddressBox.clear();
    update();
  }

}