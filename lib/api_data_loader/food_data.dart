import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../error_handler/error_handler.dart';
import '../models/foods_response/food_response.dart';
import '../models/foods_response/foods.dart';
import '../models/my_response.dart';
import '../repository/food_repository.dart';
import '../screens/login_screen/controller/startup_controller.dart';
class FoodData extends GetxController {
  final FoodRepo _foodsRepo = Get.find<FoodRepo>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr  = Get.find<StartupController>().showErr;

  //?in this array get all food data from api through out the app working
  //? to save allFoods up to till app close
  final List<Foods> _allFoods = [];

  List<Foods> get allFoods => _allFoods;

  //? to save todayFoods up to till app close
  final List<Foods> _todayFoods = [];

  List<Foods> get todayFoods => _todayFoods;


  @override
  void onInit() async {
    //? fromTodayFood making true
    //? so need to refresh data inside TodayFoodScreen on first time loading
    getTodayFoods();
    super.onInit();
  }

  Future<MyResponse> getAllFoods() async {
    try {
      if (kDebugMode) {
        print('getTodayFoods() is called');
      }
      MyResponse response = await _foodsRepo.getAllFoods();

      if (response.statusCode == 1) {
        FoodResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allFoods;
          return MyResponse(statusCode: 0, status: 'Error', message: response.message);
        } else {
          _allFoods.clear();
          _allFoods.addAll(parsedResponse.data?.toList() ?? []);
         return MyResponse(statusCode: 1,data: _allFoods, status: 'Success', message:  response.message);

        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message:  response.message);
      }
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'categoryData',methodName: 'getCategory()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message:  myMessage);
    }finally{
      update();
    }

  }

  Future<MyResponse> getTodayFoods() async {
    if (kDebugMode) {
      print('getTodayFoods() is called');
    }
    try {

      MyResponse response = await _foodsRepo.getTodayFoods();
      if (response.statusCode == 1) {
        FoodResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _todayFoods;
          return MyResponse(statusCode: 0, status: 'Error', message: response.message);
        } else {
          _todayFoods.clear();
          _todayFoods.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _todayFoods, status: 'Success', message:  response.message);

        }

      } else {
        return MyResponse(statusCode: 0, status: 'Error', message: response.message);
      }
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'categoryData',methodName: 'getCategory()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message:  myMessage);
    }finally{
      update();
    }

  }
}
