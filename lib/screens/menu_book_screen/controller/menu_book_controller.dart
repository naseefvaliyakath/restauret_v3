import 'dart:io';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../api_data_loader/food_data.dart';
import '../../../check_internet/check_internet.dart';
import '../../../constants/hive_constants/hive_costants.dart';
import '../../../constants/strings/my_strings.dart';
import '../../../error_handler/error_handler.dart';
import '../../../local_storage/local_storage_controller.dart';
import '../../../models/foods_response/foods.dart';
import '../../../models/my_response.dart';
import '../../../repository/food_repository.dart';
import '../../../widget/common_widget/snack_bar.dart';
import '../../login_screen/controller/startup_controller.dart';

class MenuBookController extends GetxController {
  //?controllers
  final FoodData _foodData = Get.find<FoodData>();
  final FoodRepo _foodRepo = Get.find<FoodRepo>();
  final MyLocalStorage _myLocalStorage = Get.find<MyLocalStorage>();
  bool showErr  = Get.find<StartupController>().showErr;
  final ErrorHandler errHandler = Get.find<ErrorHandler>();


  //? this will store all AllFood from the server
  //? not showing in UI or change
  final List<Foods> _storedAllFoods = [];

  //? today food to show in UI
  final List<Foods> _myAllFoods = [];

  List<Foods> get myAllFoods => _myAllFoods;



  //? to sort special food
  List<Foods> specialFoods = [];
  //? to store food by category
  Set keys = {};
  List<Map<String, dynamic>> foodsByCategory = [];


  //? for show full screen loading
  bool isLoading = false;


  //? to sort food as per category
  String selectedCategory = COMMON_CATEGORY;

  //? to authorize cashier and waiter
  bool isCashier = false;
  int shopId = Get.find<StartupController>().SHOPE_ID;
  String shopName = Get.find<StartupController>().shopName;
  String menuBookUrl = 'https://mobizate.com/menuBook/getAllFoodForMenu';



  //? to share qr code
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void onInit() async {
    await checkIsCashier();
    checkInternetConnection();
    getInitialFood();
    super.onInit();
  }

  @override
  void onClose() async {
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
        sortingFood(_myAllFoods);
      }
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'menu_book_controller',methodName: 'getInitialFood()');
      return;
    }
  }


  //? to add food in available
  updateAvailableFood(int fdId, String isAvailable) async {
    try {
      showLoading();
      MyResponse response = await _foodRepo.updateAvailableFood(fdId, isAvailable);
      if (response.statusCode == 1) {
        refreshAllFood();
        //! success message shown in refreshAllFood() method
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
        return;
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'menu_book_controller',methodName: 'updateAvailableFood()');
      return;
    } finally {
      hideLoading();
      update();
    }
  }

  //? to add food in special
  updateSpecialFood(int fdId, String isSpecial) async {
    try {
      showLoading();
      MyResponse response = await _foodRepo.updateSpecialFood(fdId, isSpecial);
      if (response.statusCode == 1) {
        refreshAllFood();
        //! success message shown in refreshAllFood() method
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
        return;
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'menu_book_controller',methodName: 'updateSpecialFood()');
      return;
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
         sortingFood(_myAllFoods);
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
     errHandler.myResponseHandler(error: e.toString(),pageName: 'menu_book_controller',methodName: 'refreshAllFood()');
     return;
   }finally{
     update();
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
      errHandler.myResponseHandler(error: e.toString(),pageName: 'menu_book_controller',methodName: 'checkIsCashier()');
      return;
    }
  }

  sortingFood(List<Foods> myAllFoods) async {
    try {

      //? sorting special food
      for (var element in myAllFoods) {
            if (element.fdIsSpecial == 'yes') {
              specialFoods.add(element);
            }
          }

      //? sorting food by category
      for (var element in myAllFoods) {
            if (keys.contains(element.fdCategory)) {
              int index = keys.toList().indexOf(element.fdCategory);
              foodsByCategory[index]['products'] = foodsByCategory[index]['products'] + [element];
            } else {
              foodsByCategory.add({
                'title': element.fdCategory,
                'products': [element]
              });
              keys.add(element.fdCategory);
            }
          }


      //? Moving "common to last"
      int idOfCOMMON = keys.toList().indexOf('common');
      if(idOfCOMMON!=-1){
            Map<String, dynamic> temp = foodsByCategory[idOfCOMMON];
            foodsByCategory.removeAt(idOfCOMMON);
            foodsByCategory.add(temp);
          }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'menu_book_controller',methodName: 'sortingFood()');
      return;
    }
  }




  shareQrCode() async {
    try {
      await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((image) async {
            if (image != null) {
              final directory = await getApplicationDocumentsDirectory();
              final imagePath = await File('${directory.path}/image.png').create();
              await imagePath.writeAsBytes(image);
              await Share.shareFiles([imagePath.path]);
            }
          });
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'menu_book_controller',methodName: 'shareQrCode()');
      return;
    }
  }

  String menuBookUrlGenerated(){
    try {
      String shopNameNoSpace = shopName.replaceAll(' ', '%20');
      String url = '$menuBookUrl?fdShopId=$shopId&shopName=$shopNameNoSpace';
      return url;
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'menu_book_controller',methodName: 'menuBookUrlGenerated()');
      return 'error';
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
