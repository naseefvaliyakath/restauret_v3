import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import '../../../api_data_loader/category_data.dart';
import '../../../api_data_loader/food_data.dart';
import '../../../constants/strings/my_strings.dart';
import '../../../models/category_response/category.dart';
import '../../../models/foods_response/foods.dart';
import '../../../models/my_response.dart';
import '../../../repository/food_repository.dart';
import '../../../widget/common_widget/snack_bar.dart';

class AllFoodController extends GetxController {
  //?controllers
  final FoodData _foodData = Get.find<FoodData>();
  final FoodRepo _foodRepo = Get.find<FoodRepo>();
  final CategoryData _categoryData = Get.find<CategoryData>();

  //? this will store all AllFood from the server
  //? not showing in UI or change
  final List<Foods> _storedAllFoods = [];

  //? today food to show in UI
  final List<Foods> _myAllFoods = [];

  List<Foods> get myAllFoods => _myAllFoods;

  //? this will store all Category from the server
  //? not showing in UI or change
  final List<Category> _storedCategory = [];

  //? Category to show in UI
  final List<Category> _myCategory = [];

  List<Category> get myCategory => _myCategory;

  //? Search all food controller
  late TextEditingController searchTD;

  //? for show full screen loading
  bool isLoading = false;


  //? to sort food as per category
  String selectedCategory = COMMON_CATEGORY;



  @override
  void onInit() async {
    searchTD = TextEditingController();
    getInitialFood();
    getInitialCategory();
    super.onInit();
  }

  @override
  void onClose() async {
    searchTD.dispose();
    super.onInit();
  }


  //? to load o first screen loading
  getInitialFood() {
    try {
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedAllFoods from foodData controller
      if (_foodData.allFoods.isEmpty) {
        if (kDebugMode) {
          print(_foodData.allFoods.length);
          print('data loaded from db');
        }
        _foodData.getAllFoods(fromAllFood: true);
      } else {
        if (kDebugMode) {
          print('data loaded from food data');
        }
        //? load data from variable in todayFood
        _storedAllFoods.clear();
        _storedAllFoods.addAll(_foodData.allFoods);
        //? to show full food in UI
        _myAllFoods.clear();
        _myAllFoods.addAll(_storedAllFoods);
      }
      update();
    } catch (e) {
      return;
    }
  }

  //? searchKey get from onChange event in all foodScreen
  searchAllFood() {
    try {
        final suggestion = _storedAllFoods.where((food) {
        final fdName = food.fdName!.toLowerCase();
        final input = searchTD.text.toLowerCase();
        return fdName.contains(input);
      });
      _myAllFoods.clear();
      _myAllFoods.addAll(suggestion);
      update();
    } catch (e) {
      return;
    }
  }


  //? to remove from today food
  addToToday(int fdId, String isToday) async {
    try {
      showLoading();
      MyResponse response = await _foodRepo.updateTodayFood(fdId, isToday);
      if (response.statusCode == 1) {
        refreshAllFood();
        //? to update today food also after adding in today food
        _foodData.getTodayFoods(fromTodayFood: true);
        //! success message shown in refreshAllFood() method
        // AppSnackBar.successSnackBar('Success', response.message);
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

  //? this function will call getAllFood() in FoodData
  //? ad refresh fresh data from server
  refreshAllFood() async {
    await _foodData.getAllFoods(fromAllFood: true);
    AppSnackBar.successSnackBar('Success', 'Foods updated successfully');
  }

  //? when call getAllFood() in FoodData this method will call in success
  //? to update fresh data in FoodData and today food also
  //? this method only call from FoodData like callback
  refreshMyAllFood(List<Foods> todayFoodsFromFoodData) {
    try {
      _storedAllFoods.clear();
      _storedAllFoods.addAll(todayFoodsFromFoodData);
      //? to show full food in UI
      _myAllFoods.clear();
      _myAllFoods.addAll(_storedAllFoods);
      update();
    } catch (e) {
      return;
    }
  }


  //? to delete the food
  deleteFood(int fdId) async {
    try {
      showLoading();
      MyResponse response = await _foodRepo.deleteFood(fdId);
      if (response.statusCode == 1) {
        refreshAllFood();
        //? to update today food also after deleting in today food
        _foodData.getTodayFoods(fromTodayFood: true);
         //! snack bar showing when refresh food no need to show here
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
        _categoryData.getCategory(fromAllFood: true);
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
      await _categoryData.getCategory(fromAllFood: true);
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
        _myAllFoods.clear();
        _myAllFoods.addAll(_storedAllFoods);
      } else {
        for (var element in _storedAllFoods) {
          //? iterating the food by selected category from dropdown list and saving inside sortedFoodByCategory list
          if (element.fdCategory == selectedCategory) {
            sortedFoodByCategory.add(element);
          }
        }
        _myAllFoods.clear();
        _myAllFoods.addAll(sortedFoodByCategory);
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
