import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';
import 'package:rest_verision_3/screens/today_food_screen/controller/today_food_controller.dart';

import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/foods_response/food_response.dart';
import '../models/foods_response/foods.dart';
import '../models/my_response.dart';
import '../repository/food_repository.dart';
import '../screens/all_food_screen/controller/all_food_controller.dart';
class FoodData extends GetxController {
  final FoodRepo _foodsRepo = Get.find<FoodRepo>();

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
          return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
        } else {
          _allFoods.clear();
          _allFoods.addAll(parsedResponse.data?.toList() ?? []);
         return MyResponse(statusCode: 1,data: _allFoods, status: 'Success', message:  'Updated successfully');

        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message:  'Something wrong !!');
      }
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message:  'Something wrong !!');
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
          return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
        } else {
          _todayFoods.clear();
          _todayFoods.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _todayFoods, status: 'Success', message:  'Updated successfully');

        }

      } else {
        return MyResponse(statusCode: 0, status: 'Error', message:  'Something wrong !!');
      }
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message:  'Something wrong !!');
    }finally{
      update();
    }

  }
}
