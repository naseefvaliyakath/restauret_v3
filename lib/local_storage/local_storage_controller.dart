import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../constants/hive_constants/hive_costants.dart';
import '../error_handler/error_handler.dart';
class MyLocalStorage extends GetxController {
  final ErrorHandler errHandler = Get.find<ErrorHandler>();

  //? this hive box for use like shared preferences not like data base
  //? to save  details temper
  Future<void> setData(String key , dynamic data) async {
    try {
      var box = await Hive.openBox(HIVE_BOX_NAME);
      box.put(key,data );
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'local_storage_controller',methodName: 'setData()');
      return;
    }


  }

  //? to read  data
  Future<dynamic> readData(String key) async {
    try {
      var box = await Hive.openBox(HIVE_BOX_NAME);
      var result = box.get(key);
      if (kDebugMode) {
        print('Hive Result : $result');
      }
      return result;

    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'local_storage_controller',methodName: 'readData()');
      return;
    }
  }

  //? to remove  data
  Future<void> removeData(String key) async {
    try {
      await Hive.initFlutter();
      var box = await Hive.openBox(HIVE_BOX_NAME);
      box.delete(key);
    } catch (e) {
      errHandler.myResponseHandler(error: e.toString(),pageName: 'local_storage_controller',methodName: 'removeData()');
      return;
    }
  }

}
