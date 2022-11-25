import 'dart:io';
import 'dart:ui';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'library/androidPrint.dart';
import 'library/androidPrintenum.dart';
import 'library/iosWinPrint.dart';
import 'library/print_responce.dart';
import 'package:image/image.dart' as im;

import 'library/screenshort_widgets.dart';

class PrintCTRL extends GetxController {
  //? billing list
  final List<dynamic> billingItems = [
    {'fdId': 10, 'name': 'food 1', 'qnt': 1, 'price': 100, 'ktNote': 'make spicy', 'ordStatus': 'pending'},
    {'fdId': 11, 'name': 'food 2', 'qnt': 3, 'price': 200, 'ktNote': 'make spicy', 'ordStatus': 'pending'},
    {'fdId': 10, 'name': 'food 1', 'qnt': 1, 'price': 100, 'ktNote': '', 'ordStatus': 'pending'},
  ];

  ScreenshotController screenshotController = ScreenshotController();

  IosWinPrint iOSWinPrintInstance = IosWinPrint();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Widget _androidBillTemplate() {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SizedBox(
          width: 144,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScreenShortWidget.tableRow(items: ['Name'  ,'Rate','Qty','Status'],flex:[6,2,2,3],isBold: true),
              const Divider(thickness: 2,color: Colors.black),
              ScreenShortWidget.tableRow(items: ['Alfaham Periperi Full with porotta'  ,'240','1','pending'],flex:[6,2,1,3]),
              ScreenShortWidget.tableRow(items: ['Alfaham Periperi Full with porotta'  ,'240','1','pending'],flex:[6,2,1,3]),
              ScreenShortWidget.tableRow(items: ['Alfaham Periperi Full with porotta'  ,'240','1','pending'],flex:[6,2,1,3]),
              const Divider(thickness: 1,color: Colors.black),
              ScreenShortWidget.tableRow(items: ['Total : '  ,'Rs: 1520    '],isBold: true),
            ],
          ),
        ),
      ),
    );
  }

  printKot({required List<dynamic> order, required String orderType, required String orderStatus}) async {
    if (Platform.isAndroid) {
      PrintResponse readyForPrint = await AndroidPrint().isReadyForPrint();
      if (readyForPrint.status == true) {
        AndroidPrint.bluetoothInstance.printCustom("AndroidPrint", 1, PAlign.center.val);
        AndroidPrint.bluetoothInstance.printCustom("================", 1, PAlign.center.val);
        await _testPrintForAndroid();
        AndroidPrint.bluetoothInstance.printNewLine();
        AndroidPrint.bluetoothInstance.printCustom("----------------", 1, PAlign.center.val);
        AndroidPrint.bluetoothInstance.printCustom("Thank You", 1, PAlign.center.val);
        AndroidPrint.bluetoothInstance.printCustom("----------------", 1, PAlign.center.val);
        AndroidPrint.bluetoothInstance.printNewLine();
      } else {
        print(readyForPrint.message);
      }
    } else if (Platform.isWindows || Platform.isIOS) {
      await iOSWinPrintInstance.getDevices();
      _testPrintForIosWin();
    }
    //? code for printing
  }

  Future _testPrintForAndroid() async {
    List<Uint8List> imgList = [];
    Uint8List imageInt = await screenshotController.captureFromWidget(_androidBillTemplate(),delay: Duration.zero);
    im.Image? receiptImg = im.decodePng(imageInt);

    for (var i = 0; i <= receiptImg!.height; i += 200) {
      im.Image cropedReceiptImg = im.copyCrop(receiptImg, 0, i, 470, 200);
      Uint8List bytes = im.encodePng(cropedReceiptImg) as Uint8List;
      imgList.add(bytes);
    }

    for (var element in imgList) {
      AndroidPrint.bluetoothInstance.printImageBytes(element);
    }
  }


  Future _testPrintForIosWin() async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text('Windows Print',
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          width: PosTextSize.size2,
          height: PosTextSize.size1,
        ));
    bytes += generator.text('================================', styles: PosStyles(align: PosAlign.center));
    bytes += generator.row([
      PosColumn(
        text: 'Name',
        width: 5,
        styles: PosStyles(bold: true, align: PosAlign.left),
      ),
      PosColumn(
        text: 'Price',
        width: 3,
        styles: PosStyles(bold: true, align: PosAlign.center),
      ),
      PosColumn(
        text: 'Qty',
        width: 1,
        styles: PosStyles(bold: true, align: PosAlign.center),
      ),
      PosColumn(
        text: 'Status',
        width: 3,
        styles: PosStyles(bold: true, align: PosAlign.right),
      ),
    ]);
    bytes += generator.text('--------------------------------', styles: PosStyles(align: PosAlign.center));
    bytes += generator.row([
      PosColumn(
        text: 'Al-Faham full with',
        width: 6,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: '250',
        width: 2,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '2',
        width: 1,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: 'Pending',
        width: 3,
        styles: PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Kuzhi Manthi Quater',
        width: 6,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: '250',
        width: 2,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '2',
        width: 1,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: 'Pending',
        width: 3,
        styles: PosStyles(align: PosAlign.right),
      ),
    ]);

    PrintResponse test = await iOSWinPrintInstance.printEscPos(bytes, generator);
    if (test.status) {
      print('sucees');
    } else {
      print(test.message);
    }
  }

  printInVoice({required List<dynamic> order, required double grandTotel, required double balans}) {
    //? code for printing
  }
}
