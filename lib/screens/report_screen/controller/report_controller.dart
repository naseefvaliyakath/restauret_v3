import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/purchase_item_data.dart';
import 'package:rest_verision_3/models/purchase_items/purchase_item.dart';
import 'package:rest_verision_3/repository/purchase_item_repository.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../api_data_loader/settled_order_data.dart';
import '../../../check_internet/check_internet.dart';
import '../../../models/my_response.dart';
import '../../../models/settled_order_response/settled_order.dart';
import '../../../widget/common_widget/snack_bar.dart';

class ReportController extends GetxController {
  final SettledOrderData _settledOrderData = Get.find<SettledOrderData>();

  //? to sort purchase
  DateTimeRange selectedDateRangeForSettledOrder = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  //? for show full screen loading
  bool isLoading = false;


  //? all settled order
  final List<SettledOrder> _mySettledItem = [];

  List<SettledOrder> get mySettledItem => _mySettledItem;


  @override
  void onInit() async {
    checkInternetConnection();
    refreshSettledOrder(showSnack: false);
    super.onInit();
  }

  @override
  void onClose() async {
    super.onInit();
  }


  //? ad refresh fresh data from server
  refreshSettledOrder({DateTime? startDate , DateTime? endTime ,bool showLoad = true,bool showSnack = true}) async {
    try {
      if (showLoad) {
        showLoading();
      }
      MyResponse response = await _settledOrderData.getAllSettledOrder(startDate: startDate,endTime: endTime);
      if(response.statusCode == 1){
        if(response.data != null){
          List<SettledOrder>  settledOrder = response.data;
          _mySettledItem.clear();
          _mySettledItem.addAll(settledOrder);
          // print('settled orders ${_mySettledItem.length}');
          if(showSnack) {
            AppSnackBar.successSnackBar('Success', 'Updated successfully');
          }
        }
      }else{
        if(showSnack) {
          AppSnackBar.errorSnackBar('Error', 'Something went to wrong !!');
        }
      }
    } catch (e) {
      return;
    }finally{
      hideLoading();
      update();
    }

  }


  //? to show date picker to sort PurchaseItem
  datePickerForSettledOrder(BuildContext context) async {
    try {
      DateTimeRange? dateRange =  await showDateRangePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.input,
        initialDateRange: selectedDateRangeForSettledOrder,
        //? user can only select last one month date
        firstDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day - 31),
        lastDate: DateTime.now(),
      );
      if (dateRange != null && dateRange != selectedDateRangeForSettledOrder) {
        selectedDateRangeForSettledOrder = dateRange;
        refreshSettledOrder(startDate: dateRange.start,endTime: dateRange.end,showLoad: false);
      }
    } catch (e) {
      rethrow;
    }
    finally{
      update();
    }
  }

  showLoading() {
    isLoading = true;
    update();
  }

  hideLoading() {
    isLoading = false;
    update();
  }

}