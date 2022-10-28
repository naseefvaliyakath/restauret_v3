import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/food_data.dart';
import 'package:rest_verision_3/repository/food_repository.dart';
import '../../../api_data_loader/category_data.dart';
import '../../../constants/strings/my_strings.dart';
import '../../../models/category_response/category.dart';
import '../../../models/foods_response/foods.dart';
import '../../../models/my_response.dart';
import '../../../widget/common_widget/snack_bar.dart';

class TodayFoodController extends GetxController {
  //?controllers
  final FoodData _foodData = Get.find<FoodData>();
  final FoodRepo _foodRepo = Get.find<FoodRepo>();
  final CategoryData _categoryData = Get.find<CategoryData>();

  //? this will store all today food from the server
  //? not showing in UI or change
  final List<Foods> _storedTodayFoods = [];

  //? today food to show in UI
  final List<Foods> _myTodayFoods = [];

  List<Foods> get myTodayFoods => _myTodayFoods;

  //? this will store all Category from the server
  //? not showing in UI or change
  final List<Category> _storedCategory = [];

  //? Category to show in UI
  final List<Category> _myCategory = [];

  List<Category> get myCategory => _myCategory;

  //? Search today food controller
  late TextEditingController searchTD;

  //? for show full screen loading
  bool isLoading = false;

  //? to sort food as per category
  String selectedCategory = COMMON_CATEGORY;


  @override
  void onInit() async {
    searchTD = TextEditingController();
    getInitialCategory();
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



  //////! category section !//////

  //? to load o first screen loading
  getInitialCategory() {
    try {
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedCategory from CategoryData controller
      if (_categoryData.category.isEmpty) {
        if (kDebugMode) {
          print(_categoryData.category.length);
          print('category data loaded from db');
        }
        _categoryData.getCategory(fromToday: true);
      } else {
        if (kDebugMode) {
          print('category data loaded from category data');
        }
        //? load data from variable in categoryData
        _storedCategory.clear();
        _storedCategory.addAll(_categoryData.category);
        //? to show full food in UI
        _myCategory.clear();
        _myCategory.addAll(_storedCategory);
      }
      update();
    } catch (e) {
      return;
    }
  }

  //? this function will call getCategory() in CategoryData
  //? ad refresh fresh data from server
  refreshCategory() async {
    try {
      await _categoryData.getCategory(fromToday: true);
      //? no need to show snack-bar
    } catch (e) {
      rethrow;
    }
  }

  //? when call getCategory() in CategoryData this method will call in success
  //? to update fresh data in CategoryData and _myCategory also
  //? this method only for call getCategory method from CategoryData like callback
  refreshMyCategory(List<Category> categoryFromCategoryData) {
    try {
      _storedCategory.clear();
      _storedCategory.addAll(categoryFromCategoryData);
      //? to show full food in UI
      _myCategory.clear();
      _myCategory.addAll(_storedCategory);
      update();
    } catch (e) {
      return;
    }
  }

  //? to sort food with sorting btn
  sortFoodBySelectedCategory() {
    try {

      List<Foods> sortedFoodByCategory = [];
      //? checking if selected category is COMMON or not selected
      if (selectedCategory.toUpperCase() == COMMON_CATEGORY.toUpperCase()) {
        _myTodayFoods.clear();
        _myTodayFoods.addAll(_storedTodayFoods);
      } else {
        for (var element in _storedTodayFoods) {
          //? iterating the food by selected category from dropdown list and saving inside sortedFoodByCategory list
          if (element.fdCategory == selectedCategory) {
            sortedFoodByCategory.add(element);
          }
        }
        _myTodayFoods.clear();
        _myTodayFoods.addAll(sortedFoodByCategory);
      }
      update();
    } catch (e) {
      rethrow;
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
