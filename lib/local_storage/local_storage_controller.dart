import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../constants/hive_constants/hive_costants.dart';
class MyLocalStorage extends GetxController {

  //? this hive box for use like shared preferences not like data base
  //? to save  details temper
  Future<void> setData(String key , dynamic data) async {
    try {
      var box = await Hive.openBox(HIVE_BOX_NAME);
      box.put(key,data );
      if (kDebugMode) {
        print('Hive added data');
      }
    } catch (e) {
      rethrow;
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
      rethrow;
    }
  }

  //? to remove  data
  Future<void> removeData(String key) async {
    try {
      await Hive.initFlutter();
      var box = await Hive.openBox(HIVE_BOX_NAME);
      box.delete(key);
      if (kDebugMode) {
        print('Hive delete data');
      }
    } catch (e) {
     rethrow;
    }
  }

}
