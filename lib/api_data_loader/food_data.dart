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
    //? fromTodayFood making true
    //? so need to refresh data inside TodayFoodScreen on first time loading
    getTodayFoods(fromTodayFood: true);
    super.onInit();
  }

  getAllFoods({bool fromAllFood = false}) async {
    try {
      if (kDebugMode) {
        print('getTodayFoods() is called');
      }
      MyResponse response = await _foodsRepo.getAllFoods();

      if (response.statusCode == 1) {
        FoodResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allFoods;
        } else {
          _allFoods.clear();
          _allFoods.addAll(parsedResponse.data?.toList() ?? []);
          //? checking method called from AllFoodController
          //? else no need to call refreshMyAllFood() method
          if(fromAllFood){
            //? this will update data inside the allFood controller
            Get.find<AllFoodController>().refreshMyAllFood(_allFoods);
          }

        }
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
    update();
  }

  getTodayFoods({bool fromTodayFood = false}) async {
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
          //? checking method called from TodayFoodController
          //? else no need to call refreshMyTodayFood() method
          if(fromTodayFood){
            //? this will update data inside the allFood controller
            Get.find<TodayFoodController>().refreshMyTodayFood(_todayFoods);
            //? also update today food in billing screen
            Get.find<BillingScreenController>().refreshMyTodayFood(_todayFoods);
          }

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
