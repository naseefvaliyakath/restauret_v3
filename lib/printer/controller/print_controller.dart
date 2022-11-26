import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/widget/common_widget/snack_bar.dart';
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

  printKot({required List<dynamic> order, required String orderType, required String orderStatus}) async {
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

  printInVoice({required List<dynamic> order, required double grandTotel, required double balans}) {
    //? code for printing
  }
}
