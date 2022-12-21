import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../error_handler/error_handler.dart';
import '../box_repository.dart';
import '../hive_model/hold_item/hive_hold_item.dart';



class HiveHoldBillController extends GetxController {
  final ErrorHandler errHandler = Get.find<ErrorHandler>();
  ///?hold items
  final Box _holdBillItemBox = BoxRepository.getHoldBillingBox();
  Box get holdBillItemBox => _holdBillItemBox;




  //? hold items create
  createHoldBill({required HiveHoldItem holdBillingItem}) async {
    try {
      await  _holdBillItemBox.add(holdBillingItem);
      update();
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'hive_hold_bill_food_ctrl',methodName: 'createHoldBill()');
      return;
    }
  }

  updateHoldBill({required int index, required HiveHoldItem holdBillingItem}) async {
    try {
      await _holdBillItemBox.putAt(index, holdBillingItem);
      update();
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'hive_hold_bill_food_ctrl',methodName: 'updateHoldBill()');
      return;
    }
  }

  //? get all hold item
  List<HiveHoldItem> getHoldBill() {
    try {
      List<HiveHoldItem> holdBillingItems = [];
      for (var i = 0; i < _holdBillItemBox.values.length; i++) {
        holdBillingItems.add(_holdBillItemBox.getAt(i));
      }
      update();
      return holdBillingItems;
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'hive_hold_bill_food_ctrl',methodName: 'getHoldBill()');
      return [];
    }
    finally{
      update();
    }
  }

  //? delete hold item
  deleteHoldBill({required int index}) async {
    try {
      await  _holdBillItemBox.deleteAt(index);
      update();
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'hive_hold_bill_food_ctrl',methodName: 'deleteHoldBill()');
      return;
    }
  }

  //? delete all hold item
  clearBill({required int index}) async {
    try {
      await _holdBillItemBox.clear();
      update();
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'hive_hold_bill_food_ctrl',methodName: 'clearBill()');
      return;
    }
  }



}
