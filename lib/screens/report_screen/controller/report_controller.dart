import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_data_loader/settled_order_data.dart';
import '../../../check_internet/check_internet.dart';
import '../../../models/my_response.dart';
import '../../../models/settled_order_response/settled_order.dart';
import '../../../widget/common_widget/snack_bar.dart';
import '../graph_models/graph_model.dart';

class ReportController extends GetxController {
  int totalOrder = 0;
  num totalCash = 0;
  Map<String, Map<String, num>> ordersByTypeMap = {};
  List<OrdersByType> ordersByTypeList = [];

  Map<String, Map<String, num>> sortByFoodMap = {};
  List<OrdersByFoodName> sortByFoodList = [];

  Map<String, Map<String, num>> ordersByPaymentTypeMap = {};
  List<OrdersByPaymentMethod> ordersByPaymentTypeList = [];

  Map<String, Map<String, num>> ordersByOnlineAppMap = {};
  List<OrdersByOnlineApp> ordersByOnlineAppList = [];


  Color getColorForBarChart({required int index}) {
    List<Color> color = [
      Colors.lightBlue,
      Colors.teal,
      Colors.deepPurpleAccent,
      Colors.pinkAccent,
      Colors.cyan,
      Colors.amberAccent,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.brown,
      Colors.orange,
    ];
    if (index >= color.length) {
      return Colors.deepPurpleAccent;
    }
    return color[index];
  }

  void initGraphData(){
    for (var element in _mySettledItem) {
      totalOrder += 1;
      totalCash += element.grandTotal ?? 0;

      // ordersByType
      if (element.fdOrderType != null) {
        if (ordersByTypeMap[element.fdOrderType] == null) {
          ordersByTypeMap[element.fdOrderType!] = {'orderCount': 0, 'total': 0};
        }
        num orderCount = (ordersByTypeMap[element.fdOrderType!]!['orderCount'])! + 1;
        num total = (ordersByTypeMap[element.fdOrderType!]!['total'])! + (element.grandTotal!);
        ordersByTypeMap[element.fdOrderType!] = {'orderCount': orderCount, 'total': total};
      }

      //GroupBypayment type
      if (element.paymentType != null) {
        if (ordersByPaymentTypeMap[element.paymentType] == null) {
          ordersByPaymentTypeMap[element.paymentType!] = {'orderCount': 0, 'total': 0};
        }
        num orderCount = (ordersByPaymentTypeMap[element.paymentType!]!['orderCount'])! + 1;
        num total = (ordersByPaymentTypeMap[element.paymentType!]!['total'])! + (element.grandTotal!);
        ordersByPaymentTypeMap[element.paymentType!] = {'orderCount': orderCount, 'total': total};
      }

      //Group by online app
      if (element.fdOnlineApp != null) {
        if (ordersByOnlineAppMap[element.fdOnlineApp] == null) {
          ordersByOnlineAppMap[element.fdOnlineApp!] = {'orderCount': 0, 'total': 0};
        }
        num orderCount = (ordersByOnlineAppMap[element.fdOnlineApp!]!['orderCount'])! + 1;
        num total = (ordersByOnlineAppMap[element.fdOnlineApp!]!['total'])! + (element.grandTotal!);
        ordersByOnlineAppMap[element.fdOnlineApp!] = {'orderCount': orderCount, 'total': total};
      }

      //sort by food name
      if (element.fdOrder != null) {
        for (var element in element.fdOrder!) {
          if (element.name == null || element.qnt == null || element.price == null) {
            continue;
          }
          if (sortByFoodMap[element.name] == null) {
            sortByFoodMap[element.name!] = {'orderCount': 0, 'total': 0};
          }
          num orderCount = (sortByFoodMap[element.name!]!['orderCount'])! + element.qnt!;
          num total = (sortByFoodMap[element.name!]!['total'])! + (element.price! * element.qnt!);
          sortByFoodMap[element.name!] = {'orderCount': orderCount, 'total': total};
        }
      }
    }

    ordersByTypeMap.forEach((key, value) {
      ordersByTypeList.add(OrdersByType(type: key, orderCount: value['orderCount'] ?? 0, priceTotal: value['total'] ?? 0));
    });

    ordersByPaymentTypeMap.forEach((key, value) {
      ordersByPaymentTypeList.add(OrdersByPaymentMethod(paymentMethod: key, orderCount: value['orderCount'] ?? 0, priceTotal: value['total'] ?? 0));
    });

    ordersByOnlineAppMap.forEach((key, value) {
      ordersByOnlineAppList.add(OrdersByOnlineApp(appName: key, orderCount: value['orderCount'] ?? 0, priceTotal: value['total'] ?? 0));
    });

    sortByFoodMap.forEach((key, value) {
      sortByFoodList.add(OrdersByFoodName(title: key, qtyTotal: value['orderCount'] ?? 0, priceTotal: value['total'] ?? 0));
    });
  }



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

          ordersByTypeList.clear();
          sortByFoodList.clear();
          ordersByOnlineAppList.clear();
          ordersByTypeMap.clear();
          sortByFoodMap.clear();
          ordersByPaymentTypeMap.clear();
          ordersByOnlineAppMap.clear();

          totalOrder = 0;
          totalCash = 0;

          initGraphData();

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