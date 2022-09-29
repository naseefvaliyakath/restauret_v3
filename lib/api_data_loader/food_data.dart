import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/today_food_screen/controller/today_food_controller.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/foods_response/food_response.dart';
import '../models/foods_response/foods.dart';
import '../models/my_response.dart';
import '../repository/food_repository.dart';
import '../widget/common_widget/snack_bar.dart';

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
    getTodayFoods();
    super.onInit();
  }

  getAllFoods() async {
    try {
      MyResponse response = await _foodsRepo.getAllFoods();

      if (response.statusCode == 1) {
        FoodResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allFoods;
        } else {
          _allFoods.addAll(parsedResponse.data?.toList() ?? []);
        }
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
    update();
  }

  getTodayFoods() async {
    if (kDebugMode) {
      print('getTodayFoods() is called');
    }
    try {

      MyResponse response = await _foodsRepo.getTodayFoods();

      if (response.statusCode == 1) {
        FoodResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _todayFoods;
        } else {
          _todayFoods.clear();
          _todayFoods.addAll(parsedResponse.data?.toList() ?? []);
          Get.find<TodayFoodController>().refreshMyTodayFood(_todayFoods);
        }
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
    update();
  }
}
