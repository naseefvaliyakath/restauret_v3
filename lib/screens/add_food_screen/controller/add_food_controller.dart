import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart' hide Response;
import 'package:rest_verision_3/api_data_loader/category_data.dart';
import 'package:rest_verision_3/api_data_loader/food_data.dart';
import 'package:rest_verision_3/models/category_response/category.dart';
import 'package:rest_verision_3/repository/category_repository.dart';

import '../../../check_internet/check_internet.dart';
import '../../../constants/strings/my_strings.dart';
import '../../../models/my_response.dart';
import '../../../repository/food_repository.dart';
import '../../../widget/common_widget/snack_bar.dart';

class AddFoodController extends GetxController {
  //?controllers
  final CategoryData _categoryData = Get.find<CategoryData>();
  final CategoryRepo _categoryRepo = Get.find<CategoryRepo>();
  final FoodRepo _foodRepo = Get.find<FoodRepo>();
  final FoodData _foodData = Get.find<FoodData>();

  //? to store image file
  File? file;

  //? text-editing controllers
  late TextEditingController fdNameTD;
  late TextEditingController fdPriceTD;
  late TextEditingController fdFullPriceTD;
  late TextEditingController fdThreeBiTwoPrsTD;
  late TextEditingController fdHalfPriceTD;
  late TextEditingController fdQtrPriceTD;

  //? category name controller for adding new category
  late TextEditingController categoryNameTD;

  //? this will store all Category from the server
  //? not showing in UI or change
  final List<Category> _storedCategory = [];

  //? Category to show in UI
  final List<Category> _myCategory = [];

  List<Category> get myCategory => _myCategory;

  //? to show and hide multiple price text field on toggle price btn
  bool priceToggle = false;

  //? to show full screen loading
  bool isLoading = false;

  //? for category update need other loader , so after catch isLoading become false so in ctr.list.length may make error
  bool isLoadingCategory = false;

  //? to show loading when add new category
  bool addCategoryLoading = false;

  //? to change tapped color of category card
  //? it wil updated in setCategoryTappedIndex() method
  int tappedIndex = 0;
  //? to get by selected category
  String selectedCategory = COMMON_CATEGORY;

  //? to show add category card and text-field
  bool addCategoryToggle = false;

  @override
  Future<void> onInit() async {
    checkInternetConnection();
    initTxtCtrl();
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
        refreshCategory(showSnack: false);
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
        //? assign first category in list after loading category
        selectedCategory = _myCategory.isNotEmpty ?  _myCategory.first.catName ?? COMMON_CATEGORY :COMMON_CATEGORY ;
      }
      update();
    } catch (e) {
      return;
    }
    finally{
      isLoadingCategory = false;
      update();
    }
  }

  //? this function will call getCategory() in CategoryData
  //? ad refresh fresh data from server
  refreshCategory({bool showSnack = true}) async {
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
          //? to show full category in UI
          _myCategory.clear();
          _myCategory.addAll(_storedCategory);
          if(showSnack) {
            AppSnackBar.successSnackBar('Success', 'Updated successfully');
          }
        }
      }else{
        if(showSnack) {
          AppSnackBar.errorSnackBar('Error', 'Something went to wrong !!');
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoadingCategory = false;
      update();
    }
  }



  //? to change tapped category
  setCategoryTappedIndex(int val,String fdCategorySelected) {

    tappedIndex = val;
    //? update selected category on tapping
    selectedCategory = fdCategorySelected;
    update();
  }

  //? to add category widget show and hide
  setAddCategoryToggle(bool val) {
    addCategoryToggle = val;
    update();
  }


  //?insert category
  Future insertCategory() async {
    try {
      addCategoryLoading = true;
      update();
      String categoryNameString = '';
      categoryNameString = categoryNameTD.text;
      //? checking valid name
      if (categoryNameString.trim() != '') {
        MyResponse response = await _categoryRepo.insertCategory(categoryNameString);
        if (response.statusCode == 1) {
          refreshCategory();
          //! snack bar showing when refresh category no need to show here
        } else {
          AppSnackBar.errorSnackBar('Error', response.message);
          return;
        }
      } else {
        AppSnackBar.errorSnackBar('Field is Empty', 'Pleas enter valid name');
      }
    }  catch (e) {
      AppSnackBar.errorSnackBar('Error', 'Something Wrong !!');
    } finally {
      categoryNameTD.text = '';
      addCategoryLoading = false;
      addCategoryToggle = false;
      update();
    }
  }

  //////! category section !//////


  //? to delete the food
  deleteCategory({required int catId ,required String catName}) async {
    try {
      //? check user try to delete COMMON category
      if(catName.toUpperCase() != COMMON_CATEGORY){
        isLoadingCategory = true;
        update();
        MyResponse response = await _categoryRepo.deleteCategory(catId);
        if (response.statusCode == 1) {
          refreshCategory();
        } else {
          AppSnackBar.errorSnackBar('Error', response.message);
          return;
        }
      }
      else{
        AppSnackBar.errorSnackBar('Error', 'Cannot delete this category');
      }
    } catch (e) {
      AppSnackBar.errorSnackBar('Error', 'Something wet to wrong');
    } finally {
      isLoadingCategory = false;
      update();
    }
  }

  //? updating the price toggle when toggle btn click
  setPriceToggle(bool val) {
    priceToggle = val;
    update();
  }

  //?to clear value after toggle off
  void clearLoosPrice() {
    if (!priceToggle) {
      fdFullPriceTD.text = '';
      fdThreeBiTwoPrsTD.text = '';
      fdHalfPriceTD.text = '';
      fdQtrPriceTD.text = '';
    }
  }

  //? validate and inserting food
  validateFoodDetails() async {
    try {
      //? checking full price field is empty or not
      if ((fdPriceTD.text.trim() != '' || fdFullPriceTD.text.trim() != '')) {
        var fdIsLoos = 'no';
        var fdCategoryNew = COMMON_CATEGORY;
        double fdPriceNew = 0;
        var fdNameNew = '';
        double fdThreeBiTwoPrsPriceNew = 0;
        double fdHalfPriceNew = 0;
        double fdQtrPriceNew = 0;

        //? full price only
        if (!priceToggle) {
          fdIsLoos = 'no';
          fdPriceNew = fdPriceTD.text == '' ? 0 : double.parse(fdPriceTD.text);
        } else {
          fdIsLoos = 'yes';
          fdPriceNew = fdFullPriceTD.text == '' ? 0 : double.parse(fdFullPriceTD.text);
        }

        fdNameNew = fdNameTD.text;
        fdCategoryNew = selectedCategory == '' ? COMMON_CATEGORY : selectedCategory;
        fdThreeBiTwoPrsPriceNew = fdThreeBiTwoPrsTD.text == '' ? 0 : double.parse(fdThreeBiTwoPrsTD.text);
        fdHalfPriceNew = fdHalfPriceTD.text == '' ? 0 : double.parse(fdHalfPriceTD.text);
        fdQtrPriceNew = fdQtrPriceTD.text == '' ? 0 : double.parse(fdQtrPriceTD.text);

        //? after validation inserting food to dB
        await insertFood(
          file: file,
          fdName: fdNameNew,
          fdCategory: fdCategoryNew,
          fdPrice: fdPriceNew,
          fdThreeBiTwoPrsPrice: fdThreeBiTwoPrsPriceNew,
          fdHalfPrice: fdHalfPriceNew,
          fdQtrPrice: fdQtrPriceNew,
          fdIsLoos: fdIsLoos,
          cookTime: 0,
        );

      } else {
        AppSnackBar.errorSnackBar('Fill the fields!', 'Enter the values in fields!!');
      }
    } catch (e) {
      rethrow;
    } finally {
      hideLoading();
      update();
    }
  }

  //? to insert the food
  insertFood({
    required file,
    required fdName,
    required fdCategory,
    required fdPrice,
    required fdThreeBiTwoPrsPrice,
    required fdHalfPrice,
    required fdQtrPrice,
    required fdIsLoos,
    required cookTime,
  }) async {
    try {
      showLoading();
      MyResponse response = await _foodRepo.insertFood(
        file: file,
        fdName: fdName,
        fdCategory: fdCategory,
        fdPrice: fdPrice,
        fdThreeBiTwoPrsPrice: fdThreeBiTwoPrsPrice,
        fdHalfPrice: fdHalfPrice,
        fdQtrPrice: fdQtrPrice,
        fdIsLoos: fdIsLoos,
        cookTime: cookTime,
      );
      if (response.statusCode == 1) {
        //? to update all food also after adding in new food
        //? no need to refresh today food so new food added as not today food
        _foodData.getAllFoods();
        clearFields();
        setPriceToggle(false);
        AppSnackBar.successSnackBar('Success', response.message);
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

  //? to clear text-field and file after success insert
  clearFields() {
    fdNameTD.text = '';
    fdPriceTD.text = '';
    fdFullPriceTD.text = '';
    fdThreeBiTwoPrsTD.text = '';
    fdHalfPriceTD.text = '';
    fdQtrPriceTD.text = '';
    priceToggle = false;
    file = null;
    update();
  }

  initTxtCtrl() {
    fdNameTD = TextEditingController();
    fdPriceTD = TextEditingController();
    fdFullPriceTD = TextEditingController();
    fdThreeBiTwoPrsTD = TextEditingController();
    fdHalfPriceTD = TextEditingController();
    fdQtrPriceTD = TextEditingController();
    //? category name controller for adding new category
    categoryNameTD = TextEditingController();
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
