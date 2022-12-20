import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rest_verision_3/api_data_loader/food_data.dart';
import 'package:rest_verision_3/api_data_loader/online_app_data.dart';
import 'package:rest_verision_3/api_data_loader/room_data.dart';
import 'package:rest_verision_3/hive_database/controller/hive_frequnt_food_controller.dart';
import 'package:rest_verision_3/hive_database/hive_model/frequent_food/frequent_food.dart';
import 'package:rest_verision_3/models/online_app_response/online_app.dart';
import 'package:rest_verision_3/models/room_response/room.dart';
import 'package:rest_verision_3/repository/online_app_repository.dart';
import 'package:rest_verision_3/repository/room_repository.dart';
import 'package:rest_verision_3/screens/login_screen/controller/startup_controller.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../alerts/billing_cash_screen_alert/billing_cash_screen_alert.dart';
import '../../../alerts/kot_alert/kot_bill_show_alert.dart';
import '../../../api_data_loader/category_data.dart';
import '../../../check_internet/check_internet.dart';
import '../../../constants/api_link/api_link.dart';
import '../../../constants/hive_constants/hive_costants.dart';
import '../../../constants/strings/my_strings.dart';
import '../../../error_handler/error_handler.dart';
import '../../../hive_database/controller/hive_delivery_address_controller.dart';
import '../../../hive_database/controller/hive_hold_bill_controller.dart';
import '../../../hive_database/hive_model/delivery_address/hive_delivery_address_item.dart';
import '../../../hive_database/hive_model/hold_item/hive_hold_item.dart';
import '../../../local_storage/local_storage_controller.dart';
import '../../../models/category_response/category.dart';
import '../../../models/foods_response/food_response.dart';
import '../../../models/foods_response/foods.dart';
import '../../../models/kitchen_order_response/kitchen_order.dart';
import '../../../models/kitchen_order_response/order_bill.dart';
import '../../../models/my_response.dart';
import '../../../routes/route_helper.dart';
import '../../../services/dio_error.dart';
import '../../../services/service.dart';
import '../../../socket/socket_controller.dart';
import '../../../widget/common_widget/snack_bar.dart';

class BillingScreenController extends GetxController {
  final FoodData _foodsData = Get.find<FoodData>();
  late IO.Socket socket;
  bool showErr  = Get.find<StartupController>().showErr;
  final ErrorHandler errHandler = Get.find<ErrorHandler>();

  final CategoryData _categoryData = Get.find<CategoryData>();
  final OnlineAppData _onlineAppData = Get.find<OnlineAppData>();
  final RoomData _roomData = Get.find<RoomData>();
  final RoomRepo _roomRepo = Get.find<RoomRepo>();
  final OnlineAppRepo _onlineAppRepo = Get.find<OnlineAppRepo>();
  final SocketController _socketCtrl = Get.find<SocketController>();
  final MyLocalStorage _myLocalStorage = Get.find<MyLocalStorage>();
  final HttpService _httpService = Get.find<HttpService>();
  final HiveHoldBillController _hiveHoldBillController = Get.find<HiveHoldBillController>();
  final HiveFrequentFoodController _hiveFrequentFoodController = Get.find<HiveFrequentFoodController>();
  final HiveDeliveryAddressController _hiveDeliveryAddressController = Get.find<HiveDeliveryAddressController>();

  //? button controller
  final RoundedLoadingButtonController btnControllerKot = RoundedLoadingButtonController();
  final RoundedLoadingButtonController btnControllerSettle = RoundedLoadingButtonController();
  final RoundedLoadingButtonController btnControllerSettleAndPrint = RoundedLoadingButtonController();
  final RoundedLoadingButtonController btnControllerHold = RoundedLoadingButtonController();
  final RoundedLoadingButtonController btnControllerUpdateKot = RoundedLoadingButtonController();

  //? for insert online app
  final RoundedLoadingButtonController btnControllerSubmitOnlineApp = RoundedLoadingButtonController();

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

  //! home delivery address \\!

  //? delivery address model
  HiveDeliveryAddress deliveryAddressItem = HiveDeliveryAddress(id: -1, name: '', number: 0, address: '');

  //? to sending to db in send kot , send settiled order .. etc
  //? data will fill when submit address from popup
  Map<String, dynamic> fdDelAddress = {'name': '', 'number': 0, 'address': ''};

  //? to show text in 'Enter address' white btn
  String selectDeliveryAddrTxt = 'Enter address';

  //! home delivery address \\!

  //! online app screen section !\\
  //? this will store all onlineApp from the server
  //? not showing in UI or change
  final List<OnlineApp> _storedOnlineApp = [];

  //? onlineApp to show in UI
  final List<OnlineApp> _myOnlineApp = [];

  List<OnlineApp> get myOnlineApp => _myOnlineApp;

  //? add online app textCtrl
  late TextEditingController onlineAppNameTD;

  //? to store selected online app name
  String selectedOnlineApp = NO_ONLINE_APP;

  //? to show text in 'Select online' white btn
  String selectedOnlineAppNameTxt = 'Select app';

  //! online app screen section !\\

  //! dining screen !\\

  //? this will store all onlineApp from the server
  //? not showing in UI or change
  final List<Room> _storedRoom = [];

  //? onlineApp to show in UI
  final List<Room> _myRoom = [];

  List<Room> get myRoom => _myRoom;

  //? to show inside the table select dropdown
  final List<int> _tableNumber = TABLE_NUMBER;

  List<int> get tableNumber => _tableNumber;

  //? to show inside the chair select dropdown
  final List<int> _chairNumber = CHAIR_NUMBER;

  List<int> get chairNumber => _chairNumber;

  //? to store the selected table and showing selected table in drop down
  int selectedTable = TABLE_NUMBER[0];

  //? to store the selected chair and showing selected chair in drop down
  int selectedChair = CHAIR_NUMBER[0];

  //? to store the selected room name and showing selected room in drop down
  String selectedRoom = MAIN_ROOM;

  List<dynamic> selectedTableChairSet = [MAIN_ROOM, -1, -1]; //? [room,table,chair]

  //? to set white btn text in billing screen
  String selectTableTxt = 'Select table';

  bool showAddRoom = false;

  //? to show loading while add new room
  bool addRoomLoading = false;

  //! dining screen !\\

  //? to sort food as per category
  String selectedCategory = COMMON_CATEGORY;

  //?payment methods for dropdown in settle order popup

  final List<String> _myPaymentMethods = [CASH, CARD, ONLINE_PAY, PENDINGCASH, TYPE_1, TYPE_2];

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

  //? handling multiple price radio buttons
  int selectedMultiplePrice = 1;
  String multiSelectedFoodName = '';

  //? to detect witch type of order like takeaway , homeDelivery , dining ..etc
  //? this will change as per selected billing type Eg : takeAway,homeDelivery,onlineBooking & Dining
  String orderType = TAKEAWAY;

  //? to set screen heading in header of page
  String screenName = TAKEAWAY_SCREEN_NAME;

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

  //? delivery address txt controller
  late TextEditingController deliveryAddrNameCtrl;
  late TextEditingController deliveryAddrNumberCtrl;
  late TextEditingController deliveryAddrAddressCtrl;

  //? to enter room
  late TextEditingController roomNameTD;

  double netTotal = 0;
  double discountCash = 0;
  double discountPresent = 0;
  double charges = 0;
  double cashReceived = 0;
  double grandTotalNew = 0;

  @override
  void onInit() async {
    initTxtController();
    checkInternetConnection();
    await getxArgumentReceiveHandler();
    socket = _socketCtrl.socket;
    getInitialFood();
    getInitialCategory();
    //? online apps data only need in online app billing screen
    if (orderType == ONLINE) {
      getInitialOnlineApp();
    }
    //? rooms only needed in DINING screen
    if (orderType == DINING) {
      getInitialRoom();
    }
    super.onInit();
  }

  @override
  void onClose() {
    disposeTxtController();
    saveItemInHiveWhenBack();
    super.onClose();
  }

  //? when click user from home screen to check user clicked in witch billing scrren
  //? eg TakeAway,HomeDelivery,online, or dining
  receivingBillingScreenType(String orderTypeOfScreen) async {
    orderType = orderTypeOfScreen;
    if (kDebugMode) {
      print('order type is $orderType');
    }
    //? assigning screen name as per billing page
    settingUpScreenName(orderType);
    getHiveKey();
  }

  //? to handle quickBill
  handleQuickBill({required fdIsLoos, required fdId, required name, required qnt, required fdPrice, required ktNote}) {
    try {
      _billingItems.clear();
      clearAllBillItems();
      clearAllBillItems();
      addFoodToBill(fdIsLoos, fdId, name, qnt, fdPrice, ktNote);
      settleBillingCashAlertShowing(Get.context!, this);
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'handleQuickBill()');
    }
  }

  //? sending kot (this api calling method is directly called in controlled  not in repo)
  //? OK
  Future sendKotOrder() async {
    try {
      if (_billingItems.isNotEmpty) {
        Map<String, dynamic> kotOrder = {
          'fdShopId': Get.find<StartupController>().SHOPE_ID,
          'fdOrder': _billingItems,
          'fdOrderStatus': PENDING,
          'fdOrderType': orderType,
          //? if order settled from kot (in order view screen) need address
          'fdDelAddress': fdDelAddress,
          'fdOnlineApp': selectedOnlineApp,
          'kotTableChairSet': selectedTableChairSet
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
          //? making white btn txt to 'Select app' if its in online billing
          selectedOnlineAppNameTxt = 'Select app';
          //? make selected app NO_ONLINE_APP
          selectedOnlineApp = NO_ONLINE_APP;

          //? make delivery address clear & making white btn to 'Enter address' if its in home delivery
          clearDeliveryAddress();
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'sendKotOrder()');
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
      KitchenOrder emptyKotOrder = EMPTY_KITCHEN_ORDER;
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'receiveUpdateKotBillingItem()');
    }
  }

  //? updating KOT order to server if its from OrderViewPage
  //? OK
  Future updateKotOrder() async {
    try {
      //? checking _billingItems is not empty and received KOT order id is not -1
      if (_billingItems.isNotEmpty && kotIdReceiveFromKotUpdate != -1) {
        Map<String, dynamic> kotOrderUpdate = {
          'fdShopId': Get.find<StartupController>().SHOPE_ID,
          'fdOrder': _billingItems,
          'Kot_id': kotIdReceiveFromKotUpdate,
          //? to change delivery address if any change made by user
          'fdDelAddress': fdDelAddress,
          //? to change selected online app
          'fdOnlineApp': selectedOnlineApp,
          //? to change selected table
          'kotTableChairSet': selectedTableChairSet
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'updateKotOrder()');

    } finally {
      update();
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerUpdateKot.reset();
      });
    }
  }

  //?to handle Get.argument from different pages like from hold item or kot update .. etc
  //? OK
  getxArgumentReceiveHandler() async {
    try {
      //? to handle from orderView page for KOT update
      KitchenOrder emptyKotOrder = EMPTY_KITCHEN_ORDER;
      //? receiving argument  from orderView page
      //? if its null we make a new args with empty kotItem and holdItem  {'holdItem': [], 'kotItem': emptyKotOrder}; to handle error
      //?
      var args = Get.arguments ?? {'holdItem': [], 'kotItem': emptyKotOrder, 'billingPage': 'FROM_OTHER'};
      //? taking kotOrder from args
      KitchenOrder? kotOrder = args['kotItem'] ?? emptyKotOrder;
      //? taking OrderBill fro kotOrder
      List<OrderBill>? orderBill = kotOrder?.fdOrder ?? [];
      //? taking holdItem from args
      List<dynamic>? holdItem = args['holdItem'] ?? [];
      //? to handle the page from dashboard screen or main screen
      String billingPageType = args['billingPage'] ?? 'FROM_OTHER';
      //? to handle quick bill , if item from quick bill icon then fdId should not be -2
      Map<String, dynamic> quickItem = args['quickBill'] ??
          {
            'fdIsLoos': 'no',
            'fdId': -2,
            'qnt': 0,
            'price': 0,
            'ktNote': '',
          };

      if (quickItem['fdId'] != -2) {
        await initialLoadingBillFromHive();
        if (kDebugMode) {
          print('quick bill called');
        }
        //? setting bill type dining or take away , (for  press dining and on long press take away)
        receivingBillingScreenType(quickItem['typeOfBill']);
        handleQuickBill(
          fdIsLoos: quickItem['fdIsLoos'],
          fdId: quickItem['fdId'],
          name: quickItem['fdName'],
          qnt: quickItem['qnt'],
          fdPrice: quickItem['price'],
          ktNote: quickItem['ktNote'],
        );
      }

      if (billingPageType != 'FROM_OTHER') {
        receivingBillingScreenType(billingPageType);
        await initialLoadingBillFromHive();
      }
      //? check orderBill is not empty if its not empty then order is from Overview page for updateKOT
      if (orderBill.isNotEmpty) {
        //? calling method to handle this event (update KOT)
        receiveUpdateKotBillingItem();
        //? setting orderType from kot bill
        orderType = kotOrder?.fdOrderType ?? TAKEAWAY;
        settingUpScreenName(orderType);
        //? setting selectedOnlineApp if its online billingItems
        selectOnlineApp(kotOrder?.fdOnlineApp ?? NO_ONLINE_APP);
        //? setting up table if its Dining
        //? checking array is not empty and order type is Dining
        if ((kotOrder?.kotTableChairSet?.isNotEmpty ?? [].isNotEmpty) &&
            (kotOrder?.fdOrderType ?? TAKEAWAY) == DINING) {
          //? check if its not table selected dining order
          if (kotOrder?.kotTableChairSet?[1] != -1) {
            updateSelectedRoom(kotOrder?.kotTableChairSet?[0] ?? MAIN_ROOM);
            updateSelectedTable(kotOrder?.kotTableChairSet?[1] ?? 1);
            updateSelectedChair(kotOrder?.kotTableChairSet?[2] ?? 1);
            updateTableChairSet(
              room: kotOrder?.kotTableChairSet?[0] ?? MAIN_ROOM,
              table: kotOrder?.kotTableChairSet?[1] ?? 1,
              chair: kotOrder?.kotTableChairSet?[2] ?? 1,
            );
          }
        }

        //? setting deliveryAddress if its homeDelivery
        deliveryAddrNumberCtrl.text = kotOrder?.fdDelAddress?['number'].toString() ?? '0';
        deliveryAddrNameCtrl.text = kotOrder?.fdDelAddress?['name'].toString() ?? '';
        deliveryAddrAddressCtrl.text = kotOrder?.fdDelAddress?['address'].toString() ?? '';
        //? setting white btn in billing screen with address name
        if (deliveryAddrAddressCtrl.text != '') {
          selectDeliveryAddrTxt = deliveryAddrNameCtrl.text;
        }
      }
      //? check holdItem is not empty if its not empty then its from Overview page for to un hold the hold item
      else if (holdItem!.isNotEmpty) {
        //? calling method to handle this event (un holding)
        unHoldBillingItem();
      } else {
        _billingItems.clear;
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'getxArgumentReceiveHandler()');

    } finally {
      update();
    }
  }

  //? kot printing dialog
  //? OK
  kotDialogBox(context) {
    showKotBillAlert(
      type: orderType,
      billingItems: _billingItems,
      context: context,
      //? its required value that's why sending empty kot , its only needed from orderView page
      fullKot: EMPTY_KITCHEN_ORDER,
    );
  }

  //? checking int is in text field
  //? OK
  bool isNumeric(String? s) {
    try {
      if (s == null) {
            return false;
          }
      return double.tryParse(s) != null;
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'isNumeric()');
      return false;

    }
  }

  //? calculation to get total bill and balance cash
  //? OK
  calculateNetTotal() {
    try {
      netTotal = !isNumeric(settleNetTotalCtrl.value.text) ? 0 : double.parse(settleNetTotalCtrl.value.text);
      discountCash =
          !isNumeric(settleDiscountCashCtrl.value.text) ? 0 : double.parse(settleDiscountCashCtrl.value.text);
      discountPresent = !isNumeric(settleDiscountPercentageCtrl.value.text)
          ? 0
          : double.parse(settleDiscountPercentageCtrl.value.text);
      charges = !isNumeric(settleChargesCtrl.value.text) ? 0 : double.parse(settleChargesCtrl.value.text);
      cashReceived =
          !isNumeric(settleCashReceivedCtrl.value.text) ? 0 : double.parse(settleCashReceivedCtrl.value.text);
      //? finding discount value from %
      double discountCashFromPercent = (netTotal / 100) * discountPresent;

      grandTotal.value = netTotal - discountCash - discountCashFromPercent - charges;
      grandTotalNew = double.parse(grandTotal.value.toStringAsFixed(3));
      balanceChange.value = double.parse((settleCashReceivedCtrl.value.text == '' ? 0 : cashReceived - grandTotalNew)
          .toStringAsFixed(3)); //?limit double to 3 pont after decimal
      settleGrandTotalCtrl.value.text = '$grandTotalNew';
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'calculateNetTotal()');
      return;
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'settleBillingCashAlertShowing()');

    }
  }

  //? insert settled bill to dB
  //? OK
  Future<bool> insertSettledBill(context, {bool settleOnly = true}) async {
    RoundedLoadingButtonController btnCtrl = RoundedLoadingButtonController();
    try {
      if (settleOnly) {
        btnCtrl = btnControllerSettle;
      } else {
        btnCtrl = btnControllerSettleAndPrint;
      }
      //? check bill or grand total is empty
      if (_billingItems.isEmpty &&
          (settleGrandTotalCtrl.value.text == '0.0' ||
              settleGrandTotalCtrl.value.text == '0' ||
              settleGrandTotalCtrl.value.text == '')) {
        btnCtrl.error();
        Navigator.pop(context);
        AppSnackBar.errorSnackBar('Error', 'No bill added');
        return false;
      } else {
        Map<String, dynamic> settledBill = {
          'fdShopId': Get.find<StartupController>().SHOPE_ID,
          'fdOrder': billingItems,
          'fdOrderKot': '-1',
          //? kotId will -1 so order not send as kot if bill settled from billing screen
          'fdOrderStatus': COMPLETE,
          'fdOrderType': orderType,
          'fdDelAddress': fdDelAddress,
          'fdOnlineApp': selectedOnlineApp,
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
          btnCtrl.error();
          AppSnackBar.errorSnackBar('Error', parsedResponse.errorCode ?? 'Error');
          return false;
        } else {
          btnCtrl.success();
          //? isClickedSettle will make true to avoid add new items and restrict btn clicks after settled the order
          isClickedSettle.value = true;
          AppSnackBar.successSnackBar('Success', parsedResponse.errorCode ?? 'Error');
          return true;
        }
      }
    } on DioError catch (e) {
      btnCtrl.error();
      AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
      return false;
    } catch (e) {
      btnCtrl.error();
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'insertSettledBill()');
      return false;
    } finally {
      Future.delayed(const Duration(seconds: 1), () {
        btnCtrl.reset();
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
        refreshTodayFood(showSnack: false);
      } else {
        if (kDebugMode) {
          print('food data loaded from food data ${_foodsData.todayFoods.length}');
        }
        //? load data from variable in todayFood
        _storedTodayFoods.clear();
        _storedTodayFoods.addAll(_foodsData.todayFoods);
        //? to show full food in UI
        _myTodayFoods.clear();
        // //? sorting my food by frequently used food
        _myTodayFoods.addAll(finalSortedFood(_storedTodayFoods));
      }
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'getInitialFood()');

    } finally {
      hideLoading();
    }
  }

  //? searchKey get from onChange event in today foodScreen
  searchTodayFood() {
    try {
      if (searchTD.text != '') {
        final suggestion = _storedTodayFoods.where((food) {
          final fdName = food.fdName!.toLowerCase();
          final input = searchTD.text.toLowerCase();
          return fdName.contains(input);
        });
        _myTodayFoods.clear();
        _myTodayFoods.addAll(suggestion);
      } else {
        _myTodayFoods.clear();
        _myTodayFoods.addAll(finalSortedFood(_storedTodayFoods));
      }
      update();
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'searchTodayFood()');
      return;
    }
  }

  //? this function will call getTodayFood() in FoodData

  refreshTodayFood({bool showSnack = true}) async {
    try {
      MyResponse response = await _foodsData.getTodayFoods();
      if (response.statusCode == 1) {
        if (response.data != null) {
          List<Foods> foods = response.data;
          _storedTodayFoods.clear();
          _storedTodayFoods.addAll(foods);
          //? to show full food in UI
          _myTodayFoods.clear();
          //? sorting my food by frequently used food
          _myTodayFoods.addAll(finalSortedFood(_storedTodayFoods));
          if (showSnack) {
            AppSnackBar.successSnackBar('Success', response.message);
          }
        }
      } else {
        if (showSnack) {
          AppSnackBar.errorSnackBar('Error', response.message);
        }
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'refreshTodayFood()');
    } finally {
      update();
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
        refreshCategory();
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'getInitialCategory()');
      return;
    }
  }

  //? ad refresh fresh data from server
  refreshCategory() async {
    try {
      MyResponse response = await _categoryData.getCategory();
      if (response.statusCode == 1) {
        if (response.data != null) {
          List<Category> category = response.data;
          _storedCategory.clear();
          _storedCategory.addAll(category);
          //? to show full food in UI
          _myCategory.clear();
          _myCategory.addAll(_storedCategory);
          AppSnackBar.successSnackBar('Success', response.message);
        }
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'refreshCategory()');
      return;
    } finally {
      update();
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'sortFoodBySelectedCategory()');
      return;
    }
  }

  updateSelectedPayment(String selectedPaymentFromDrop) {
    selectedPayment = selectedPaymentFromDrop;
    update();
  }

  //!  bill manipulations (local bill adding removing and updating )

  //? add items to billing table
  //? OK
  addFoodToBill(String fdIsLoos, int? fdId, String? name, int? qnt, double? price, String? ktNote) {
    try {
      //? checking if the food already added
      var values = _billingItems.map((items) => items['fdId']).toList();

      //?if added
      if (values.contains(fdId)) {
        //? checking if multi price food
        if (fdIsLoos == 'yes') {
          var values = _billingItems.map((items) => items['name']).toList();
          //? check if the multiPriceFood with multipart is added or not
          //? eg : pizza - half is already added
          if (values.contains(name)) {
            //? getting the index of food in list of bil
            var index = values.indexOf(name);
            //? getting the old qnt from bill
            int currentQnt = _billingItems[index]['qnt'] ?? 0;
            //? updating quantity with adding old quantity
            int newQnt = currentQnt + (qnt ?? 0);
            //? updating food to the billing table with the same index
            //? price will be the new price , old price will replace
            updateFodToBill(index, newQnt, price ?? 0, ktNote ?? '');
            //? if pizza- half not added , that is user try to add pizza-quarter
            //? then this portion will add as new item in bill
          } else {
            _billingItems.add({
              'fdId': fdId ?? -1,
              'name': name ?? '',
              'qnt': qnt ?? 0,
              'price': price ?? 0,
              'ktNote': ktNote ?? '',
              'ordStatus': PENDING,
            });
          }
        } else {
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

        //?add food id to hive to use in frequent food
        addFoodToFrequent(fdId ?? -1);
      }
      //? calculating totalPrice
      findTotalPrice();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'addFoodToBill()');
      return;
    }

    update();
  }

  //? add food id to hive to use frequent food
  addFoodToFrequent(int foodId) async {
    try {
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      List<FrequentFood> frequentFoods = _hiveFrequentFoodController.getFrequentFood().toList();
      //? make a new list with food id only for easy checking
      List<int> frequentFoodsFoodId = [];
      for (var element in frequentFoods) {
        if (!frequentFoodsFoodId.contains(element.fdId)) {
          frequentFoodsFoodId.add(element.fdId ?? -1);
        }
      }
      if (!frequentFoodsFoodId.contains(foodId)) {
        FrequentFood food = FrequentFood(id: timeStamp, fdId: foodId, count: 1);
        _hiveFrequentFoodController.createFrequentFood(frequentFood: food);
      } else {
        FrequentFood currentFood = frequentFoods.firstWhere((element) => element.fdId == foodId);
        FrequentFood food =
            FrequentFood(id: currentFood.id, fdId: currentFood.fdId, count: (currentFood.count ?? 0) + 1);
        _hiveFrequentFoodController.updateFrequentFood(frequentFood: food, key: currentFood.key);
      }
      //_hiveFrequentFoodController.clearFrequentFood(index: 1);
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'addFoodToFrequent()');
      return;

    }
  }

  //? sorting my food by frequently used food
  List<Foods> finalSortedFood(List<Foods> myFood) {
    try {
      List<Foods> frequentFood = [];
      List<Foods> frequentFoodSorted = [];
      List<Foods> nonFrequentFood = [];
      List<Foods> finalSortedFood = [];
      List<int> frequentFoodId = [];
      //? taking frequent used food from hive
      List<FrequentFood> assentingSorted = _hiveFrequentFoodController.getFrequentFood();
      //? make it sorted by its count
      assentingSorted.sort((a, b) => b.count!.compareTo(num.parse(a.count.toString())));
      //? making food id list
      for (var element in assentingSorted) {
        if (!frequentFoodId.contains(element.fdId)) {
          frequentFoodId.add(element.fdId ?? -1);
        }
      }

      //? separating frequently used food and normal food
      for (var element in myFood) {
        if (frequentFoodId.contains(element.fdId)) {
          frequentFood.add(element);
        } else {
          nonFrequentFood.add(element);
        }
      }

      //? sorting frequent food by its count
      for (var e in frequentFoodId) {
        var containFood = frequentFood.where((element) => element.fdId == e).toList();
        frequentFoodSorted.addAll(containFood);
      }

      //?adding frequentFood first and nonFrequentFood second to final list
      finalSortedFood.addAll(frequentFoodSorted);
      finalSortedFood.addAll(nonFrequentFood);
      return finalSortedFood;
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'finalSortedFood()');
      return myFood;
    }
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'updateFodToBill()');
      return;
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'removeFoodFromBill()');
      return;
    }
    update();
  }

  //? handle multiple price
  updateSelectedMultiplePrice(int selected, int index) {
    try {
      //? checking in this index food is available , else range error will throw
      if (_myTodayFoods.length >= index) {
        Foods selectedKot = _myTodayFoods[index];
        //? updating price as per selected radio index
        if (selected == 1) {
          multiSelectedFoodName = '';
          multiSelectedFoodName = myTodayFoods[index].fdName ?? '';
          _price = selectedKot.fdFullPrice ?? _price;
        } else if (selected == 2) {
          _price = selectedKot.fdThreeBiTwoPrsPrice ?? _price;
          multiSelectedFoodName = '';
          multiSelectedFoodName = '${myTodayFoods[index].fdName} - 3 / 4';
        } else if (selected == 3) {
          _price = selectedKot.fdHalfPrice ?? _price;
          multiSelectedFoodName = '';
          multiSelectedFoodName = '${myTodayFoods[index].fdName} - half';
        } else if (selected == 4) {
          _price = selectedKot.fdQtrPrice ?? _price;
          multiSelectedFoodName = '';
          multiSelectedFoodName = '${myTodayFoods[index].fdName} - quarter';
        } else {
          multiSelectedFoodName = '';
          multiSelectedFoodName = myTodayFoods[index].fdName ?? '';
          _price = _price;
        }
      }
      selectedMultiplePrice = selected;
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'updateSelectedMultiplePrice()');
      return;
    }
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'clearAllBillItems()');
      return;
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'findTotalPrice()');
      return;
    }
  }

  //? to save bill as  list if back btn press and user click YES to Confirm
  //? OK
  saveBillInHive() {
    try {
      //? to change hiveKey as per order type
      String hiveKey = getHiveKey();
      _myLocalStorage.setData(hiveKey, _billingItems);
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'saveBillInHive()');
      return;
    }
  }

  //? to read hold bill from hive db if again come to page
  //? OK
  Future readBillInHive() {
    //? to change hiveKey as per order type
    String hiveKey = getHiveKey();
    try {
      return _myLocalStorage.readData(hiveKey);
    } catch (e) {
      rethrow;
    }
  }

  //? to clear bill in hive in several conditions
  //? OK
   clearBillInHive() {
    try {
      //? to change hiveKey as per order type
      String hiveKey = getHiveKey();
      return _myLocalStorage.removeData(hiveKey);
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'clearBillInHive()');
      return;
    }
  }

  String getHiveKey() {
    try {
      String hiveKey = HIVE_TAKE_AWAY_BILL;
      if (orderType == TAKEAWAY) {
            hiveKey = HIVE_TAKE_AWAY_BILL;
          }
      if (orderType == HOME_DELEVERY) {
            hiveKey = HIVE_HOME_DELEVERY_BILL;
          }
      if (orderType == DINING) {
            hiveKey = HIVE_DINING_BILL;
          }
      if (orderType == ONLINE) {
            hiveKey = HIVE_ONLINE_BOOKING_BILL;
          }
      return hiveKey;
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'getHiveKey()');
      return HIVE_TAKE_AWAY_BILL;
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'initialLoadingBillFromHive()');
      return;
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
        HiveHoldItem holdBillingItem = HiveHoldItem(
            holdItem: _billingItems.toList(),
            date: date,
            time: time,
            id: timeStamp,
            totel: _totalPrice,
            orderType: orderType);
        await _hiveHoldBillController.createHoldBill(holdBillingItem: holdBillingItem);
        _hiveHoldBillController.getHoldBill();
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'addHoldBillItem()');
      return;
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'unHoldBillingItem()');
      return;
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

  //! ......... for homeDelivery screen only start  ......... !\\

  addDeliveryAddressItem({required BuildContext context}) async {
    try {
      //? check fields is not empty
      if (!checkDeliveryAddressFieldStatus()) {
        int timeStamp = DateTime.now().millisecondsSinceEpoch;
        String name = deliveryAddrNameCtrl.text;
        int number = int.parse(deliveryAddrNumberCtrl.text);
        String address = deliveryAddrAddressCtrl.text;
        deliveryAddressItem = HiveDeliveryAddress(id: timeStamp, name: name, number: number, address: address);
        HiveDeliveryAddress deliveryAddressExistItem =
            HiveDeliveryAddress(id: timeStamp, name: '', number: 0, address: '');
        //? if already number in db then update its addrss and name
        bool isAddressExist = false;
        List<HiveDeliveryAddress> addressList = _hiveDeliveryAddressController.getDeliveryAddress();
        for (var element in addressList) {
          if (element.number == number) {
            isAddressExist = true;
            //? if item exist take element to get index for update
            deliveryAddressExistItem = element;
          }
        }
        //if address exist
        if (isAddressExist) {
          await _hiveDeliveryAddressController.updateDeliveryAddress(
              key: deliveryAddressExistItem.key, deliveryAddressItem: deliveryAddressItem);
          //? to set selected name in white btn in billing screen
          updateSelectDeliveryAddressTxt();
        } else {
          await _hiveDeliveryAddressController.createDeliveryAddress(deliveryAddressItem: deliveryAddressItem);
          //? to set selected name in white btn in billing screen
          updateSelectDeliveryAddressTxt();
        }
        if (kDebugMode) {
          print(_hiveDeliveryAddressController.getDeliveryAddress().length);
        }
        fdDelAddress = {
          //? saving delivery address locally
          'name': deliveryAddressItem.name,
          'number': deliveryAddressItem.number,
          'address': deliveryAddressItem.address,
        };
        Navigator.pop(context);
        //_hiveDeliveryAddressController.clearDeliveryAddress(index: 1);
        update();
      } else {
        AppSnackBar.errorSnackBar('Field is empty !', 'Pleas fill the values !!');
      }
    } on FormatException {
      AppSnackBar.errorSnackBar('Enter valid data !', 'Pleas Enter valid data !');
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'addDeliveryAddressItem()');
      return;
    }
  }

  //? if number is already added , then address and name will pick automatically
  getDeliveryAddressItemForRefillItem(String numberData) {
    try {
      int numberType = int.parse(numberData);
      List<HiveDeliveryAddress> addressList = _hiveDeliveryAddressController.getDeliveryAddress();
      for (var element in addressList) {
        if (element.number == numberType) {
          deliveryAddrNameCtrl.text = element.name ?? '';
          deliveryAddrAddressCtrl.text = element.address ?? '';
        }
      }
      update();
    } on FormatException {
      //? check field is empty , else when user try to clear at last filed will empty then show snack bar
      if (deliveryAddrNumberCtrl.text != '') {
        AppSnackBar.errorSnackBar('Enter valid data !', 'Pleas Enter valid data !');
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'getDeliveryAddressItemForRefillItem()');
      return;
    }
  }

  //? validation for text field
  bool checkDeliveryAddressFieldStatus() {
    String name = deliveryAddrNameCtrl.text;
    String number = deliveryAddrNumberCtrl.text;
    String address = deliveryAddrAddressCtrl.text;

    if (name == '' || number == '' || int.parse(number) == 0 || address == '') {
      return true;
    } else {
      return false;
    }
  }

  //? to set selected name in white btn in billing screen
  updateSelectDeliveryAddressTxt() {
    //? not selected address
    try {
      if (deliveryAddressItem.name == '') {
        selectDeliveryAddrTxt;
      } else {
        selectDeliveryAddrTxt = deliveryAddressItem.name ?? 'Enter address';
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'updateSelectDeliveryAddressTxt()');
      return;
    } finally {
      update();
    }
  }

  clearDeliveryAddress() {
    if (kDebugMode) {
      print('delivery called');
    }
    deliveryAddressItem = HiveDeliveryAddress(id: -1, name: '', number: 0, address: '');
    fdDelAddress = {'name': '', 'number': 0, 'address': ''};
    selectDeliveryAddrTxt = 'Enter address';
    deliveryAddrNumberCtrl.text = '';
    deliveryAddrNameCtrl.text = '';
    deliveryAddrAddressCtrl.text = '';
    update();
  }

  //! ......... for homeDelivery screen only end  ......... !\\

  //! ......... for online app screen only start  ......... !\\

  //? to load o first screen loading
  getInitialOnlineApp() {
    try {
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedOnlineApp from OnlineAppData controller
      if (_onlineAppData.allOnlineApp.isEmpty) {
        if (kDebugMode) {
          print(_onlineAppData.allOnlineApp.length);
          print('data loaded from db');
        }
        refreshOnlineApp(showSnack: false);
      } else {
        if (kDebugMode) {
          print('data loaded from online app data');
        }
        //? load data from variable in todayFood
        _storedOnlineApp.clear();
        _storedOnlineApp.addAll(_onlineAppData.allOnlineApp);
        //? to show online app in UI
        _myOnlineApp.clear();
        _myOnlineApp.addAll(_storedOnlineApp);
      }
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'getInitialOnlineApp()');
      return;
    } finally {
      update();
    }
  }

  //? ad refresh fresh data from server
  refreshOnlineApp({bool showSnack = true}) async {
    try {
      MyResponse response = await _onlineAppData.getOnlineApp();
      if (response.statusCode == 1) {
        if (response.data != null) {
          List<OnlineApp> onlineApp = response.data;
          _storedOnlineApp.clear();
          _storedOnlineApp.addAll(onlineApp);
          //? to show online app online app in UI
          _myOnlineApp.clear();
          _myOnlineApp.addAll(_storedOnlineApp);
          //? to hide snack-bar on page starting , because this method is calling page starting
          if (showSnack) {
            AppSnackBar.successSnackBar('Success', response.message);
          }
        }
      } else {
        //? to hide snack-bar on page starting , because this method is calling page starting
        if (showSnack) {
          AppSnackBar.errorSnackBar('Error',response.message);
        }
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'refreshOnlineApp()');
      return;
    } finally {
      update();
    }
  }

  //? validate before insert
  validateAppDetails(BuildContext context) async {
    try {
      var onlineAppNameNew = '';
      if ((onlineAppNameTD.text != '')) {
        onlineAppNameNew = onlineAppNameTD.text;
        await insertOnlineApp(onlineAppNameNew);
      } else {
        btnControllerSubmitOnlineApp.error();
        AppSnackBar.errorSnackBar('Fill the fields!', 'Enter the values in fields!!');
      }
    } catch (e) {
      btnControllerSubmitOnlineApp.error();
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'validateAppDetails()');
      return;
    } finally {
      Navigator.pop(context);
      onlineAppNameTD.text = '';
      update();
    }
  }

  //?insert category
  Future insertOnlineApp(String appNameString) async {
    try {
      MyResponse response = await _onlineAppRepo.insertOnlineApp(appNameString);
      if (response.statusCode == 1) {
        btnControllerSubmitOnlineApp.success();
        refreshOnlineApp();
        //! snack bar showing when refresh category no need to show here
      } else {
        btnControllerSubmitOnlineApp.error();
        AppSnackBar.errorSnackBar('Error', response.message);
        return;
      }
    } catch (e) {
      btnControllerSubmitOnlineApp.error();
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'insertOnlineApp()');
      return;
    } finally {
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerSubmitOnlineApp.reset();
      });
      onlineAppNameTD.text = '';
      update();
    }
  }

  //? to delete the food
  deleteOnlineApp(int id) async {
    try {
      showLoading();
      MyResponse response = await _onlineAppRepo.deleteOnlineApp(id);
      if (response.statusCode == 1) {
        refreshOnlineApp();
        //! snack bar showing when refreshCategory no need to show here
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
        return;
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'deleteOnlineApp()');
      return;
    } finally {
      hideLoading();
      update();
    }
  }

  //? to update selectedOnline app in variable
  selectOnlineApp(String userSelectedOnlineApp) {
    selectedOnlineApp = userSelectedOnlineApp;
    //? to update text in white btn in billing screen
    updateSelectOnlineAppTxt();
    try {
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'selectOnlineApp()');
      return;
    }
  }

  //? to set selected online app name in white btn in billing screen
  updateSelectOnlineAppTxt() {
    //? not selected online app
    try {
      if (selectedOnlineApp == NO_ONLINE_APP) {
        selectedOnlineAppNameTxt;
      } else {
        selectedOnlineAppNameTxt = selectedOnlineApp;
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'updateSelectOnlineAppTxt()');
      return;
    } finally {
      update();
    }
  }

  //? assigning screen name as per billing page
  settingUpScreenName(String orderTypeName) {
    //? assigning screen name as per billing page
    if (orderTypeName == TAKEAWAY) {
      screenName = TAKEAWAY_SCREEN_NAME;
    }
    if (orderTypeName == HOME_DELEVERY) {
      screenName = HOME_DELEVERY_SCREEN_NAME;
    }
    if (orderTypeName == ONLINE) {
      screenName = ONLINE_SCREEN_NAME;
    }
    if (orderTypeName == DINING) {
      screenName = DINING_SCREEN_NAME;
    }
  }

  resetSelectedOnlineApp() {
    try {
      selectedOnlineAppNameTxt = 'Select app';
      selectedOnlineApp = NO_ONLINE_APP;
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'resetSelectedOnlineApp()');
      return;
    }
  }

  //! ......... for online app screen only end  ......... !\\

  //! dining screen !\\

  //? to load o first screen loading
  getInitialRoom() {
    try {
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedRoom from RoomData controller
      if (_roomData.allRoom.isEmpty) {
        if (kDebugMode) {
          print(_roomData.allRoom.length);
          print('data loaded from db');
        }
        refreshRoom(showSnack: false);
      } else {
        if (kDebugMode) {
          print('data loaded from room data');
        }
        //? load data from variable
        _storedRoom.clear();
        _storedRoom.addAll(_roomData.allRoom);
        //? to show room  in UI
        _myRoom.clear();
        _myRoom.addAll(_storedRoom);
      }
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'getInitialRoom()');
      return;
    } finally {
      update();
    }
  }

  //? this function will call getAllRoom() in RoomData
  refreshRoom({bool showSnack = true}) async {
    try {
      MyResponse response = await _roomData.getAllRoom();
      if (response.statusCode == 1) {
        if (response.data != null) {
          List<Room> rooms = response.data;
          _storedRoom.clear();
          _storedRoom.addAll(rooms);
          //? to show full room in UI
          _myRoom.clear();
          _myRoom.addAll(_storedRoom);
          //? to hide snack-bar on page starting , because this method is calling page starting
          if (showSnack) {
            AppSnackBar.successSnackBar('Success', response.message);
          }
        }
      } else {
        //? to hide snack-bar on page starting , because this method is calling page starting
        if (showSnack) {
          AppSnackBar.errorSnackBar('Error', response.message);
        }
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'refreshRoom()');
      return;
    } finally {
      update();
    }
  }

  //? to show table in drop down
  updateSelectedTable(int tableNumber) {
    selectedTable = tableNumber;
    update();
  }

  //? to show chair in drop down
  updateSelectedChair(int chairNumber) {
    selectedChair = chairNumber;
    update();
  }

  //? to show room in drop down
  updateSelectedRoom(String roomName) {
    selectedRoom = roomName;
    update();
  }

  //? to store data in array to send to server
  updateTableChairSet({required String room, required int table, required int chair}) {
    try {
      List<dynamic> tableChairSet = [room, table, chair];
      selectedTableChairSet = tableChairSet;
      selectTableTxt = 'T-$table C-$chair';
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'updateTableChairSet()');
      return;
    }
  }

  resetTableChairSetValues() {
    try {
      //? to set all dropdown initial state
      selectedRoom = MAIN_ROOM;
      selectedTable = 1;
      selectedChair = 1;
      //? to set array to server
      selectedTableChairSet = [MAIN_ROOM, -1, -1];
      //? to set white btn text
      selectTableTxt = 'Select table';
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'resetTableChairSetValues()');
      return;
    }
  }

  updateShowAddRoom(bool isShowing) {
    showAddRoom = isShowing;
    update();
  }

  //?insert room
  Future insertRoom() async {
    try {
      addRoomLoading = true;
      update();
      String roomNameString = '';
      roomNameString = roomNameTD.text;
      if (roomNameString.trim() != '') {
        MyResponse response = await _roomRepo.insertRoom(roomNameString);
        if (response.statusCode == 1) {
          refreshRoom();
          //! snack bar showing when refresh category no need to show here
        } else {
          AppSnackBar.errorSnackBar('Error', response.message);
          return;
        }
      } else {
        AppSnackBar.errorSnackBar('Field is Empty', 'Pleas enter any room name');
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'insertRoom()');
      return;
    } finally {
      roomNameTD.text = '';
      addRoomLoading = false;
      showAddRoom = false;
      update();
    }
  }

  //? to delete the room
  deleteRoom({required int roomId, required String roomName}) async {
    try {
      //? check user try to delete main room
      if (roomName != MAIN_ROOM) {
        addRoomLoading = true;
        update();
        MyResponse response = await _roomRepo.deleteRoom(roomId);
        if (response.statusCode == 1) {
          refreshRoom();
          //? to close opened drop down after delete
          Get.back();
          //! snack bar showing when refreshCategory no need to show here
        } else {
          AppSnackBar.errorSnackBar('Error', response.message);
          return;
        }
      } else {
        AppSnackBar.errorSnackBar('Error', 'Cannot delete this category');
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'billing_screen_controller',methodName: 'deleteRoom()');
      return;
    } finally {
      addRoomLoading = false;
      update();
    }
  }

  //! dining screen !\\

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

  Future<bool> saveItemInHiveWhenBack() async {
    //? if navigated from kot update  tab on back press not ask save in hive
    if (isNavigateFromKotUpdate == true) {
      return true;
    } else {
      //? checking if any bill added in the list
      if (billingItems.isNotEmpty) {
        await saveBillInHive();
        return true;
      } else {
        return true;
      }
    }
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

    //? delivery address
    deliveryAddrNameCtrl = TextEditingController();
    deliveryAddrNumberCtrl = TextEditingController();
    deliveryAddrAddressCtrl = TextEditingController();

    //? for add new online app
    onlineAppNameTD = TextEditingController();
    //? room name
    roomNameTD = TextEditingController();
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

    deliveryAddrNameCtrl.dispose();
    deliveryAddrNumberCtrl.dispose();
    deliveryAddrAddressCtrl.dispose();

    onlineAppNameTD.dispose();
    roomNameTD.dispose();
  }
}
