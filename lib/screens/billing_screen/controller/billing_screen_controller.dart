import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/food_data.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../alerts/billing_cash_screen_alert/billing_cash_screen_alert.dart';
import '../../../alerts/kot_alert/kot_bill_show_alert.dart';
import '../../../api_data_loader/category_data.dart';
import '../../../constants/api_link/api_link.dart';
import '../../../constants/app_secret_constants/app_secret_constants.dart';
import '../../../constants/hive_constants/hive_costants.dart';
import '../../../constants/strings/my_strings.dart';
import '../../../hive_database/controller/hive_hold_bill_controller.dart';
import '../../../hive_database/hive_model/hold_item/hive_hold_item.dart';
import '../../../local_storage/local_storage_controller.dart';
import '../../../models/category_response/category.dart';
import '../../../models/foods_response/food_response.dart';
import '../../../models/foods_response/foods.dart';
import '../../../models/kitchen_order_response/kitchen_order.dart';
import '../../../models/kitchen_order_response/order_bill.dart';
import '../../../routes/route_helper.dart';
import '../../../services/dio_error.dart';
import '../../../services/service.dart';
import '../../../socket/socket_controller.dart';
import '../../../widget/common_widget/snack_bar.dart';

class BillingScreenController extends GetxController {
  final FoodData _foodsData = Get.find<FoodData>();
  late IO.Socket socket;

  final CategoryData _categoryData = Get.find<CategoryData>();
  final SocketController _socketCtrl = Get.find<SocketController>();
  final MyLocalStorage _myLocalStorage = Get.find<MyLocalStorage>();
  final HttpService _httpService = Get.find<HttpService>();
  final HiveHoldBillController _hiveHoldBillController = Get.find<HiveHoldBillController>();

  //? button controller
  final RoundedLoadingButtonController btnControllerKot = RoundedLoadingButtonController();
  final RoundedLoadingButtonController btnControllerSettle = RoundedLoadingButtonController();
  final RoundedLoadingButtonController btnControllerHold = RoundedLoadingButtonController();
  final RoundedLoadingButtonController btnControllerUpdateKot = RoundedLoadingButtonController();


  //? to show loading when food is loading
  bool isLoading = false;

  //? this will store all today food from the server
  //? not showing in UI or change
  final List<Foods> _storedTodayFoods = [];

  //? today food to show in UI
  final List<Foods> _myTodayFoods = [];

  //? today food to show in UI
  List<Foods> get myTodayFoods => _myTodayFoods;

  //? this will store all Category from the server
  //? not showing in UI or change
  final List<Category> _storedCategory = [];

  //? Category to show in UI
  final List<Category> _myCategory = [];

  List<Category> get myCategory => _myCategory;

  //? to sort food as per category
  String selectedCategory = COMMON_CATEGORY;

  //?payment methods for dropdown in settle order popup

  final List<String> _myPaymentMethods = [CASH, CARD, ONLINE, PENDINGCASH, TYPE_1, TYPE_2];

  List<String> get myPaymentMethods => _myPaymentMethods;

  //? to sort food as per category
  String selectedPayment = CASH;

  //? count in billing popup and delete popup
  int _count = 1;

  int get count => _count;

  //? price in billing popup and delete popup
  double _price = 0;

  double get price => _price;

  //? billing list
  final List<dynamic> _billingItems = [];

  List<dynamic> get billingItems => _billingItems;

  //? to visible and hide edit billing item in delete popup
  bool isVisibleEditBillItem = false;

  //? total price in bill
  double _totalPrice = 0;

  double get totalPrice => _totalPrice;

  //? to detect witch type of order like takeaway , homeDelivery , dining ..etc
  //? this will change as per selected billing type Eg : takeAway,homeDelivery,onlineBooking & Dining
   String orderType = TAKEAWAY;



  //? for search field text
  late TextEditingController searchTD;

  //? to disable button after click settle button
  var isClickedSettle = false.obs;

  //? to check navigated from kotUpdate bill
  bool isNavigateFromKotUpdate = false;

  //? kot id from orderView screen for update kot item,it will assign in when navigation
  //? from update from orderView screen
  int kotIdReceiveFromKotUpdate = -1;

  //? grandTotal & balanceChange obx value
  var grandTotal = 0.0.obs;
  var balanceChange = 0.0.obs;

  //? text-controllers inside settled bill popup
  late Rx<TextEditingController> settleNetTotalCtrl;
  late Rx<TextEditingController> settleDiscountCashCtrl;
  late Rx<TextEditingController> settleDiscountPercentageCtrl;
  late Rx<TextEditingController> settleChargesCtrl;
  late Rx<TextEditingController> settleGrandTotalCtrl;
  late Rx<TextEditingController> settleCashReceivedCtrl;

  double netTotal = 0;
  double discountCash = 0;
  double discountPresent = 0;
  double charges = 0;
  double cashReceived = 0;
  double grandTotalNew = 0;

  @override
  void onInit() async {
    initTxtController();
    receivingBillingScreenType();
    await getxArgumentReceiveHandler();
    await initialLoadingBillFromHive();
    getInitialCategory();
    getInitialFood();
    socket = _socketCtrl.socket;
    super.onInit();
  }

  @override
  void onClose() {
    disposeTxtController();
    super.onClose();
  }

  //? when click user from home screen to check user clicked in witch billing scrren
  //? eg TakeAway,HomeDelivery,online, or dining
  receivingBillingScreenType(){
    var args = Get.arguments ?? {'billingPage': TAKEAWAY};
    orderType = args['billingPage'];
    if(args != null){
      if (kDebugMode) {
        print('order tpe is $orderType');
      }

    }
  }


  //? sending kot (this api calling method is directly called in controlled  not in repo)
  //? OK
  Future sendKotOrder() async {
    try {
      if (_billingItems.isNotEmpty) {
        Map<String, dynamic> kotOrder = {
          'fdShopId': SHOPE_ID,
          'fdOrder': _billingItems,
          'fdOrderStatus': PENDING,
          'fdOrderType': orderType,
        };

        final response = await _httpService.insertWithBody(ADD_KOT_ORDER, kotOrder);
        FoodResponse parsedResponse = FoodResponse.fromJson(response.data);
        if (parsedResponse.error ?? true) {
          btnControllerKot.error();
          AppSnackBar.errorSnackBar('Error', parsedResponse.errorCode ?? 'Error');
        } else {
          //? clearing bill table after sending kot
          _billingItems.clear();
          //? remove _billingItem from hive localStorage
          clearBillInHive();
          btnControllerKot.success();
          _totalPrice = 0;
          AppSnackBar.successSnackBar('Success', parsedResponse.errorCode ?? 'Error');
          update();
        }
      }
      //? if bill is empty
      else {
        btnControllerKot.error();
        AppSnackBar.errorSnackBar('No item added', 'No bills added');
      }
    } on DioError catch (e) {
      btnControllerKot.error();
      AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
    } catch (e) {
      btnControllerKot.error();
    } finally {
      update();
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerKot.reset();
      });
    }
  }

  //? edit or update kot billing item  to receive data for orderView screen and process
  //? OK
  receiveUpdateKotBillingItem() {
    try {
      //? empty KOT order to handle error otherwise will throw error
      KitchenOrder emptyKotOrder = KitchenOrder(
        Kot_id: -1,
        error: true,
        errorCode: 'SomethingWrong',
        totalSize: 0,
        fdOrderStatus: PENDING,
        fdOrderType: TAKEAWAY,
        fdOrder: [],
        totalPrice: 0,
        orderColor: 111,
      );
      //? receiving argument  from orderView page
      //? if its null we make a new args with empty kotItem {'kotItem': emptyKotOrder} to handle error
      var args = Get.arguments ?? {'kotItem': emptyKotOrder};
      //? taking kotOrder(full kot order) from args
      KitchenOrder? kotOrder = args['kotItem'] ?? emptyKotOrder;
      //? assign Kot_id to localVariable from kotOrder from kotItem
      kotIdReceiveFromKotUpdate = kotOrder?.Kot_id ?? -1;
      //? taking OrderBill from kotOrder
      List<OrderBill>? orderBill = kotOrder?.fdOrder;
      if (orderBill == null) {
        AppSnackBar.errorSnackBar('Something wrong', 'something went to wrong this order !! ');
        _billingItems.clear();
      } else {
        //? from other pages than overview screen (when come from other page kotItem will be empty)
        if (orderBill.isEmpty) {
          //? normal working will happened that's it direct open from home page
          _billingItems.clear();
        }
        //? if navigated from orderView page
        else {
          isNavigateFromKotUpdate = true; //? to make kot update button in UI
          //? clearing hive bill
          clearBillInHive();
          //? clearing any bill inside billing table
          _billingItems.clear();
          //? adding items inside the KOT to the bill
          for (var element in orderBill) {
            _billingItems.add({
              'fdId': element.fdId ?? -1,
              'name': element.name ?? '',
              'qnt': element.qnt ?? 0,
              'price': element.price?.toDouble() ?? 0,
              'ktNote': element.ktNote ?? '',
              'ordStatus': element.ordStatus ?? PENDING
            });
          }
          //? finding total
          findTotalPrice();
          update();
        }
      }
    } catch (e) {
      _billingItems.clear();
      rethrow;
    }
  }

  //? updating KOT order to server if its from OrderViewPage
  //? OK
  Future updateKotOrder() async {
    try {
      //? checking _billingItems is not empty and received KOT order id is not -1
      if (_billingItems.isNotEmpty && kotIdReceiveFromKotUpdate != -1) {
        Map<String, dynamic> kotOrderUpdate = {
          'fdShopId': SHOPE_ID,
          'fdOrder': _billingItems,
          'Kot_id': kotIdReceiveFromKotUpdate,
        };
        final response = await _httpService.updateData(UPDATE_KOT_ORDER, kotOrderUpdate);

        FoodResponse parsedResponse = FoodResponse.fromJson(response.data);
        if (parsedResponse.error ?? true) {
          btnControllerUpdateKot.error();
          AppSnackBar.errorSnackBar('Error', parsedResponse.errorCode ?? 'Error');
        } else {
          _billingItems.clear();
          clearBillInHive();
          btnControllerUpdateKot.success();
          AppSnackBar.successSnackBar('Success', parsedResponse.errorCode ?? 'Error');
          //? after update returning to orderViewScreen
          Get.offNamed(RouteHelper.getOrderViewScreen());
          update();
        }
      }
      //? if bill is empty
      else {
        btnControllerUpdateKot.error();
        AppSnackBar.errorSnackBar('No item added', 'No bills added');
      }
    } on DioError catch (e) {
      btnControllerUpdateKot.error();
      AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
    } catch (e) {
      btnControllerUpdateKot.error();
    } finally {
      update();
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerUpdateKot.reset();
      });
    }
  }

  //?to handle Get.argument from different pages like from hold item or kot update .. etc
  //? OK
  getxArgumentReceiveHandler() {

    //? to handle from main page
    var args1 = Get.arguments ?? {'billingPage': TAKEAWAY};
    String billingPageType = args1['billingPage'];
    //? to handle from orderView page for KOT update
    KitchenOrder emptyKotOrder = KitchenOrder(
      Kot_id: -1,
      error: true,
      errorCode: 'SomethingWrong',
      totalSize: 0,
      fdOrderStatus: PENDING,
      fdOrderType: TAKEAWAY,
      fdOrder: [],
      totalPrice: 0,
      orderColor: 111,
    );
    //? receiving argument  from orderView page
    //? if its null we make a new args with empty kotItem and holdItem  {'holdItem': [], 'kotItem': emptyKotOrder}; to handle error
    var args = Get.arguments ?? {'holdItem': [], 'kotItem': emptyKotOrder};
    //? taking kotOrder from args
    KitchenOrder? kotOrder = args['kotItem'] ?? emptyKotOrder;
    //? taking OrderBill fro kotOrder
    List<OrderBill>? orderBill = kotOrder?.fdOrder ?? [];
    //? taking holdItem from args
    List<dynamic>? holdItem = args['holdItem'] ?? [];

    if(billingPageType != ''){
      receivingBillingScreenType();
    }
    //? check orderBill is not empty if its not empty then order is from Overview page for updateKOT
    if (orderBill.isNotEmpty) {
      //? calling method to handle this event (update KOT)
      receiveUpdateKotBillingItem();
    }
    //? check holdItem is not empty if its not empty then its from Overview page for to un hold the hold item
    else if (holdItem!.isNotEmpty) {
      //? calling method to handle this event (un holding)
      unHoldBillingItem();
    } else {
      _billingItems.clear;
    }
  }

  //? kot printing dialog
  //? OK
  kotDialogBox(context) {
    showKotBillAlert(type: orderType, billingItems: _billingItems, context: context);
  }

  //? checking int is in text field
  //? OK
  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  //? calculation to get total bill and balance cash
  //? OK
  calculateNetTotal() {
    try {
      netTotal = !isNumeric(settleNetTotalCtrl.value.text) ? 0 : double.parse(settleNetTotalCtrl.value.text);
      discountCash = !isNumeric(settleDiscountCashCtrl.value.text) ? 0 : double.parse(settleDiscountCashCtrl.value.text);
      discountPresent = !isNumeric(settleDiscountPercentageCtrl.value.text) ? 0 : double.parse(settleDiscountPercentageCtrl.value.text);
      charges = !isNumeric(settleChargesCtrl.value.text) ? 0 : double.parse(settleChargesCtrl.value.text);
      cashReceived = !isNumeric(settleCashReceivedCtrl.value.text) ? 0 : double.parse(settleCashReceivedCtrl.value.text);
      //? finding discount value from %
      double discountCashFromPercent = (netTotal / 100) * discountPresent;

      grandTotal.value = netTotal - discountCash - discountCashFromPercent - charges;
      grandTotalNew = double.parse(grandTotal.value.toStringAsFixed(3));
      balanceChange.value = double.parse((settleCashReceivedCtrl.value.text == '' ? 0 : cashReceived - grandTotalNew).toStringAsFixed(3)); //?limit double to 3 pont after decimal
      settleGrandTotalCtrl.value.text = '$grandTotalNew';
    } catch (e) {
      rethrow;
    }
  }

  //? settle the  billing cash alert
  settleBillingCashAlertShowing(context, ctrl) {
    try {
      //? passing values to the textEditingControllers
      settleNetTotalCtrl.value.text = _totalPrice.toString();
      calculateNetTotal();
      //? to show billing screen alert directly from billing screen
      billingCashScreenAlert(context: context, ctrl: ctrl, from: 'billing');
    } catch (e) {
      rethrow;
    }
  }

  //? insert settled bill to dB
  //? OK
  insertSettledBill(context) async {
    try {
      //? check bill or grand total is empty
      if (_billingItems.isEmpty && (settleGrandTotalCtrl.value.text == '0.0' || settleGrandTotalCtrl.value.text == '0' || settleGrandTotalCtrl.value.text == '')) {
        btnControllerSettle.error();
        AppSnackBar.errorSnackBar('Error', 'No bill added');
      } else {
        Map<String, dynamic> settledBill = {
          'fdShopId': SHOPE_ID,
          'fdOrder': billingItems,
          'fdOrderKot': '-1', //? kotId will -1 so order not send as kot if bill settled from billing screen
          'fdOrderStatus': PENDING,
          'fdOrderType': orderType,
          'netAmount': netTotal,
          'discountPersent': discountPresent,
          'discountCash': discountCash,
          'charges': charges,
          'grandTotal': grandTotalNew,
          'paymentType': selectedPayment,
          'cashReceived': cashReceived,
          'change': balanceChange.value
        };

        final response = await _httpService.insertWithBody(ADD_SETTLED_ORDER, settledBill);

        FoodResponse parsedResponse = FoodResponse.fromJson(response.data);
        if (parsedResponse.error ?? true) {
          btnControllerSettle.error();
          AppSnackBar.errorSnackBar('Error', parsedResponse.errorCode ?? 'Error');
        } else {
          btnControllerSettle.success();
          //? isClickedSettle will make true to avoid add new items and restrict btn clicks after settled the order
          isClickedSettle.value = true;
          AppSnackBar.successSnackBar('Success', parsedResponse.errorCode ?? 'Error');
        }
      }
    } on DioError catch (e) {
      btnControllerSettle.error();
      AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
    } catch (e) {
      btnControllerSettle.error();
    } finally {
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerSettle.reset();
      });
    }
  }

  //? again enable settle order for new order button click
  enableNewOrder() {
    isClickedSettle.value = false;
    clearBillInHive();
    _billingItems.clear();
    _totalPrice = 0;
    setSettleCashTxtCtrlToZero();
    update();
  }

  //? to load o first screen loading
  getInitialFood() {
    try {
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedTodayFoods from foodData controller
      showLoading();
      if (_foodsData.todayFoods.isEmpty) {
        if (kDebugMode) {
          print(_foodsData.todayFoods.length);
          print('food data loaded from db');
        }
        _foodsData.getTodayFoods(fromBilling: true);
      } else {
        if (kDebugMode) {
          print('food data loaded from food data ${_foodsData.todayFoods.length}');
        }
        //? load data from variable in todayFood
        _storedTodayFoods.clear();
        _storedTodayFoods.addAll(_foodsData.todayFoods);
        //? to show full food in UI
        _myTodayFoods.clear();
        _myTodayFoods.addAll(_storedTodayFoods);
      }
      update();
    } catch (e) {
      return;
    } finally {
      hideLoading();
    }
  }

  //? searchKey get from onChange event in today foodScreen
  searchTodayFood() {
    try {
      final suggestion = _storedTodayFoods.where((food) {
        final fdName = food.fdName!.toLowerCase();
        final input = searchTD.text.toLowerCase();
        return fdName.contains(input);
      });
      _myTodayFoods.clear();
      _myTodayFoods.addAll(suggestion);
      update();
    } catch (e) {
      return;
    }
  }

  //? this function will call getTodayFood() in FoodData
  //? ad refresh fresh data from server
  refreshTodayFood() async {
    await _foodsData.getTodayFoods(fromBilling: true);
    AppSnackBar.successSnackBar('Success', 'Foods updated successfully');
  }

  //? when call getTodayFood() in FoodData this method will call in success
  //? to update fresh data in FoodData and today food also
  //? this method only call from FoodData like callback
  refreshMyTodayFood(List<Foods> todayFoodsFromFoodData) {
    try {
      _storedTodayFoods.clear();
      _storedTodayFoods.addAll(todayFoodsFromFoodData);
      //? to show full food in UI
      _myTodayFoods.clear();
      _myTodayFoods.addAll(_storedTodayFoods);
      update();
    } catch (e) {
      return;
    }
  }

  //////! category section !//////

  //? to load o first screen loading
  getInitialCategory() {
    try {
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedCategory from CategoryData controller
      if (_categoryData.category.isEmpty) {
        if (kDebugMode) {
          print(_categoryData.category.length);
          print('category data loaded from db');
        }
        _categoryData.getCategory(fromBilling: true);
      } else {
        if (kDebugMode) {
          print('category data loaded from category data');
        }
        //? load data from variable in todayFood
        _storedCategory.clear();
        _storedCategory.addAll(_categoryData.category);
        //? to show full food in UI
        _myCategory.clear();
        _myCategory.addAll(_storedCategory);
      }
      update();
    } catch (e) {
      return;
    }
  }

  //? this function will call getCategory() in CategoryData
  //? ad refresh fresh data from server
  refreshCategory() async {
    try {
      await _categoryData.getCategory(fromBilling: true);
      //? no need to show snack-bar
    } catch (e) {
      rethrow;
    }
  }

  //? when call getCategory() in CategoryData this method will call in success
  //? to update fresh data in CategoryData and _myCategory also
  //? this method only for call getCategory method from CategoryData like callback
  refreshMyCategory(List<Category> categoryFromCategoryData) {
    try {
      _storedCategory.clear();
      _storedCategory.addAll(categoryFromCategoryData);
      //? to show full food in UI
      _myCategory.clear();
      _myCategory.addAll(_storedCategory);
      update();
    } catch (e) {
      return;
    }
  }

  //? to sort food with sorting btn
  sortFoodBySelectedCategory() {
    try {
      List<Foods> sortedFoodByCategory = [];
      //? checking if selected category is COMMON or not selected
      if (selectedCategory.toUpperCase() == COMMON_CATEGORY.toUpperCase()) {
        _myTodayFoods.clear();
        _myTodayFoods.addAll(_storedTodayFoods);
      } else {
        for (var element in _storedTodayFoods) {
          //? iterating the food by selected category from dropdown list and saving inside sortedFoodByCategory list
          if (element.fdCategory == selectedCategory) {
            sortedFoodByCategory.add(element);
          }
        }
        _myTodayFoods.clear();
        _myTodayFoods.addAll(sortedFoodByCategory);
      }
      update();
    } catch (e) {
      rethrow;
    }
  }

  updateSelectedPayment(String selectedPaymentFromDrop) {
    selectedPayment = selectedPaymentFromDrop;
    update();
  }

  //!  bill manipulations (local bill adding removing and updating )

  //? add items to billing table
  //? OK
  addFoodToBill(int? fdId, String? name, int? qnt, double? price, String? ktNote) {
    try {
      //? checking if the food already added
      var values = _billingItems.map((items) => items['fdId']).toList();

      //if added
      if (values.contains(fdId)) {
        //? getting the index of food in list of bil
        var index = values.indexOf(fdId);
        //? getting the old qnt from bill
        int currentQnt = _billingItems[index]['qnt'] ?? 0;
        //? updating quantity with adding old quantity
        int newQnt = currentQnt + (qnt ?? 0);
        //? updating food to the billing table with the same index
        //? price will be the new price , old price will replace
        updateFodToBill(index, newQnt, price ?? 0, ktNote ?? '');
      }
      //? if food is not in the billing table the add food as new food
      else {
        _billingItems.add({
          'fdId': fdId ?? -1,
          'name': name ?? '',
          'qnt': qnt ?? 0,
          'price': price ?? 0,
          'ktNote': ktNote ?? '',
          'ordStatus': PENDING,
        });
      }
      //? calculating totalPrice
      findTotalPrice();
    } catch (e) {
      rethrow;
    }

    update();
  }

  //? update bill qnt and price
  //? this method is used in addFOodToBill() method if food is already available in the billing table
  //? OK
  updateFodToBill(int index, int? qnt, double? price, String? ktNote) {
    try {
      _billingItems[index]['qnt'] = qnt ?? 0;
      _billingItems[index]['price'] = price ?? 0;
      _billingItems[index]['ktNote'] = ktNote ?? '';
      findTotalPrice();
    } catch (e) {
      rethrow;
    }

    update();
  }

  //? to remove from bill
  //? OK
  removeFoodFromBill(int index) async {
    try {
      _billingItems.removeAt(index);
      findTotalPrice();
    } catch (e) {
      rethrow;
    }
    update();
  }

  //?  clear all  bill from hive and local variable
  //? used in clear btn click and after success KOT sending and settledFood btn click
  //? OK
  clearAllBillItems() {
    try {
      billingItems.clear();
      clearBillInHive();
      //? to make total zero
      findTotalPrice();
    } catch (e) {
      rethrow;
    }
    update();
  }

  //?  finding total price
  //? OK
  findTotalPrice() {
    try {
      double totalScores = 0;
      for (var item in _billingItems) {
        double result = (item["price"] ?? 0) * (item["qnt"] ?? 0);
        totalScores += result;
      }
      _totalPrice = totalScores;
      update();
    } catch (e) {
      rethrow;
    }
  }

  //? to save bill as  list if back btn press and user click YES to Confirm
  //? OK
  saveBillInHive() {
    try {
      _myLocalStorage.setData(HIVE_TAKE_AWAY_BILL, _billingItems);
    } catch (e) {
      rethrow;
    }
  }

  //? to read hold bill from hive db if again come to page
  //? OK
  Future readBillInHive() {
    try {
      return _myLocalStorage.readData(HIVE_TAKE_AWAY_BILL);
    } catch (e) {
      rethrow;
    }
  }

  //? to clear bill in hive in several conditions
  //? OK
  Future? clearBillInHive() {
    try {
      return _myLocalStorage.removeData(HIVE_TAKE_AWAY_BILL);
    } catch (e) {
      rethrow;
    }
  }

  //? if costumer save bill when he go back to the other page (eg : save confirmation click YES to hold the bill)
  //? then adding all dta in hive to _billingItems
  //? OK
  initialLoadingBillFromHive() async {
    try {
      List<dynamic>? billFromHive = [];
      billFromHive = await readBillInHive();
      if (billFromHive != null) {
        //? if data in hive
        if (billFromHive.isNotEmpty) {
          _billingItems.addAll(billFromHive);
          findTotalPrice();
          update();
        } else {
          _billingItems.clear();
        }
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  //? hold billing to hold the bill to later its not like save bill saveBillInHive()
  //? saveBillInHive() its for save last entered bill like SharedPreferences
  //? hold item save hold bill in separate dB , it can save multiple hold bill

  //? adding item to holdBillingItem
  //? OK
  addHoldBillItem() async {
    try {
      //? check bill is not empty
      if (_billingItems.isNotEmpty) {
        DateTime now = DateTime.now();
        String date = DateFormat('d MMM yyyy').format(now);
        String time = DateFormat('kk:mm:ss').format(now);
        int timeStamp = DateTime.now().millisecondsSinceEpoch;
        //? should add _billingItems.toList() , if not add.toList() then item not showing without restart
        HiveHoldItem holdBillingItem = HiveHoldItem(holdItem: _billingItems.toList(), date: date, time: time, id: timeStamp, totel: _totalPrice, orderType: orderType);
        await _hiveHoldBillController.createHoldBill(holdBillingItem: holdBillingItem);
        _hiveHoldBillController.getHoldBill();
        //! this bug should fix
        _billingItems.clear();
        clearBillInHive();
        btnControllerHold.success();
        update();
      } else {
        AppSnackBar.errorSnackBar('No item Added', 'No any bill items to hold');
        btnControllerHold.error();
      }
    } catch (e) {
      btnControllerHold.error();
      rethrow;
    } finally {
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerHold.reset();
      });
    }
  }

  //? un holding billing item when navigate page from orderViewScreen for un holding item
  //? OK
  unHoldBillingItem() {
    try {
      var args = Get.arguments ?? {'holdItem': []};
      List<dynamic>? holdItem = args['holdItem'] ?? [];
      if (holdItem == null) {
        AppSnackBar.errorSnackBar('Something wrong', 'something went to wrong this order !! ');
        _billingItems.clear();
      } else {
        //? from other pages than overview screen
        if (holdItem.isEmpty) {
          //? normal working will happened
          _billingItems.clear();
        } else {
          //? if its from orderViewScreen and hase some items
          //? clearing clearBillInHive() & _billingItems before adding to items to _billingItems
          clearBillInHive();
          _billingItems.clear();
          //? adding all hold items
          _billingItems.addAll(holdItem);
          findTotalPrice();
          update();
          if (kDebugMode) {
            print('holdItem ${holdItem.length}');
          }
        }
      }
    } catch (e) {
      _billingItems.clear();
      rethrow;
    }
  }


  //? to visible and hide edit options in delete popup
  //? its used in deleteItemFromBillAlert() alert when toggle update and edit btn
  //? OK
  setIsVisibleEditBillItem(bool val) {
    isVisibleEditBillItem = val;
    update();
  }

  //? set visibility of edit btn false on first time
  //? OK
  setIsVisibleEditBillItemFalse() {
    isVisibleEditBillItem = false;
    update();
  }

  //? used in delete popup &  billing popup to set price in  _price variable
  //? _price its the variable to show price in billing popup between two btn's
  //? OK
  updatePriceFirstTime(double price) {
    _price = price;
    update();
  }

  //? update qnt first time in delete popup and billing popup
  //? _count its the variable to show quantity in billing popup between two btn's
  //? OK
  updateQntFirstTime(int qnt) {
    _count = qnt;
    update();
  }

  //? used in billing popup to start  qnt as one
  //? OK
  setQntToOne() {
    _count = 1;
    update();
  }

  //? used in  billing popup and delete popup to incrementPrice
  incrementPrice() {
    _price++;
    update();
  }

  //? used in  billing popup and delete popup to decrementPrice
  decrementPrice() {
    if (_price > 0) {
      _price--;
    }
    update();
  }

  //? used in  billing popup and delete popup to incrementQnt
  incrementQnt() {
    _count++;
    update();
  }

  //? used in  billing popup and delete popup to decrement Qnt
  //? OK
  decrementQnt() {
    if (_count > 0) {
      _count--;
    }
    update();
  }

  //? OK
  showLoading() {
    isLoading = true;
    update();
  }

  //? OK
  hideLoading() {
    isLoading = false;
    update();
  }

  //? to set the text-controllers like discount, charge , cash received ..etc to zero or empty
  //? currently not used any where
  setSettleCashTxtCtrlToZero() {
    settleNetTotalCtrl.value.text = '';
    settleDiscountCashCtrl.value.text = '';
    settleDiscountPercentageCtrl.value.text = '';
    settleChargesCtrl.value.text = '';
    settleGrandTotalCtrl.value.text = '';
    settleCashReceivedCtrl.value.text = '';
    update();
  }

  //? initialize text controller
  initTxtController() {
    //? to search the food in billing screen
    searchTD = TextEditingController();
    settleNetTotalCtrl = TextEditingController().obs;
    settleDiscountCashCtrl = TextEditingController().obs;
    settleDiscountPercentageCtrl = TextEditingController().obs;
    settleChargesCtrl = TextEditingController().obs;
    settleGrandTotalCtrl = TextEditingController().obs;
    settleCashReceivedCtrl = TextEditingController().obs;
  }

  //? dispose all txtControllers
  disposeTxtController() {
    searchTD.dispose();
    settleNetTotalCtrl.value.dispose();
    settleDiscountCashCtrl.value.dispose();
    settleDiscountPercentageCtrl.value.dispose();
    settleChargesCtrl.value.dispose();
    settleGrandTotalCtrl.value.dispose();
    settleCashReceivedCtrl.value.dispose();
  }
}
