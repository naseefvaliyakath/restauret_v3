import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart' hide Response;

import '../../../api_data_loader/category_data.dart';
import '../../../api_data_loader/food_data.dart';
import '../../../check_internet/check_internet.dart';
import '../../../constants/strings/my_strings.dart';
import '../../../error_handler/error_handler.dart';
import '../../../models/category_response/category.dart';
import '../../../models/my_response.dart';
import '../../../repository/food_repository.dart';
import '../../../widget/common_widget/snack_bar.dart';
import '../../login_screen/controller/startup_controller.dart';
import '../../today_food_screen/controller/today_food_controller.dart';

class UpdateFoodController extends GetxController {
  //?controllers
  final CategoryData _categoryData = Get.find<CategoryData>();
  final FoodRepo _foodRepo = Get.find<FoodRepo>();
  final FoodData _foodData = Get.find<FoodData>();
  bool showErr  = Get.find<StartupController>().showErr;
  final ErrorHandler errHandler = Get.find<ErrorHandler>();

  //? to store image file
  File? file;

  //? text-editing controllers
  late TextEditingController fdNameTD;
  late TextEditingController fdPriceTD;
  late TextEditingController fdFullPriceTD;
  late TextEditingController fdThreeBiTwoPrsTD;
  late TextEditingController fdHalfPriceTD;
  late TextEditingController fdQtrPriceTD;

  //? this will store all Category from the server
  //? not showing in UI or change
  final List<Category> _storedCategory = [];

  //? Category to show in UI
  final List<Category> _myCategory = [];

  List<Category> get myCategory => _myCategory;

  //? to show full screen loading
  bool isLoading = false;

  //? for category update need other loader , so after catch isLoading become false so in ctr.list.length may make error
  bool isLoadingCategory = false;

  //? to change tapped color of category card
  //? it wil updated in setCategoryTappedIndex() method
  int tappedIndex = 0;

  //? to show and hide multiple price
  bool priceToggle = false;

  //? to toggle update image card and showing current image
  bool imageToggle = false;
  //? on init this variable fill the current category
  //? then after loading category check the variable data and set category index

  String initialFdName = '';
  String initialFdCategory = COMMON_CATEGORY;
  String initialFdImg = 'https://mobizate.com/uploads/sample.jpg';
  String initialFdIsToday = 'no';
  int initialCookTime = 0;
  int initialId = -1;

  @override
  Future<void> onInit() async {
    initTxtCtrl();
    checkInternetConnection();
    receiveInitialValue();
    getInitialCategory();
    super.onInit();
  }

  @override
  void onClose() {
    disposeTxtCtrl();
  }

  //////! category section !//////

  //? to load o first screen loading
  getInitialCategory() {
    try {
      //? to show shimming loading
      isLoadingCategory = true;
      update();
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedCategory from CategoryData controller
      if (_categoryData.category.isEmpty) {
        if (kDebugMode) {
          print(_categoryData.category.length);
          print('data loaded from db');
        }
        refreshCategory();
      } else {
        if (kDebugMode) {
          print('data loaded from category data');
        }
        //? load data from variable in todayFood
        _storedCategory.clear();
        _storedCategory.addAll(_categoryData.category);
        //? to show full food in UI
        _myCategory.clear();
        _myCategory.addAll(_storedCategory);
      }

      //? this method is calling here and updateInitialValue() method also
      //? because some time updateInitialValue() will call first time eg: if data loaded from dB
      updateCategoryFirstTime(initialFdCategory);

      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'update_food_controller',methodName: 'getInitialCategory()');
      return;
    }
    finally{
      isLoadingCategory = false;
      update();
    }
  }

  //? to change tapped category
  setCategoryTappedIndex(int val) {
    tappedIndex = val;
    update();
  }

  //? setting up setCategoryTappedIndex initially as per current category
  updateCategoryFirstTime(catName){

    try {
      _myCategory.asMap().forEach((index, value) {
        if (kDebugMode) {
          print(value.catName);
        }
            if(value.catName == catName){
              setCategoryTappedIndex(index);
              if (kDebugMode) {
                print('updateCategoryFirstTime called $catName and index $index');
              }
            }
          });

      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'update_food_controller',methodName: 'updateCategoryFirstTime()');
      return;
    }
  }


  //? ad refresh fresh data from server
  refreshCategory() async {
    try {
      //? to show shimming loading
      isLoadingCategory = true;
      update();
      MyResponse response = await _categoryData.getCategory();
      if(response.statusCode == 1){
        if(response.data != null){
          List<Category>  category = response.data;
          _storedCategory.clear();
          _storedCategory.addAll(category);
          //? to show full food in UI
          _myCategory.clear();
          _myCategory.addAll(_storedCategory);
          AppSnackBar.successSnackBar('Success', response.message);
        }
      }else{
        AppSnackBar.errorSnackBar('Error', response.message);
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'update_food_controller',methodName: 'refreshCategory()');
      return;
    } finally {
      isLoadingCategory = false;
      update();
    }
  }



  //////! category section !//////

  receiveInitialValue(){
    try {
      int id = Get.arguments['id'] ?? -1;
      String fdName = Get.arguments['fdName'] ?? '';
      String fdCategory = Get.arguments['fdCategory'] ?? COMMON_CATEGORY;
      double fdFullPrice = Get.arguments['fdFullPrice'] ?? 0;
      double fdThreeBiTwoPrsPrice = Get.arguments['fdThreeBiTwoPrsPrice'] ?? 0;
      double fdHalfPrice = Get.arguments['fdHalfPrice'] ?? 0;
      double fdQtrPrice = Get.arguments['fdQtrPrice'] ?? 0;
      String fdIsLoos = Get.arguments['fdIsLoos'] ?? 'no';
      int cookTime = Get.arguments['cookTime'] ?? 0;
      String fdImg = Get.arguments['fdImg'] ?? IMG_LINK;
      String fdIsToday = Get.arguments['fdIsToday'] ?? 'no';
      if (kDebugMode) {
            print('$fdName -- $fdCategory --  $fdFullPrice');
          }

      //? make the received values global
      initialId = id;
      initialFdName = fdName;
      initialFdIsToday = fdIsToday;
      initialFdImg = fdImg;
      initialCookTime = cookTime;
      initialFdCategory =fdCategory;

      //? to set the values in controllers and btn's
      updateInitialValue(fdName, fdFullPrice, fdThreeBiTwoPrsPrice, fdHalfPrice, fdQtrPrice, fdIsLoos, fdCategory);
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'update_food_controller',methodName: 'receiveInitialValue()');
      return;
    }
  }


  //? for the initial  from routing
  //? to set the vales initially in txt controllers and btn's
  updateInitialValue(fdNameIn, fdPriceIn, fdThreeBiTwoPrsPriceIn, fdHalfPriceIn, fdQtrPriceIn, fdIsLoos,fdCategory) {
    try {
      RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
      //? setting up value in txt controllers
      fdNameTD.text = fdNameIn;
      fdThreeBiTwoPrsTD.text = fdThreeBiTwoPrsPriceIn.toString().replaceAll(regex, '');
      fdHalfPriceTD.text = fdHalfPriceIn.toString().replaceAll(regex, '');
      fdQtrPriceTD.text = fdQtrPriceIn.toString().replaceAll(regex, '');
      //? to set initial price toggle status from data
      fdIsLoos == 'yes' ? priceToggle = true : priceToggle = false;
      fdIsLoos == 'yes' ? fdFullPriceTD.text = fdPriceIn.toString().replaceAll(regex, '') : fdPriceTD.text = fdPriceIn.toString().replaceAll(regex, '');
      if (kDebugMode) {
        print('price toggle $priceToggle');
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'update_food_controller',methodName: 'updateInitialValue()');
      return;
    }
    update();
  }

  //? show and hide multiple price txt box
  setPriceToggle(bool val) {
    priceToggle = val;
    update();
  }

  //? to toggle update image card and showing current image
  setImageToggle(bool val) {
    imageToggle = val;
    update();
  }

  //validate before insert
  validateFoodDetails() async {
    try {
      if ((fdPriceTD.text.trim() != '' || fdFullPriceTD.text.trim() != '')) {
        var fdIsLoos = 'no';
        double fdPriceNew = 0;
        var fdNameNew = initialFdName;
        var fdCategoryNew = initialFdCategory;
        int idNew = initialId;
        var fdImgNew = initialFdImg;
        var fdIsTodayNew = initialFdIsToday;
        int cookTimeNew = initialCookTime;
        double fdThreeBiTwoPrsPriceNew = 0;
        double fdHalfPriceNew = 0;
        double fdQtrPriceNew = 0;

        //?full price only
        if (!priceToggle) {
          fdIsLoos = 'no';
          fdPriceNew = fdPriceTD.text == '' ? 0 : double.parse(fdPriceTD.text);
          //? multiple price
        } else {
          fdIsLoos = 'yes';
          fdPriceNew = fdFullPriceTD.text == '' ? 0 : double.parse(fdFullPriceTD.text);
        }
        fdNameNew = fdNameTD.text;
        fdThreeBiTwoPrsPriceNew = fdThreeBiTwoPrsTD.text == '' ? 0 : double.parse(fdThreeBiTwoPrsTD.text);
        fdHalfPriceNew = fdHalfPriceTD.text == '' ? 0 : double.parse(fdHalfPriceTD.text);
        fdQtrPriceNew = fdQtrPriceTD.text == '' ? 0 : double.parse(fdQtrPriceTD.text);

        //? after validation updating food to dB
        await updateFood(
          file: file,
          fdNameNew: fdNameNew,
          fdCategoryNew: fdCategoryNew,
          fdPriceNew: fdPriceNew,
          fdThreeBiTwoPrsPriceNew: fdThreeBiTwoPrsPriceNew,
          fdHalfPriceNew: fdHalfPriceNew,
          fdQtrPriceNew: fdQtrPriceNew,
          fdIsLoos: fdIsLoos,
          cookTimeNew: cookTimeNew,
          fdImgNew: fdImgNew,
          fdIsTodayNew: fdIsTodayNew,
          idNew: idNew,
        );

      } else {
        AppSnackBar.errorSnackBar('Fill the fields!', 'Enter the values in fields!!');
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'update_food_controller',methodName: 'validateFoodDetails()');
      return;
    }
  }

  //? to insert the food
  updateFood({
    required file,
    required fdNameNew,
    required fdCategoryNew,
    required fdPriceNew,
    required fdThreeBiTwoPrsPriceNew,
    required fdHalfPriceNew,
    required fdQtrPriceNew,
    required fdIsLoos,
    required cookTimeNew,
    required fdImgNew,
    required fdIsTodayNew,
    required idNew,
  }) async {
    try {
      showLoading();
      MyResponse response = await _foodRepo.updateFood(
          file: file,
          fdName: fdNameNew,
          fdCategory: fdCategoryNew,
          fdPrice: fdPriceNew,
          fdThreeBiTwoPrsPrice: fdThreeBiTwoPrsPriceNew,
          fdHalfPrice: fdHalfPriceNew,
          fdQtrPrice: fdQtrPriceNew,
          fdIsLoos: fdIsLoos,
          cookTime: cookTimeNew,
          fdImg: fdImgNew,
          fdIsToday: fdIsTodayNew,
          id: idNew);
      if (response.statusCode == 1) {
        //? to update all food  in data loader
        //? inside UI it will call on onInit (all-food controller is lazyPut)
        _foodData.getAllFoods();
        //? refreshing today food
        _foodData.getTodayFoods();
        //? today food controller is permanent , refresh myTodayFood by calling this method
        Get.find<TodayFoodController>().refreshTodayFood(showSnack: false);
        AppSnackBar.successSnackBar('Success', response.message);
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
        return;
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'update_food_controller',methodName: 'updateFood()');
      return;
    } finally {
      hideLoading();
      update();
    }
  }



  initTxtCtrl() {
    fdNameTD = TextEditingController();
    fdPriceTD = TextEditingController();
    fdFullPriceTD = TextEditingController();
    fdThreeBiTwoPrsTD = TextEditingController();
    fdHalfPriceTD = TextEditingController();
    fdQtrPriceTD = TextEditingController();
  }

  disposeTxtCtrl() {
    fdNameTD.dispose();
    fdFullPriceTD.dispose();
    fdThreeBiTwoPrsTD.dispose();
    fdHalfPriceTD.dispose();
    fdQtrPriceTD.dispose();
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
