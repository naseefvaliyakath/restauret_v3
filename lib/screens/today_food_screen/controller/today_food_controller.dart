import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/food_data.dart';
import 'package:rest_verision_3/repository/food_repository.dart';
import '../../../models/foods_response/foods.dart';
import '../../../models/my_response.dart';
import '../../../widget/common_widget/snack_bar.dart';

class TodayFoodController extends GetxController {
  //?controllers
  final FoodData _foodData = Get.find<FoodData>();
  final FoodRepo _foodRepo = Get.find<FoodRepo>();

  //? this will store all today food from the server
  //? not showing in UI or change
  final List<Foods> _storedTodayFoods = [];

  //? today food to show in UI
  final List<Foods> _myTodayFoods = [];

  List<Foods> get myTodayFoods => _myTodayFoods;

  //? Search today food controller
  late TextEditingController searchTD;

  //? for show full screen loading
  bool isLoading = false;


  @override
  void onInit() async {
    searchTD = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() async {
    searchTD.dispose();
    super.onInit();
  }


  //? searchKey get from onChange event in today foodScreen
  searchTodayFood() {
    try {
      final suggestion = _storedTodayFoods.where((food) {
        final fdName = food.fdName!.toLowerCase();
        final input = searchTD.text.toLowerCase();
        return fdName.contains(input);
      });
      _myTodayFoods.clear();
      _myTodayFoods.addAll(suggestion);
      update();
    } catch (e) {
      return;
    }
  }

  //? to remove from today food
  removeFromToday(int fdId, String isToday) async {
    try {
      showLoading();
      MyResponse response = await _foodRepo.updateTodayFood(fdId, isToday);
      if (response.statusCode == 1) {
        refreshTodayFood();
        //? to update today food after it removing
        _foodData.getAllFoods();
        //! success message shown in refreshTodayFood() method
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
        return;
      }
    } catch (e) {
      AppSnackBar.errorSnackBar('Error', 'Something wet to wrong');
    } finally {
      hideLoading();
      update();
    }
  }

  //? this function will call getTodayFood() in FoodData
  //? ad refresh fresh data from server
  refreshTodayFood() async {
   await _foodData.getTodayFoods(fromTodayFood: true);
   AppSnackBar.successSnackBar('Success', 'Foods updated successfully');
  }

  //? when call getTodayFood() in FoodData this method will call in success
  //? to update fresh data in FoodData and today food also
  //? this method only call from FoodData like callback
  refreshMyTodayFood(List<Foods> todayFoodsFromFoodData) {
    try {
      _storedTodayFoods.clear();
      _storedTodayFoods.addAll(todayFoodsFromFoodData);
      //? to show full food in UI
      _myTodayFoods.clear();
      _myTodayFoods.addAll(_storedTodayFoods);
      update();
    } catch (e) {
      return;
    }
  }

  showLoading() {
    isLoading = true;
    update();
  }

  hideLoading() {
    isLoading = false;
    update();
  }
}
