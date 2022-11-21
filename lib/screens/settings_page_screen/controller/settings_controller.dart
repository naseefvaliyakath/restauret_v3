import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/login_screen/controller/startup_controller.dart';
import 'package:rest_verision_3/screens/today_food_screen/controller/today_food_controller.dart';
import '../../../constants/hive_constants/hive_costants.dart';
import '../../../local_storage/local_storage_controller.dart';
import '../../../routes/route_helper.dart';



class SettingsController extends GetxController {
  final MyLocalStorage _myLocalStorage = Get.find<MyLocalStorage>();



  //?for selecting modes of app from radio buttons (kitchen , waiter , cashier..etc)
  int _groupValueForModes = 1;
  int get groupValueForModes => _groupValueForModes;


  //?application mode number its assigned from shared preferences
  int _appModeNumber = 1;
  int get appModeNumber => _appModeNumber;

  @override
  void onInit() async {
    await getAppModeNumber();
    super.onInit();
  }

  @override
  void onClose() {
  }

  //? get value from when user select different modes
  updateModesOfApp(int groupValue) {
    _groupValueForModes = groupValue;
    update();
  }



  //? to get current application mode from startup controller
  getAppModeNumber() async {
    try {
      int? appModeNumberGet = await (_myLocalStorage.readData(HIVE_APP_MODE_NUMBER)) ?? 1;
      _appModeNumber = appModeNumberGet!;
      if (kDebugMode) {
            print('settings app mode number $_appModeNumber');
          }
      //? te set toggle as per mode user already selected
      _groupValueForModes = _appModeNumber;
      update();
    } catch (e) {
      rethrow;
    }
  }

  //? to save app mode number in hive if user switched to any mode
  saveAppModeNumberInHive(appModeNumber) {
    try {
      _myLocalStorage.setData(HIVE_APP_MODE_NUMBER, appModeNumber);
    } catch (e) {
      rethrow;
    }
  }

  modeChangeSubmit(){
    try {
      //? save changed mode number in hive
      saveAppModeNumberInHive(groupValueForModes);
      //? redirecting to mods of app
      if (groupValueForModes == 1) {
        //? TodayFoodController is permanent so not call initState , so manually refresh food and category
        Get.find<TodayFoodController>().refreshTodayFood();
        Get.find<TodayFoodController>().refreshCategory();
        //? update isCashier bool (its used to authorize cashier and waiter)
        Get.find<TodayFoodController>().checkIsCashier();
        Get.offAllNamed(RouteHelper.getHome());
      }
      else if (groupValueForModes == 2) {
        //? when using Get.offNamed() socket has destroying , and socket not working in kitchen mode
        Get.toNamed(RouteHelper.getKitchenModeMainScreen());
      }
      else {
        //? for waiter mode also same HomeView like cashier , only some features disable only
        //? TodayFoodController is permanent so not call initState , so manually refresh food and category
        Get.find<TodayFoodController>().refreshTodayFood();
        Get.find<TodayFoodController>().refreshCategory();
        //? update isCashier bool (its used to authorize cashier and waiter)
        Get.find<TodayFoodController>().checkIsCashier();
        Get.offAllNamed(RouteHelper.getHome());
      }
    }catch(e){
      rethrow;
    }
    finally{
      //? update data from hive , else need to restart app to get app mode number from hive to _appModeNumber variable
      getAppModeNumber();
    }

  }

  //? to logOut from app
  logOutFromApp() {
    try {
      //? clearing login information of shop in hive and clear app mode number
      _myLocalStorage.removeData(HIVE_APP_MODE_NUMBER);
      _myLocalStorage.removeData(HIVE_SHOP_DETAILS);
      Get.find<StartupController>().showLoginScreen();
      Get.find<StartupController>().subIdTD.text ='';
      Get.offAllNamed(RouteHelper.getInitial());
    } catch (e) {
      rethrow;
    }
  }



}
