import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/food_data.dart';
import 'package:rest_verision_3/repository/food_repository.dart';
import '../../../api_data_loader/category_data.dart';
import '../../../constants/strings/my_strings.dart';
import '../../../error_handler/error_handler.dart';
import '../../../models/category_response/category.dart';
import '../../../models/foods_response/foods.dart';
import '../../../models/my_response.dart';
import '../../../widget/common_widget/snack_bar.dart';
import '../../login_screen/controller/startup_controller.dart';

class TodayFoodController extends GetxController {
  //?controllers
  final FoodData _foodData = Get.find<FoodData>();
  final FoodRepo _foodRepo = Get.find<FoodRepo>();
  final CategoryData _categoryData = Get.find<CategoryData>();
  bool showErr  = Get.find<StartupController>().showErr;
  final ErrorHandler errHandler = Get.find<ErrorHandler>();

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

  //? to authorize cashier or waiter
  bool isCashier = false;


  @override
  void onInit() async {
    searchTD = TextEditingController();
    await checkIsCashier();
    getInitialTodayFood();
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
      errHandler.myResponseHandler(error: e.toString(),pageName: 'today_food_controller',methodName: 'searchTodayFood()');
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'today_food_controller',methodName: 'removeFromToday()');
      return;
    } finally {
      hideLoading();
      update();
    }
  }

  //? to remove from today food
  updateToQuickBill(int fdId, String isQuick) async {
    try {
      //? block user to add more than 4 quick bill from cline side (server side also blocking)
      if(isQuick == 'yes' && _myTodayFoods.where((element) => element.fdIsQuick == 'yes').length >= 4){
        AppSnackBar.errorSnackBar('Cant add', 'You cannot add more than 4 quick bill');
      }
      else {
        showLoading();
        MyResponse response = await _foodRepo.updateQuickBillFood(fdId, isQuick);
        if (response.statusCode == 1) {
          refreshTodayFood();
          //? to update today food after it removing
          _foodData.getAllFoods();
          //! success message shown in refreshTodayFood() method
        } else {
          AppSnackBar.errorSnackBar('Error', response.message);
          return;
        }
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'today_food_controller',methodName: 'updateToQuickBill()');
      return;
    } finally {
      hideLoading();
      update();
    }
  }


  //? to load o first screen loading
  getInitialTodayFood() {
    try {
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedTodayFoods from foodData controller
      showLoading();
      if (_foodData.todayFoods.isEmpty) {
        if (kDebugMode) {
          print(_foodData.todayFoods.length);
          print('food data loaded from db');
        }
        refreshTodayFood(showSnack: false);
      } else {
        if (kDebugMode) {
          print('food data loaded from food data ${_foodData.todayFoods.length}');
        }
        //? load data from variable in todayFood
        _storedTodayFoods.clear();
        _storedTodayFoods.addAll(_foodData.todayFoods);
        //? to show full food in UI
        _myTodayFoods.clear();
        _myTodayFoods.addAll(_storedTodayFoods);
      }
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'today_food_controller',methodName: 'getInitialTodayFood()');
      return;
    } finally {
      hideLoading();
    }
  }

  //? this function will call getTodayFood() in FoodData
  refreshTodayFood({bool showSnack = true}) async {
    try {
      MyResponse response = await _foodData.getTodayFoods();
      if(response.statusCode == 1){
        if(response.data != null){
          List<Foods>  foods = response.data;
          _storedTodayFoods.clear();
          _storedTodayFoods.addAll(foods);
          //? to show full food in UI
          _myTodayFoods.clear();
          _myTodayFoods.addAll(_storedTodayFoods);
          if(showSnack) {
            AppSnackBar.successSnackBar('Success', response.message);
          }
        }
      }else{
        if(showSnack) {
          AppSnackBar.errorSnackBar('Error', response.message);
        }
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'today_food_controller',methodName: 'refreshTodayFood()');
      return;
    } finally {
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
        refreshCategory(showSnack: false);
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'today_food_controller',methodName: 'getInitialCategory()');
      return;
    }
  }

  //? ad refresh fresh data from server
  refreshCategory({bool showSnack = true}) async {
    try {
      MyResponse response = await _categoryData.getCategory();
      if(response.statusCode == 1){
        if(response.data != null){
          List<Category>  category = response.data;
          _storedCategory.clear();
          _storedCategory.addAll(category);
          //? to show full category in UI
          _myCategory.clear();
          _myCategory.addAll(_storedCategory);
          if(showSnack) {
            AppSnackBar.successSnackBar('Success', response.message);
          }
        }
      }else{
        if(showSnack) {
          AppSnackBar.errorSnackBar('Error', response.message);
        }
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'today_food_controller',methodName: 'refreshCategory()');
      return;
    } finally {
      update();
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'today_food_controller',methodName: 'sortFoodBySelectedCategory()');
      return;
    }
  }

  //? to authorize cashier or waiter
  checkIsCashier() async {
    try {
      int appModeNumber = await Get.find<StartupController>().readAppModeInHive();
      if(appModeNumber == 1){
            isCashier = true;
          }
          else{
            isCashier = false;
          }
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'today_food_controller',methodName: 'checkIsCashier()');
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
