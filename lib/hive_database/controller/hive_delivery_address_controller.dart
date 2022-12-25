import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../error_handler/error_handler.dart';
import '../box_repository.dart';
import '../hive_model/delivery_address/hive_delivery_address_item.dart';

class HiveDeliveryAddressController extends GetxController {
  final ErrorHandler errHandler = Get.find<ErrorHandler>();
  ///? delivery address
  final Box _deliveryAddressBox = BoxRepository.getDeliveryAddressBox();
  Box get deliveryAddressBox => _deliveryAddressBox;


  //? delivery address create
  createDeliveryAddress({required HiveDeliveryAddress deliveryAddressItem}) async {
    try {
      await _deliveryAddressBox.add(deliveryAddressItem);
      update();
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'hive_delivery_address_controller',methodName: 'createDeliveryAddress()');
      return;
    }
  }

  //? delivery address update
  updateDeliveryAddress({required int key, required HiveDeliveryAddress deliveryAddressItem}) async {
    try {
      await _deliveryAddressBox.put(key, deliveryAddressItem);
      update();
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'hive_delivery_address_controller',methodName: 'updateDeliveryAddress()');
      return;
    }
  }

  //? get all delivery address
  List<HiveDeliveryAddress> getDeliveryAddress() {
    try {
      List<HiveDeliveryAddress> deliveryAddressItems = [];
      for (var i = 0; i < _deliveryAddressBox.values.length; i++) {
        deliveryAddressItems.add(_deliveryAddressBox.getAt(i));
      }
      update();
      return deliveryAddressItems;
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'hive_delivery_address_controller',methodName: 'getDeliveryAddress()');
      return [];
    }
    finally{
      update();
    }
  }

  //? delete delivery address
  deleteDeliveryAddress({required int index}) async {
    try {
      await _deliveryAddressBox.deleteAt(index);
      update();
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'hive_delivery_address_controller',methodName: 'deleteDeliveryAddress()');
      return;
    }
  }

  //? delete all delivery address
  clearDeliveryAddress() async {
    try {
      await _deliveryAddressBox.clear();
      update();
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'hive_delivery_address_controller',methodName: 'clearDeliveryAddress()');
      return;
    }
  }

}