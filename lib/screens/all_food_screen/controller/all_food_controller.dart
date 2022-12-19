import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/today_food_screen/controller/today_food_controller.dart';
import '../../../api_data_loader/category_data.dart';
import '../../../api_data_loader/food_data.dart';
import '../../../check_internet/check_internet.dart';
import '../../../constants/strings/my_strings.dart';
import '../../../error_handler/error_handler.dart';
import '../../../models/category_response/category.dart';
import '../../../models/foods_response/foods.dart';
import '../../../models/my_response.dart';
import '../../../repository/food_repository.dart';
import '../../../widget/common_widget/snack_bar.dart';
import '../../login_screen/controller/startup_controller.dart';

class AllFoodController extends GetxController {
  //?controllers
  final FoodData _foodData = Get.find<FoodData>();
  final FoodRepo _foodRepo = Get.find<FoodRepo>();
  final CategoryData _categoryData = Get.find<CategoryData>();
  bool showErr  = Get.find<StartupController>().showErr;
  final ErrorHandler errHandler = Get.find<ErrorHandler>();

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

  //? to authorize cashier and waiter
  bool isCashier = false;



  @override
  void onInit() async {
    searchTD = TextEditingController();
    await checkIsCashier();
    checkInternetConnection();
    //? refreshing new data _allFood in food data
    refreshAllFood(showSnack: false);
    //? load refreshed new data to Ui (myAllFood)
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
        refreshAllFood(showSnack: false);
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
      errHandler.myResponseHandler(error: e.toString(),pageName: 'all_food_controller',methodName: 'searchFood()');
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
        //? to update today food also after adding in today food in data loader and UI
        _foodData.getTodayFoods();
        Get.find<TodayFoodController>().refreshTodayFood(showSnack: false);
        //! success message shown in refreshAllFood() method
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
        return;
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'all_food_controller',methodName: 'addToToday()');
    } finally {
      hideLoading();
      update();
    }
  }


  //? ad refresh fresh data from server
  refreshAllFood({bool showSnack = true}) async {
   try {
     MyResponse response = await _foodData.getAllFoods();
     if(response.statusCode == 1){
       if(response.data != null){
         List<Foods>  foods = response.data;
         _storedAllFoods.clear();
         _storedAllFoods.addAll(foods);
         //? to show full food in UI
         _myAllFoods.clear();
         _myAllFoods.addAll(_storedAllFoods);
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
     errHandler.myResponseHandler(error: e.toString(),pageName: 'all_food_controller',methodName: 'refreshAllFood()');
     return;
   }finally{
     update();
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
        _foodData.getTodayFoods();
         //! snack bar showing when refresh food no need to show here
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
        return;
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'all_food_controller',methodName: 'deleteFood()');
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
      errHandler.myResponseHandler(error: e.toString(),pageName: 'all_food_controller',methodName: 'getInitialCategory()');
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
          //? to show full food in UI
          _myCategory.clear();
          _myCategory.addAll(_storedCategory);
          //? to hide snack-bar on page starting , because this method is calling page starting
          if(showSnack) {
            AppSnackBar.successSnackBar('Success', response.message);
          }
        }
      }else{
        //? to hide snack-bar on page starting , because this method is calling page starting
        if(showSnack) {
          AppSnackBar.errorSnackBar('Error', response.message);
        }
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'all_food_controller',methodName: 'refreshCategory()');
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'all_food_controller',methodName: 'sortFoodBySelectedCategory()');
      rethrow;
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
      errHandler.myResponseHandler(error: e.toString(),pageName: 'all_food_controller',methodName: 'checkIsCashier()');
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
