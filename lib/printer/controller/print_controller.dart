import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rest_verision_3/screens/login_screen/controller/startup_controller.dart';
import 'package:rest_verision_3/widget/common_widget/snack_bar.dart';
import '../../constants/strings/my_strings.dart';
import '../../models/kitchen_order_response/kitchen_order.dart';
import '../../screens/billing_screen/controller/billing_screen_controller.dart';
import 'library/iosWinPrint.dart';
import 'library/iosWinPrintMethods.dart';
import 'library/print_responce.dart';

class PrintCTRL extends GetxController {


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

  printInVoice({
    required List<dynamic> billingItems,
    required String orderType,
    required String selectedOnlineApp,
    required Map<String, dynamic> deliveryAddress,
    required num grandTotal,
    required num change,
    required num cashReceived,
    required num netAmount,
    required num discountCash,
    required num discountPercent,
    required num charges,
  }) async {
    List<int> bytes = [];
    final generator = await IosWinPrintMethods.getGenerator();
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += IosWinPrintMethods.printHeading(generator: generator, heading: Get.find<StartupController>().shopName);

    bytes += IosWinPrintMethods.printRows(
      width: [1, 9, 2],
      columns: [
        ['', 'Phone : ${(Get.find<StartupController>().shopNumber).toString()}', '  '],
        ['', 'INVOICE', '  '],
      ],
      generator: generator,
    );

    bytes += generator.text('================================', styles: const PosStyles(align: PosAlign.center));

    bytes += IosWinPrintMethods.printRows(
      width: [4, 8],
      columns: [
        ['DATE : ', (DateFormat('dd-MM-yyyy  hh:mm aa').format(DateTime.now()))],
        ['TYPE : ', orderType == ONLINE ? '${orderType.toUpperCase()}  ($selectedOnlineApp)' : '${orderType.toUpperCase()}    '],
      ],
      generator: generator,
    );

    bytes += generator.text('--------------------------------', styles: const PosStyles(align: PosAlign.center));

    // bill section
    bytes += IosWinPrintMethods.printRows(
      width: [5, 7],
      bold: true,
      columns: [
        ['Name', 'Qty' ' Price' ' Total']
      ],
      generator: generator,
    );

    bytes += IosWinPrintMethods.printRows(
      width: [6, 2, 2, 2],
      lineCutLength: 13,
      columns: billingItems.map((e) {
        return <String>[
          "${e['name'] ?? ''}",
          "${e['qnt']}",
          "${e['price']}",
          "${e['price'] * e['qnt']}",
        ];
      }).toList(),
      generator: generator,
    );

    bytes += generator.text('--------------------------------', styles: const PosStyles(align: PosAlign.center));

    bytes += IosWinPrintMethods.printRows(
      width: [6, 6],
      bold: true,
      columns: [
        ['Bill Amount:', '$netAmount'],
        ['Charges:', '$charges'],
        if (discountCash != 0) ['Discount:', '$discountCash'],
        if (discountPercent != 0) ['Discount in % :', '$discountPercent'],
        ['Final Amount:', '$grandTotal'],
        ['Cash Received:', '$cashReceived'],
        ['Change:', ' $change'],
      ],
      generator: generator,
    );

    // home delivery address section

    // check if its from home delivery and user entered an address and in general setting user selected show delivery address in invoice
    if (((Get.find<StartupController>().setShowDeliveryAddressInBillToggle) && (orderType == HOME_DELEVERY) && (deliveryAddress['name']?.trim() != ''))
        ? true
        : false) {
      bytes += generator.text('--------------------------------', styles: const PosStyles(align: PosAlign.center));

      bytes += IosWinPrintMethods.printRows(
        width: [4, 8],
        columns: [
          ['Name:', '${deliveryAddress['name'] ?? ''}'],
          ['Phone :', (deliveryAddress['number'].toString())],
          ['Address :', ' '],
        ],
        generator: generator,
      );
      bytes += IosWinPrintMethods.printRows(
        width: [11, 1],
        columns: [
          ['${deliveryAddress['address'] ?? ''}', ' ']
        ],
        generator: generator,
      );
    }

    bytes += generator.text('--------------------------------', styles: const PosStyles(align: PosAlign.center));

    bytes += IosWinPrintMethods.printHeading(generator: generator, heading: 'Thank You', bold: false);

    if (IosWinPrint.getSelectedDevice() == null) {
      await iOSWinPrintInstance.getDevices();
    }
    PrintResponse printerResponse = await iOSWinPrintInstance.printEscPos(bytes, generator);
    if (printerResponse.status) {
    } else {
      if (!Platform.isWindows) {
        AppSnackBar.myFlutterToast(message: printerResponse.message, bgColor: Colors.red);
      } else {
        print(printerResponse.message);
      }
    }
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
  }) async {
    print('printer fun called');
    //? registering controller if kot is from billing screen
    if (type != 'ORDER_VIEW') {
      if (Get.isRegistered<BillingScreenController>()) {
        Get.lazyPut<BillingScreenController>(() => BillingScreenController());
      }
    }

    List<int> bytes = [];
    final generator = await IosWinPrintMethods.getGenerator();
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += IosWinPrintMethods.printHeading(generator: generator, heading: 'KOT');
    bytes += generator.text('--------------------------------', styles: const PosStyles(align: PosAlign.center));

    bytes += IosWinPrintMethods.printRows(
      width: [4, 8],
      columns: [
        ['KOT ID : ', ' $kotId'],
        [' DATE : ', (DateFormat('dd-MM-yyyy  hh:mm aa').format((fullKot.kotTime) ?? DateTime.now()))],
        [
          'TYPE : ',
          type != 'ORDER_VIEW'
              ? '$type  ${type == ONLINE ? '(${Get.find<BillingScreenController>().selectedOnlineApp})' : ''}'
              : '${fullKot.fdOrderType}  ${fullKot.fdOrderType == ONLINE ? '(${fullKot.fdOnlineApp})' : ''}'
        ],
        [
          'TABLE : ',
          type == DINING
              ? Get.find<BillingScreenController>().selectedTableChairSet[1] == -1
              ? 'NOT SELECTED'
              : 'T-${Get.find<BillingScreenController>().selectedTableChairSet[1]} C-${Get.find<BillingScreenController>().selectedTableChairSet[2]}  (${(Get.find<BillingScreenController>().selectedTableChairSet[0]).toString().toUpperCase()})'
              : type == 'ORDER_VIEW'
              ? 'T-${fullKot.kotTableChairSet?[1] ?? 1} C-${fullKot.kotTableChairSet?[2] ?? 1}  (${(fullKot.kotTableChairSet?[0] ?? MAIN_ROOM).toString().toUpperCase()})'
              : ' '
        ],
      ],
      generator: generator,
    );

    bytes += generator.text('--------------------------------', styles: const PosStyles(align: PosAlign.center));

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

/*     (8)  bill list section

    billingItems[index]['name'] ?? ''
    //kitchen note food name nte thaze kanikkanam cherthayitt , look in kot alert
    billingItems[index]['ktNote'] ?? ''
    billingItems[index]['qnt'] ?? 0
    billingItems.length

    */

    // bill section
    bytes += IosWinPrintMethods.printRows(
      width: [6, 6],
      bold: true,
      columns: [
        ['Name', 'Quantity']
      ],
      generator: generator,
    );

    bytes += IosWinPrintMethods.printRows(
      width: [10, 2],
      lineCutLength: 31,
      columns: kotList.map((e) {
        return <String>[
    e['ktNote'] == '' ? "${e['name'] ?? ''}" :
          "${e['name'] ?? ''}\nNote: ${e['ktNote'] ?? ''}",
          "${e['qnt']}",
        ];
      }).toList(),
      generator: generator,
    );
    bytes += generator.text('--------------------------------', styles: const PosStyles(align: PosAlign.center));

    if (IosWinPrint.getSelectedDevice() == null) {
      await iOSWinPrintInstance.getDevices();
    }
    PrintResponse printerResponse = await iOSWinPrintInstance.printEscPos(bytes, generator);
    if (printerResponse.status) {
    } else {
      if (!Platform.isWindows) {
        AppSnackBar.myFlutterToast(message: printerResponse.message, bgColor: Colors.red);
      } else {
        print(printerResponse.message);
      }
    }
  }


// //?to remove error
//   printKot({
//     required List<dynamic> kotList,
//     required String type,
//     //? this kotId only get from order view
//     //? from billing page its -1 so kot not send to server in billing page
//     int kotId = -1,
//     //? this tableName is get from billing screen if its dining , els its ''
//     String tableName = '',
//     //? full KOT will get only from orderView page so its needed for take delivery address and order type of already sent KOT
//     required KitchenOrder fullKot,
//   }) async {}
//
//
//   //?to remove error
//   printInVoice({
//     required List<dynamic> billingItems,
//     required String orderType,
//     required String selectedOnlineApp,
//     required Map<String, dynamic> deliveryAddress,
//     required num grandTotal,
//     required num change,
//     required num cashReceived,
//     required num netAmount,
//     required num discountCash,
//     required num discountPercent,
//     required num charges,
//   }) async {}


}