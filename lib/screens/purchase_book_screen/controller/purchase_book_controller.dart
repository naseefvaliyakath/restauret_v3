import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/purchase_item_data.dart';
import 'package:rest_verision_3/models/purchase_items/purchase_item.dart';
import 'package:rest_verision_3/repository/purchase_item_repository.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../check_internet/check_internet.dart';
import '../../../models/my_response.dart';
import '../../../widget/common_widget/snack_bar.dart';

class PurchaseBookCTRL extends GetxController {
  final PurchaseItemsData _purchaseItemData = Get.find<PurchaseItemsData>();
  final PurchaseItemRepo _purchaseRepo = Get.find<PurchaseItemRepo>();

  final RoundedLoadingButtonController btnControllerAddPurchase = RoundedLoadingButtonController();

  //? to sort purchase
  DateTimeRange selectedDateRangeForPurchase = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  //? for show full screen loading
  bool isLoading = false;

  //? credit  amount td
  late TextEditingController priceTD;
  //?   description
  late TextEditingController descTD;

  //? this will store all purchaser from the server
  //? not showing in UI or change
  final List<PurchaseItem> _storedPurchaseItem = [];

  //? _myPurchaseItem to show in UI
  final List<PurchaseItem> _myPurchaseItem = [];

  List<PurchaseItem> get myPurchaseItem => _myPurchaseItem;


  @override
  void onInit() async {
    priceTD = TextEditingController();
    descTD = TextEditingController();
    checkInternetConnection();
    getInitialPurchaseItem();
    super.onInit();
  }

  @override
  void onClose() async {
    priceTD.dispose();
    descTD.dispose();
    super.onInit();
  }


  //? to load o first screen loading
  getInitialPurchaseItem() {

    try {
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedPurchaseItem from PurchaseItemData controller
      if (_purchaseItemData.allPurchaseItem.isEmpty) {
        if (kDebugMode) {
          print(_purchaseItemData.allPurchaseItem.length);
          print('data loaded from db');
        }
        refreshPurchaseItem(showSnack: false,startDate: DateTime.now().subtract(const Duration(days: 30)),endTime: DateTime.now());
      } else {
        if (kDebugMode) {
          print('data loaded from PurchaseItem data');
        }
        //? load data from variable in this controller
        _storedPurchaseItem.clear();
        _storedPurchaseItem.addAll(_purchaseItemData.allPurchaseItem);
        //? to show full purchase items in UI
        _myPurchaseItem.clear();
        _myPurchaseItem.addAll(_storedPurchaseItem);
      }
      update();
    } catch (e) {
      return;
    }
    finally{
      update();
    }
  }

  //? this function will call getPurchaseItem() in PurchaseItemData
  //? ad refresh fresh data from server
  refreshPurchaseItem({DateTime? startDate , DateTime? endTime,bool showLoad = true, bool showSnack = true}) async {
    try {
      if (showLoad) {
        showLoading();
      }
      MyResponse response = await _purchaseItemData.getAllPurchaseItem(startDate: startDate,endDate: endTime);
      if (response.statusCode == 1) {
        if (response.data != null) {
          List<PurchaseItem> purchaseItem = response.data;
          _storedPurchaseItem.clear();
          _storedPurchaseItem.addAll(purchaseItem);
          //? to show full purchase item in UI
          _myPurchaseItem.clear();
          _myPurchaseItem.addAll(_storedPurchaseItem);
          if (showSnack) {
            AppSnackBar.successSnackBar('Success', 'Updated successfully');
          }
        }
      } else {
        if (showSnack) {
          AppSnackBar.errorSnackBar('Error', 'Something went to wrong !!');
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      hideLoading();
      update();
    }
  }


  //?insert credit debit
  Future insertPurchaseItem() async {
    try {
      String priceGet = '';
      String descriptionGet = '';
      priceGet = priceTD.text;
      descriptionGet = descTD.text;
      num price = num.parse(priceGet);

      if (descriptionGet.trim() != '' && priceGet.trim() != '') {
        MyResponse response = await _purchaseRepo.insertPurchaseItem(price,descriptionGet);
        if (response.statusCode == 1) {
          btnControllerAddPurchase.success();
          refreshPurchaseItem(showSnack: false);
        } else {
          btnControllerAddPurchase.error();
          AppSnackBar.errorSnackBar('Error', response.message);
          return;
        }
      } else {
        btnControllerAddPurchase.error();
        AppSnackBar.errorSnackBar('Field is Empty', 'Pleas enter  name');
      }
    }
    on FormatException {
      AppSnackBar.errorSnackBar('Error', 'Pleas enter a number');
    }
    catch (e) {
      btnControllerAddPurchase.error();
      AppSnackBar.errorSnackBar('Error', 'Something wrong');
    }
    finally {
      priceTD.text = '';
      descTD.text = '';
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerAddPurchase.reset();
      });
      update();
    }
  }

  //?delete purchase
  Future deletePurchase(int id) async {
    try {
      MyResponse response = await _purchaseRepo.deletePurchase(id);
      if (response.statusCode == 1) {
        refreshPurchaseItem(showLoad: true,startDate: selectedDateRangeForPurchase.start,endTime: selectedDateRangeForPurchase.end);
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
      }
    } catch (e) {
      AppSnackBar.errorSnackBar('Error', 'Something wrong !!');
    } finally {
      update();
    }
  }


  //? to show date picker to sort PurchaseItem
  datePickerForPurchaseItem(BuildContext context) async {
    try {
      DateTimeRange? dateRange =  await showDateRangePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.input,
        initialDateRange: selectedDateRangeForPurchase,
        //? user can only select last one month date
        firstDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day - 31),
        lastDate: DateTime.now(),
      );
      if (dateRange != null && dateRange != selectedDateRangeForPurchase) {
        selectedDateRangeForPurchase = dateRange;
        refreshPurchaseItem(startDate: dateRange.start,endTime: dateRange.end,showLoad: false);
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