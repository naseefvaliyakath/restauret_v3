import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/repository/kot_repository.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../alerts/billing_cash_screen_alert/billing_cash_screen_alert.dart';
import '../../../alerts/kot_alert/kot_bill_show_alert.dart';
import '../../../api_data_loader/settled_order_data.dart';
import '../../../check_internet/check_internet.dart';
import '../../../constants/api_link/api_link.dart';
import '../../../constants/strings/my_strings.dart';
import '../../../error_handler/error_handler.dart';
import '../../../hive_database/controller/hive_hold_bill_controller.dart';
import '../../../hive_database/hive_model/hold_item/hive_hold_item.dart';
import '../../../models/foods_response/food_response.dart';
import '../../../models/kitchen_order_response/kitchen_order.dart';
import '../../../models/kitchen_order_response/kitchen_order_array.dart';
import '../../../models/kitchen_order_response/order_bill.dart';
import '../../../models/my_response.dart';
import '../../../models/settled_order_response/settled_order.dart';
import '../../../repository/settled_order_repository.dart';
import '../../../routes/route_helper.dart';
import '../../../services/dio_error.dart';
import '../../../services/service.dart';
import '../../../socket/socket_controller.dart';
import '../../../widget/common_widget/snack_bar.dart';
import '../../login_screen/controller/startup_controller.dart';

class OrderViewController extends GetxController {
  final SettledOrderRepo _settledOrderRepo = Get.find<SettledOrderRepo>();
  final KotRepo _kotRepo = Get.find<KotRepo>();
  final SettledOrderData _settledOrderData = Get.find<SettledOrderData>();
  final HttpService _httpService = Get.find<HttpService>();
  final IO.Socket _socket = Get.find<SocketController>().socket;
  final HiveHoldBillController _hiveHoldBillController = Get.find<HiveHoldBillController>();
  bool showErr  = Get.find<StartupController>().showErr;
  final ErrorHandler errHandler = Get.find<ErrorHandler>();

  //? to show and hide loading
  bool isLoading = false;

  //? to toggle KOT ,settled order , hold order ..etc
  int tappedIndex = 0;
  String tappedTabName = 'KOT';

  //? this value will fill index of KOT order list when settle button is click in KOT order  when  settleKotBillingCash() is calling for settle btn click
  //? and with this index retreve the foodOrder from kotBillingList and save in db when calling insertSettledOrder()
  int indexFromKotOrder = -1;

  //? this value will fill the index of settledOrder from settledOrderList when update button is click in settledOrder tab  updateSettleBillingCash() is calling
  //? its used to update current settled order updateSettleBillingCash()
  int indexSettledOrder = -1;

  //? to disable button after click settle button
  var isClickedSettle = false.obs;

  //? btn controller for settle KOT order
  final RoundedLoadingButtonController btnControllerSettle = RoundedLoadingButtonController();

  //? btn controller for cancel KOT order
  final RoundedLoadingButtonController btnControllerCancellKOtOrder = RoundedLoadingButtonController();

  //? used in calculateNetTotal() to show in settled bill alert
  var grandTotal = 0.0.obs;
  var balanceChange = 0.0.obs;

  //? text-controllers inside settled bill popup
  late Rx<TextEditingController> settleNetTotalCtrl;
  late Rx<TextEditingController> settleDiscountCashCtrl;
  late Rx<TextEditingController> settleDiscountPercentageCtrl;
  late Rx<TextEditingController> settleChargesCtrl;
  late Rx<TextEditingController> settleGrandTotalCtrl;
  late Rx<TextEditingController> settleCashReceivedCtrl;

  //?  used in calculateNetTotal() to show in settled bill alert
  double netTotal = 0;
  double discountCash = 0;
  double discountPresent = 0;
  double charges = 0;
  double cashReceived = 0;
  double grandTotalNew = 0;

  //? this will store all SettledOrder from the server
  //? not showing in UI or change
  final List<SettledOrder> _storedAllSettledOrder = [];

  final List<KitchenOrder> _kotBillingItems = [];
  final List<SettledOrder> _settledBillingItems = [];
  final List<HiveHoldItem> _holdBillingItems = [];

  List<KitchenOrder> get kotBillingItems => _kotBillingItems;

  List<SettledOrder> get settledBillingItems => _settledBillingItems;

  List<HiveHoldItem> get holdBillingItems => _holdBillingItems;

  //? billing list for store bill items of KOT  temperately when click settled order from KOT
  //? its used to show bill after in settled order alert when print bill click
  //? used in settleKotBillingCash() check for more info
  final List<dynamic> _billingItems = [];

  List<dynamic> get billingItems => _billingItems;

  //? to show in invoice of settled order from KOT alert
  String orderType = TAKEAWAY;
  Map<String, dynamic> fdDelAddress = {'name': '', 'number': 0, 'address': ''};

  //? to show in invoice of settled order from KOT alert
  String selectedOnlineApp = NO_ONLINE_APP;


  //?payment methods for dropdown in settle order popup

  final List<String> _myPaymentMethods = [CASH, CARD, ONLINE_PAY, PENDINGCASH, TYPE_1, TYPE_2];

  List<String> get myPaymentMethods => _myPaymentMethods;

  //? to receive selected payment for settle bill from KOT alert
  String selectedPayment = CASH;

//? to receive selected payment for update settled bill
  String selectedPaymentForUpdateSettledOrder = CASH;

  //? to sort settled order
  DateTimeRange selectedDateRangeForSettledOrder = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  final player = AudioPlayer();
  final cache = AudioCache();

  @override
  void onInit() async {
    initTxtController();
    checkInternetConnection();
    //? for full feature application
    if(Get.find<StartupController>().applicationPlan == 1){
      _socket.connect();
      setUpKitchenOrderFromDbListener(); //? first load kotBill data from db
      setUpKitchenOrderSingleListener(); //? for new kot order
    }else{
      getAllKot();
    }
    getAllHoldOrder();
    getInitialSettledOrder(); //? to load settled order first time
    super.onInit();
  }

  @override
  void onClose() {
    _socket.close();
    _socket.dispose();
    disposeTxtController();
    super.onClose();
  }


  getAllKot({bool showSnack = false}) async {
    try {
      MyResponse response = await _kotRepo.getAllKot();
      if (response.statusCode == 1) {
        KitchenOrderArray parsedResponse = response.data;
        if (parsedResponse.kitchenOrder == null) {
          _kotBillingItems;
        } else {
          _kotBillingItems.clear();
          _kotBillingItems.addAll(parsedResponse.kitchenOrder?.toList() ?? []);
          if(showSnack){
            AppSnackBar.successSnackBar('Success', response.message);
          }
        }
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'getAllKot()');
      return;
    }
    finally{
      update();
    }

  }

  //? for single order adding live
  setUpKitchenOrderSingleListener() {
    try {
      KitchenOrder order = EMPTY_KITCHEN_ORDER;
      _socket.on('kitchen_orders_receive', (data) async {
        if (kDebugMode) {
          print('kot order single received');
        }
        //? assign single KOT to order variable
        order = KitchenOrder.fromJson(data);
        //?no error
        bool err = order.error ?? true;
        if (!err) {
          //?check if item is already in list
          bool isExist = true;
          for (var element in _kotBillingItems) {
            if (element.Kot_id != order.Kot_id) {
              isExist = false;
            } else {
              isExist = true;
            }
          }
          //?add if not exist
          if (isExist == false) {
            _kotBillingItems.insert(0, order);
            ringAlert();
          } else {
            _kotBillingItems.addAll(_kotBillingItems);
          }
          update();
        } else {
          return;
        }
      });
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'setUpKitchenOrderSingleListener()');
      return;
    }
  }

  //? for first load data to bill from data base
  setUpKitchenOrderFromDbListener() {
    try {
      KitchenOrderArray order = KitchenOrderArray(error: true, errorCode: '', totalSize: 0);
      _socket.on('database-data-receive', (data) {
        if (kDebugMode) {
          print('kot data socket database refresh');
        }
        //? this is not single KOT order , its list of orders
        order = KitchenOrderArray.fromJson(data);
        List<KitchenOrder> kitchenOrders = [];
        kitchenOrders.addAll(order.kitchenOrder ?? []);
        //? no error
        bool err = order.error;
        if (!err) {
          //? check if item is already in list
          _kotBillingItems.clear();
          //? adding KOT order by if is exist then not added
          _kotBillingItems.addAll(
              kitchenOrders.where((newItem) => _kotBillingItems.every((oldItem) => newItem.Kot_id != oldItem.Kot_id)));
          update();
        } else {
          return;
        }
      });
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'setUpKitchenOrderFromDbListener()');
      return;
    }
  }

  //? this emit will receive in server and emit from server to refresh data
  refreshDatabaseKot() {
    if(Get.find<StartupController>().applicationPlan == 1){
      _socket.emit('refresh-database-order',Get.find<StartupController>().SHOPE_ID);
    }
    else{
      getAllKot();
    }

  }

  //? this emit will receive server and emit from server to with kotID to ring order
  //? used when ring btn click in KOT order manage alert
  ringKot(int kotId) {
    _socket.emit('for-ring-to-kitchen', kotId);
  }

  //? get all settled order
  //? used to refresh settled order on first loading and after update or delete also
  //? to load o first screen loading
  getInitialSettledOrder() {
    try {
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedAllFoods from foodData controller
      if (_settledOrderData.allSettledOrder.isEmpty) {
        if (kDebugMode) {
          print(_settledOrderData.allSettledOrder.length);
          print('data loaded from db');
        }
        refreshSettledOrder(showSnack: false);
      } else {
        if (kDebugMode) {
          print('data loaded from food data');
        }
        //? load data from variable in todayFood
        _storedAllSettledOrder.clear();
        _storedAllSettledOrder.addAll(_settledOrderData.allSettledOrder);
        //? to show full food in UI
        _settledBillingItems.clear();
        _settledBillingItems.addAll(_storedAllSettledOrder);
      }
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'getInitialSettledOrder()');
      return;
    }
  }

  //? ad refresh fresh data from server
  refreshSettledOrder({DateTime? startDate , DateTime? endTime ,bool showSnack = true}) async {
    try {
      MyResponse response = await _settledOrderData.getAllSettledOrder(startDate: startDate,endTime: endTime);
      if(response.statusCode == 1){
        if(response.data != null){
          List<SettledOrder>  settledOrder = response.data;
          _storedAllSettledOrder.clear();
          _storedAllSettledOrder.addAll(settledOrder);
          //? to show full food in UI
          _settledBillingItems.clear();
          _settledBillingItems.addAll(_storedAllSettledOrder);
          if(showSnack) {
            AppSnackBar.successSnackBar('Success', response.message);
          }
        }
      }else{
        if(showSnack) {
          AppSnackBar.errorSnackBar('Error', response.message);
        }
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'refreshSettledOrder()');
      return;
    }finally{
      update();
    }

  }

  //? checking int is in text field
  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  //? to calculate balance and all other calculation in settledOrder alert
  //? used in settleKotBillingCash()
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
      balanceChange.value =
          double.parse((settleCashReceivedCtrl.value.text == '' ? 0 : cashReceived - grandTotalNew).toStringAsFixed(3));
      settleGrandTotalCtrl.value.text = '$grandTotalNew';
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'calculateNetTotal()');
      return;
    }
  }

  //? settle billing kot cash alert showing this method is call on click settle btn
  settleKotBillingCash(context, ctrl, index) {
    //? to enable settled and settled and print btn if its desabled
    isClickedSettle.value = false;
    indexFromKotOrder = index;
    try {
      if (indexFromKotOrder != -1) {
        billingItems.clear();
        //? billing list
        final List<OrderBill> fdOrder = [];
        //? add all order-item in KOT to fdOrder
        fdOrder.addAll(_kotBillingItems[index].fdOrder?.toList() ?? []);
        //? then adding this items to billingItem for show in invoice
        for (var element in fdOrder) {
          billingItems.add({
            'fdId': element.fdId ?? -1,
            'name': element.name ?? '',
            'qnt': element.qnt ?? 0,
            'price': (element.price ?? 0).toDouble(),
            'ktNote': element.ktNote ?? ''
          });
        }
        //? to show in invoice of settled order from KOT alert
        orderType = _kotBillingItems[index].fdOrderType ?? TAKEAWAY;
        //? to show in invoice of settled order from KOT alert
        fdDelAddress = _kotBillingItems[index].fdDelAddress ?? {'name': '', 'number': 0, 'address': ''};
        //? to show in invoice of settled order from KOT alert
        selectedOnlineApp = _kotBillingItems[index].fdOnlineApp ?? NO_ONLINE_APP;

        settleNetTotalCtrl.value.text = (_kotBillingItems[index].totalPrice ?? 0).toString();
        settleDiscountCashCtrl.value.text = '0';
        settleDiscountPercentageCtrl.value.text = '0';
        settleChargesCtrl.value.text = '0';
        settleGrandTotalCtrl.value.text = '0';
        settleCashReceivedCtrl.value.text = '';
        //? calculate total an other calculation
        calculateNetTotal();
        //? this is settle screen alert ui
        //? from is same  billing , so billing screen like  and this alert popup ui is same
        billingCashScreenAlert(context: context, ctrl: ctrl, from: 'kotAlert');
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'settleKotBillingCash()');
      return;
    }
  }

  //? insert settled to dB bill from kot
  //? this not called here , so there is many progress btn status changing
 Future<bool> insertSettledBill(BuildContext context) async {
    try {
      Map<String, dynamic> settledBill = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'fdOrder': indexFromKotOrder != -1 ? (_kotBillingItems[indexFromKotOrder].fdOrder ?? []) : [],
        'fdOrderKot': _kotBillingItems[indexFromKotOrder].Kot_id ?? -1,
        'fdOrderStatus': COMPLETE,
        'fdOrderType': _kotBillingItems[indexFromKotOrder].fdOrderType ?? TAKEAWAY,
        'fdDelAddress': _kotBillingItems[indexFromKotOrder].fdDelAddress ?? {'name': '', 'number': 0, 'address': ''},
        'fdOnlineApp': _kotBillingItems[indexFromKotOrder].fdOnlineApp ?? NO_ONLINE_APP,
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
        return false;
      } else {
        btnControllerSettle.success();
        //? to disable settled and settled and settled&print btn
        isClickedSettle.value = true;
        AppSnackBar.successSnackBar('Success', parsedResponse.errorCode ?? 'Error');
        return true;
      }
    } on DioError catch (e) {
      btnControllerSettle.error();
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'insertSettledBill()');
      return false;
    } catch (e) {
      btnControllerSettle.error();
      return false;
    } finally {
      await Future.delayed(const Duration(seconds: 1), () {
        btnControllerSettle.reset();
      });
      await Future.delayed(const Duration(milliseconds: 300), () {
        //? for refresh kot bill , so after settle it will delete from kot bill from dB
        refreshDatabaseKot();
        //? refreshing settled order after settling KOT order
        refreshSettledOrder();
        Navigator.pop(context);
      });
    }
  }

  //? to delete/cancel settled order
  deleteSettledOrder(int? settledId) async {
    try {
      showLoading();
      MyResponse response = await _settledOrderRepo.deleteSettledOrder(settledId);

      if (response.statusCode == 1 ) {
        //? refreshing after delete settled order
        refreshSettledOrder(startDate: selectedDateRangeForSettledOrder.start,endTime: selectedDateRangeForSettledOrder.end);
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
      }
    }  catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'deleteSettledOrder()');
      return;
    } finally {
      hideLoading();
      update();
    }
  }

  //? update settled bill from settled bill list
  //? this will call when click update settled bill click on settled bill card (on long press)
  updateSettleBillingCash(context, ctrl, index) {
    indexSettledOrder = index;
    try {
      if (indexSettledOrder != -1) {
        //? setting payment type from db so payment is already settled , don't show default
        selectedPaymentForUpdateSettledOrder = _settledBillingItems[index].paymentType ?? CASH;
        update();
        settleNetTotalCtrl.value.text = (_settledBillingItems[index].netAmount ?? 0).toString();
        settleDiscountCashCtrl.value.text = (_settledBillingItems[index].discountCash ?? 0).toString();
        settleDiscountPercentageCtrl.value.text = (_settledBillingItems[index].discountPersent ?? 0).toString();
        settleChargesCtrl.value.text = (_settledBillingItems[index].charges ?? 0).toString();
        settleGrandTotalCtrl.value.text = (_settledBillingItems[index].grandTotal ?? 0).toString();
        settleCashReceivedCtrl.value.text = (_settledBillingItems[index].cashReceived ?? 0).toString();
        // ? calculate total an other calculation
        calculateNetTotal();
        //? this is settle screen alert ui
        //? from is 'updateSettle' , so in alert method from other than 'billing' then it will go to OrderUpdateSettleScreen()
        billingCashScreenAlert(context: context, ctrl: ctrl, from: 'updateSettle');
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'updateSettleBillingCash()');
      return;
    }
  }

  //?  update settle bill from settled bill list in dB
  updateSettledBill(context) async {
    try {
      Map<String, dynamic> updatedSettledBill = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'settled_id': _settledBillingItems[indexSettledOrder].settled_id ?? -1,
        'netAmount': netTotal,
        'discountPersent': discountPresent,
        'discountCash': discountCash,
        'charges': charges,
        'grandTotal': grandTotalNew,
        'paymentType': selectedPaymentForUpdateSettledOrder,
        'cashReceived': cashReceived,
        'change': balanceChange.value
      };

      final response = await _httpService.updateData(UPDATE_SETTLED_ORDER, updatedSettledBill);

      FoodResponse parsedResponse = FoodResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        btnControllerSettle.error();
        AppSnackBar.errorSnackBar('Error', parsedResponse.errorCode ?? 'Error');
      } else {
        btnControllerSettle.success();
        //? for refresh settled bill ,
        refreshSettledOrder();
        AppSnackBar.successSnackBar('Success', parsedResponse.errorCode ?? 'Error');
      }
    } on DioError catch (e) {
      btnControllerSettle.error();
      AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
    } catch (e) {
      btnControllerSettle.error();
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'updateSettledBill()');
      return;
    } finally {
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerSettle.reset();
        Navigator.pop(context);
      });
    }
  }

  //? get all hold order
  getAllHoldOrder() async {
    try {
      _holdBillingItems.clear();
      _holdBillingItems.addAll(_hiveHoldBillController.getHoldBill());
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'getAllHoldOrder()');
      return;
    }
    update();
  }

  //? unHold holdItem sending data to billing screen to un hold
  unHoldHoldItem({required holdBillingItems, required int holdItemIndex, required String orderType}) async {
    try {
      switch (orderType) {
            case TAKEAWAY:
              {
                Get.offNamed(RouteHelper.getBillingScreenScreen(), arguments: {'holdItem': holdBillingItems});
              }
              break;

            case HOME_DELEVERY:
              {
                Get.offNamed(RouteHelper.getBillingScreenScreen(), arguments: {'holdItem': holdBillingItems});
              }
              break;

            case ONLINE:
              {
                Get.offNamed(RouteHelper.getBillingScreenScreen(), arguments: {'holdItem': holdBillingItems});
              }
              break;

            case DINING:
              {
                Get.offNamed(RouteHelper.getBillingScreenScreen(), arguments: {'holdItem': holdBillingItems});
              }
              break;

            default:
              {
                Get.offNamed(RouteHelper.getBillingScreenScreen(), arguments: {'holdItem': holdBillingItems});
              }
              break;
          }

      //? delete the hold item from hold item list
      await _hiveHoldBillController.deleteHoldBill(index: holdItemIndex);
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'unHoldHoldItem()');
      return;
    }
  }

  //? edit kot order or update kot order navigate to billing screen

  updateKotOrder({required kotBillingOrder}) {
    Get.offNamed(RouteHelper.getBillingScreenScreen(), arguments: {'kotItem': kotBillingOrder});
  }

  //? to delete / cancel kot order
  deleteKotOrder(int kotId) async {
    try {
      if (kotId != -1) {
        Map<String, dynamic> data = {
          'fdShopId': Get.find<StartupController>().SHOPE_ID,
          'Kot_id': kotId,
        };
        final response = await _httpService.delete(DELETE_KOT_ORDER, data);
        FoodResponse parsedResponse = FoodResponse.fromJson(response.data);
        if (parsedResponse.error ?? true) {
          btnControllerCancellKOtOrder.error();
          AppSnackBar.errorSnackBar('Error', parsedResponse.errorCode ?? 'Error');
        } else {
          btnControllerCancellKOtOrder.success();
          AppSnackBar.successSnackBar('Success', parsedResponse.errorCode ?? 'Error');
        }
      }
    } on DioError catch (e) {
      btnControllerCancellKOtOrder.error();
      AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
    } catch (e) {
      btnControllerCancellKOtOrder.error();
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'deleteKotOrder()');
      return;
    } finally {
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerCancellKOtOrder.reset();
      });
      update();
    }
  }

  //? kot printing dialog
  //? billing item and kotId get from tapping in kot order list from order view
  //! need to configure table name
  kotDialogBox(context, billingItems, kotId, KitchenOrder fullKot) {
    if (kotId != -1) {
      showKotBillAlert(
        type: 'ORDER_VIEW',
        billingItems: billingItems,
        context: context,
        kotId: kotId,
        tableName: 'T1-C4',
        fullKot: fullKot,
      );
    }
  }

  //? to update selected table like KOT,SETTLED,HOLD
  updateTappedTabName(String name) {
    if (kDebugMode) {
      print(name);
    }
    tappedTabName = name;
    update();
  }

  setStatusTappedIndex(int val) {
    tappedIndex = val;
    update();
  }

  //? this for payment dropdown for settled bill from KOT alert
  updateSelectedPayment(String selectedPaymentFromDrop) {
    selectedPayment = selectedPaymentFromDrop;
    update();
  }

  //? this for payment dropdown for update settled bill
  updateSelectedPaymentForUpdateSettledOrder(String selectedPaymentFromDrop) {
    selectedPaymentForUpdateSettledOrder = selectedPaymentFromDrop;
    update();
  }

  Future<void> ringAlert() async {
    try {
      if (kDebugMode) {
            print('ring sound');
          }
      await player.setSource(AssetSource('sounds/ring_two.mp3'));
      await player.resume();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'ringAlert()');
      return;
    }
  }



  //? to show date picker to sort settled order
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
           refreshSettledOrder(startDate: dateRange.start,endTime: dateRange.end);
         }
   } catch (e) {
     String myMessage = showErr ? e.toString() : 'Something wrong !!';
     AppSnackBar.errorSnackBar('Error', myMessage);
     errHandler.myResponseHandler(error: e.toString(),pageName: 'order_view_controller',methodName: 'datePickerForSettledOrder()');
     return;
   }
   finally{
     update();
   }
  }

  initTxtController() {
    //? to search the food in billing screen
    settleNetTotalCtrl = TextEditingController().obs;
    settleDiscountCashCtrl = TextEditingController().obs;
    settleDiscountPercentageCtrl = TextEditingController().obs;
    settleChargesCtrl = TextEditingController().obs;
    settleGrandTotalCtrl = TextEditingController().obs;
    settleCashReceivedCtrl = TextEditingController().obs;
  }

  //? dispose all txtControllers
  disposeTxtController() {
    settleNetTotalCtrl.value.dispose();
    settleDiscountCashCtrl.value.dispose();
    settleDiscountPercentageCtrl.value.dispose();
    settleChargesCtrl.value.dispose();
    settleGrandTotalCtrl.value.dispose();
    settleCashReceivedCtrl.value.dispose();
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
