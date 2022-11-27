import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/login_screen/controller/startup_controller.dart';
import 'package:rest_verision_3/widget/common_widget/snack_bar.dart';
import '../../constants/strings/my_strings.dart';
import '../../models/kitchen_order_response/kitchen_order.dart';
import '../../screens/billing_screen/controller/billing_screen_controller.dart';
import 'library/iosWinPrint.dart';
import 'library/iosWinPrintMethods.dart';
import 'library/print_responce.dart';

class PrintCTRL extends GetxController {
  //? billing list
  final List<dynamic> billingItems = [
    {'fdId': 10, 'name': 'food 1', 'qnt': 1, 'price': 100, 'ktNote': 'make spicy', 'ordStatus': 'pending'},
    {'fdId': 11, 'name': 'food 2', 'qnt': 3, 'price': 200, 'ktNote': 'make spicy', 'ordStatus': 'pending'},
    {'fdId': 10, 'name': 'food 1', 'qnt': 1, 'price': 100, 'ktNote': '', 'ordStatus': 'pending'},
  ];

  IosWinPrint iOSWinPrintInstance = IosWinPrint();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  printKotTest({required List<dynamic> order, required String orderType, required String orderStatus}) async {
    if (Platform.isAndroid || Platform.isWindows || Platform.isIOS) {
      if (IosWinPrint.getSelectedDevice() == null) {
        await iOSWinPrintInstance.getDevices();
      }
      _testPrintForIosWin();
    }
  }

  Future _testPrintForIosWin() async {
    List<int> bytes = [];
    final generator = await IosWinPrintMethods.getGenerator();
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text('Print Test',
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          width: PosTextSize.size2,
          height: PosTextSize.size1,
        ));
    bytes += generator.text('================================', styles: const PosStyles(align: PosAlign.center));

    bytes += IosWinPrintMethods.printRows(
      width: [5, 3, 1, 3],
      bold: true,
      columns: [
        ['Name', 'Price', 'Qty', 'Status']
      ],
      generator: generator,
    );

    bytes += generator.text('--------------------------------', styles: const PosStyles(align: PosAlign.center));
    bytes += IosWinPrintMethods.printRows(
      width: [6, 2, 1, 3],
      columns: [
        ['Al-Faham fullwith and thirsd line printed stestn complete', '250', '1', 'Pending'],
        ['Kuzhi Manthi Quater', '310', '2', 'Pending'],
        ['Al-Faham full with', '250', '1', 'Pending'],
        ['Chilli Chicken Half', '1100', '10', 'Pending'],
      ],
      generator: generator,
    );
    bytes += generator.text('--------------------------------', styles: const PosStyles(align: PosAlign.center));
    bytes += IosWinPrintMethods.printRows(
      width: [6, 6],
      bold: true,
      columns: [
        ['Sub-Total:', 'Rs: 3000'],
        ['Discount:', 'Rs: 500'],
        ['Total:', 'Rs: 2501'],
      ],
      generator: generator,
    );
    bytes += generator.text('________________________________', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(
      'Thank You',
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
      ),
    );
    bytes += generator.text('________________________________', styles: const PosStyles(align: PosAlign.center));
    // bytes += generator.text('********************************', styles: const PosStyles(align: PosAlign.center));

    PrintResponse printerResponse = await iOSWinPrintInstance.printEscPos(bytes, generator);
    if (printerResponse.status) {
    } else {
      AppSnackBar.myFlutterToast(message: printerResponse.message, bgColor: Colors.red);
    }
  }

  printInVoice({  required List<dynamic> billingItems,
    required String orderType,
    required String selectedOnlineApp,
    required Map<String,dynamic> deliveryAddress,
    required num grandTotal,
    required num change,
    required num cashReceived,
    required num netAmount,
    required num discountCash,
    required num discountPercent,
    required num charges,}) {

    print('invoice print fun called');

    //? (1)  'INVOICE'  heading

/*    (2) hotel name , phone numb
    Get.find<StartupController>().shopName ?? '';
    Get.find<StartupController>().shopNumber ?? '';*/

/*    (3) 'DATE : ${DateFormat('dd-MM-yyyy  hh:mm aa').format(DateTime.now())}'*/


/*    (4)  orderType == ONLINE ? 'TYPE : ${orderType.toUpperCase()}  ($selectedOnlineApp)' :'TYPE : ${orderType.toUpperCase()}'*/


/* (5)  horizondal divider*/

/*    (6) bill section

  billingItems[index]['name'] ?? ''
  billingItems[index]['qnt'] ?? 0
  billingItems[index]['price'] ?? 0
  billingItems[index]['ktNote'] ?? ''
  billingItems.length
  */

/*    (7)    'Bill Amount      : $netAmount'
        'Charges             : $charges'
        'Discount           : $discountCash'  //only show if discountCash != 0
         'Discount in %  : $discountPercent'  //only show if discountPercent !=0
            'Final Amount    : $grandTotal'
            'Cash Received  : $cashReceived'
            'Change               : $change'*/


/*  home delivery address section

  //? check if its from home delivery and user entered an address and in general setting user selected show delivery address in invoice
    ((Get.find<StartupController>().setShowDeliveryAddressInBillToggle) && (orderType == HOME_DELEVERY) && (deliveryAddress['name']?.trim() != '')) ? true : false,

    //? only above condition is ok then only delivery address need to show

    *//*   Delivery address    *//*
    'Name                   :  ${deliveryAddress['name'] ?? 'name'}'
    'Phone number  :  ${deliveryAddress['number'].toString()}'
    'Address               :  deliveryAddress['address'] ?? 'address''


  */




  }

  printKot({
    required List<dynamic> kotList,
    required String type,
    //? this kotId only get from order view
    //? from billing page its -1 so kot not send to server in billing page
    int kotId = -1,
    //? this tableName is get from billing screen if its dining , els its ''
    String tableName = '',
    //? full KOT will get only from orderView page so its needed for take delivery address and order type of already sent KOT
    required KitchenOrder fullKot,
  }) {
    print('printer fun called');
    //? registering controller if kot is from billing screen
    if (type != 'ORDER_VIEW') {
      if (Get.isRegistered<BillingScreenController>()) {
        Get.lazyPut<BillingScreenController>(() => BillingScreenController());
      }
    }
    //? (1)  ...    'KOT'    ....\\?
   //?  (2) ...   'KOT ID : $kotId   ..\\\
    //? (3)  .....    'DATE : ${DateFormat('dd-MM-yyyy  hh:mm aa').format((fullKot.kotTime) ?? DateTime.now())}',    ...\\\\

    //? (4) .... horizontal divider ....\\


/*   (5)   type != 'ORDER_VIEW'
        ? 'TYPE : $type  ${type == ONLINE ? '(${Get.find<BillingScreenController>().selectedOnlineApp})' : ''}'
    //? to show order type and in online  show like 'online (Thalabath)' and -
    //?  its from order view page need to take details from kotOrder model
        : 'TYPE : ${fullKot.fdOrderType}  ${fullKot.fdOrderType == ONLINE ? '(${fullKot.fdOnlineApp})' : ''}'*/


/*  (6)  type == DINING
        ? Get.find<BillingScreenController>().selectedTableChairSet[1] == -1 ? 'TABLE : NOT SELECTED':
    'TABLE : T-${Get.find<BillingScreenController>().selectedTableChairSet[1]} C-${Get.find<BillingScreenController>().selectedTableChairSet[2]}  (${(Get.find<BillingScreenController>().selectedTableChairSet[0]).toString().toUpperCase()})'
        : type == 'ORDER_VIEW'
        ? 'TABLE :T-${fullKot.kotTableChairSet?[1] ?? 1} C-${fullKot.kotTableChairSet?[2] ?? 1}  (${(fullKot.kotTableChairSet?[0] ?? MAIN_ROOM).toString().toUpperCase()})' : 'TABLE : '*/


  //? (7)  horizontal divider ////

/*     (8)  bill list section

    billingItems[index]['name'] ?? ''
    //kitchen note food name nte thaze kanikkanam cherthayitt , look in kot alert
    billingItems[index]['ktNote'] ?? ''
    billingItems[index]['qnt'] ?? 0
    billingItems.length

    */

  }
}
