import 'dart:async';
import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/printer/controller/library/print_responce.dart';
import 'package:rest_verision_3/printer/controller/library/printer_config.dart';

import '../../../error_handler/error_handler.dart';

class IosWinPrint {
  final ErrorHandler errHandler = Get.find<ErrorHandler>();

  IosWinPrint(){
    try {
      if (Platform.isWindows){
            defaultPrinterType = PrinterType.usb;
          }else{
            defaultPrinterType = PrinterType.bluetooth;
          }

      _subscriptionBtStatus = PrinterManager.instance.stateBluetooth.listen((status) {
            _currentStatus = status;
            if (status == BTStatus.connected) {
              // _isConnected = true;
            }
            if (status == BTStatus.none) {
              // _isConnected = false;
            }
          });
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'iosWinPrint',methodName: 'IosWinPrint()');
      return;
    }
  }

  var printerManager = PrinterManager.instance;
  late PrinterType defaultPrinterType;

  StreamSubscription<PrinterDevice>? _subscriptionPrinterDevice;
  StreamSubscription<BTStatus>? _subscriptionBtStatus;


  //Not tested with low energy devices
  var isBle = false;
  //Not tested _reconnect = true
  var reconnect = false;
  // var _isConnected = false;
  BTStatus _currentStatus = BTStatus.none;
  List<int>? pendingTask;

  static BluetoothPrinter? _selectedDevice;

  Future<List<BluetoothPrinter>> getDevices() async {
    try {
      var devices = <BluetoothPrinter>[];

      _subscriptionPrinterDevice = printerManager.discovery(type: defaultPrinterType, isBle: isBle).listen((device) {

            //Select device automatically if no device selected
            if(_selectedDevice==null){
              if(Platform.isWindows){
                if (PrinterConfig.allowedUsbPrinter.contains(device.name)) {
                  selectDevice(BluetoothPrinter(
                    deviceName: device.name,
                    address: device.address,
                    isBle: isBle,
                    vendorId: device.vendorId,
                    productId: device.productId,
                    typePrinter: defaultPrinterType,
                  ));
                }
              }else{
                if (PrinterConfig.allowedBtPrinter.contains(device.name)) {
                  selectDevice(BluetoothPrinter(
                    deviceName: device.name,
                    address: device.address,
                    isBle: isBle,
                    vendorId: device.vendorId,
                    productId: device.productId,
                    typePrinter: defaultPrinterType,
                  ));
                }
              }
            }

            // print(device.name);
            // print(device.address);
            // print(device.operatingSystem);
            // print(device.productId);
            // print(device.vendorId);
            devices.add(BluetoothPrinter(
              deviceName: device.name,
              address: device.address,
              isBle: isBle,
              vendorId: device.vendorId,
              productId: device.productId,
              typePrinter: defaultPrinterType,
            ));
          });
      await Future.delayed(const Duration(milliseconds: 200));
      return devices;
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'iosWinPrint',methodName: 'getDevices()');
      return [];
    }
  }

  Future<BluetoothPrinter?> selectDevice(BluetoothPrinter? device) async {
    //set as null for automatic selection
    try {
      if (_selectedDevice != null && device!=null) {
            if ((device.address != _selectedDevice!.address) || (device.typePrinter == PrinterType.usb && _selectedDevice!.vendorId != device.vendorId)) {
              await PrinterManager.instance.disconnect(type: _selectedDevice!.typePrinter);
            }
          }
      _selectedDevice = device;
      return _selectedDevice;
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'iosWinPrint',methodName: 'selectDevice()');
      return _selectedDevice;
    }
  }

  static BluetoothPrinter? getSelectedDevice(){
    return _selectedDevice;
  }

  Future<void> connectBtPrinter({required BluetoothPrinter bluetoothPrinter}) async {
    //This fn only used in app start
    try {
      await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: BluetoothPrinterInput(
              name: bluetoothPrinter.deviceName,
              address: bluetoothPrinter.address!,
              isBle: bluetoothPrinter.isBle ?? false,
              autoConnect: reconnect,
            ),
          );
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'iosWinPrint',methodName: 'connectBtPrinter()');
      return;
    }
  }

  Future<PrintResponse> printEscPos(List<int> bytes, Generator generator) async {

    try {
      if (_selectedDevice == null) {
            //TODO alert user
            return PrintResponse(status: false,message: "No printer selected");
          }

      var bluetoothPrinter = _selectedDevice!;
      bool? flag;

      switch (bluetoothPrinter.typePrinter) {
            case PrinterType.usb:
              bytes += generator.feed(2);
              bytes += generator.cut();
              flag = await printerManager.connect(
                  type: bluetoothPrinter.typePrinter,
                  model: UsbPrinterInput(
                    name: bluetoothPrinter.deviceName,
                    productId: bluetoothPrinter.productId,
                    vendorId: bluetoothPrinter.vendorId,
                  )
              );
              pendingTask = null;
              break;
            case PrinterType.bluetooth:
              bytes += generator.cut();
              flag = await printerManager.connect(
                type: bluetoothPrinter.typePrinter,
                model: BluetoothPrinterInput(
                  name: bluetoothPrinter.deviceName,
                  address: bluetoothPrinter.address!,
                  isBle: bluetoothPrinter.isBle ?? false,
                  autoConnect: reconnect,
                ),
              );
              pendingTask = null;
              if (Platform.isAndroid) pendingTask = bytes;
              break;
            default:
          }

      if(flag==false && Platform.isAndroid){
            return PrintResponse(status: false,message: "Could not connect");
          }

      if(Platform.isIOS){
            await Future.delayed(const Duration(milliseconds: 500));
          }

      if (bluetoothPrinter.typePrinter == PrinterType.bluetooth && Platform.isAndroid) {
            if (flag==true) {
              printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
              pendingTask = null;
              return PrintResponse(status: true,message: "print success");
            }else{
              return PrintResponse(status: false,message: "Bt not connected");
            }
          } else {
            printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
            return PrintResponse(status: true,message: "print success on IOS | Windows");
          }
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'iosWinPrint',methodName: 'printEscPos()');
      return PrintResponse(status: false,message: e.toString());
    }

  }



  void closeSubscription(){
    _subscriptionPrinterDevice?.cancel();
    _subscriptionBtStatus?.cancel();
  }

  _disconnect(){
    if (_selectedDevice != null) printerManager.disconnect(type: _selectedDevice!.typePrinter);
  }
}

class BluetoothPrinter {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;

  PrinterType typePrinter;
  bool? state;

  BluetoothPrinter(
      {this.deviceName, this.address, this.port, this.state, this.vendorId, this.productId, this.typePrinter = PrinterType.bluetooth, this.isBle = false});
}
