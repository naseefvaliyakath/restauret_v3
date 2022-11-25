import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rest_verision_3/printer/controller/library/print_responce.dart';
import 'package:rest_verision_3/printer/controller/library/printer_config.dart';


class AndroidPrint {
  static final AndroidPrint _singleton = AndroidPrint._internal();
  factory AndroidPrint() {
    return _singleton;
  }
  AndroidPrint._internal();

  static BlueThermalPrinter bluetoothInstance = BlueThermalPrinter.instance;

  List<BluetoothDevice> devices = [];
  BluetoothDevice? _selectedDevice;

  Future<List<BluetoothDevice>> getDevices() async {
    try {
      return await bluetoothInstance.getBondedDevices();
    } on PlatformException {
      //TODO alert error
      return [];
    }
  }
  BluetoothDevice? getSelectedDevice(){
    return _selectedDevice;
  }
  void selectDevice({required BluetoothDevice? device}){
    //set as null for automatic selection
    _selectedDevice = device;
  }

  Future<PrintResponse> isReadyForPrint() async {

    devices = await getDevices();

    if (devices.isEmpty) {
      //TODO alert user
      return PrintResponse(status: false,message: "No devices found. Probably bt OFF");
    } else {

      //Select device automatically if no device selected
      if(_selectedDevice==null){
        for (var device in devices) {
          if (PrinterConfig.allowedBtPrinter.contains(device.name)) {
            print(
              'Device selected automatically: ${device.name} ${device.address} ${device.connected}',
            );
            _selectedDevice = device;
            break;
          }
        }
      }


      if (_selectedDevice == null) {
        //TODO alert user
        return PrintResponse(status: false,message: "No registered connected printer found");
      }

      bool? isConnected = await bluetoothInstance.isConnected;

      if (isConnected == false || isConnected==null) {
        try{
          await bluetoothInstance.connect(_selectedDevice!);
          return PrintResponse(status: true,message: "success");
        }catch(e){
          return PrintResponse(status: false,message: "connection Error");
        }
      } else {
        return PrintResponse(status: true,message: "success. Already connected");
      }
    }
  }

}


