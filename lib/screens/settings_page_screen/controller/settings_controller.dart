import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/constants/strings/my_strings.dart';
import 'package:rest_verision_3/repository/complaint_repository.dart';
import 'package:rest_verision_3/screens/login_screen/controller/startup_controller.dart';
import 'package:rest_verision_3/screens/today_food_screen/controller/today_food_controller.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../constants/hive_constants/hive_costants.dart';
import '../../../error_handler/error_handler.dart';
import '../../../local_storage/local_storage_controller.dart';
import '../../../models/my_response.dart';
import '../../../routes/route_helper.dart';
import '../../../widget/common_widget/snack_bar.dart';



class SettingsController extends GetxController {
  final MyLocalStorage _myLocalStorage = Get.find<MyLocalStorage>();
  final ComplaintRepo _complaintRepo = Get.find<ComplaintRepo>();
  bool showErr  = Get.find<StartupController>().showErr;
  final ErrorHandler errHandler = Get.find<ErrorHandler>();

  final RoundedLoadingButtonController btnControllerAddComplaint = RoundedLoadingButtonController();

  //? to store the selected complaint type name and showing selected room in drop down (in help)
  List<String> complaintType = COMPLAINT_TYPE;
  String selectedComplaintType = 'Enquiry';

  //?for selecting modes of app from radio buttons (kitchen , waiter , cashier..etc)
  int _groupValueForModes = 1;
  int get groupValueForModes => _groupValueForModes;


  //?application mode number its assigned from shared preferences
  int _appModeNumber = 1;
  int get appModeNumber => _appModeNumber;

  //? credit  amount td
  late TextEditingController complaintTextTD;
  //?   description
  late TextEditingController complaintMobTD;

  @override
  void onInit() async {
    complaintTextTD = TextEditingController();
    complaintMobTD = TextEditingController();
    await getAppModeNumber();
    super.onInit();
  }

  @override
  void onClose() {
    complaintMobTD.dispose();
    complaintTextTD.dispose();
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'settings_controller',methodName: 'getAppModeNumber()');
      return;
    }
  }

  //? to save app mode number in hive if user switched to any mode
  saveAppModeNumberInHive(appModeNumber) {
    try {
      _myLocalStorage.setData(HIVE_APP_MODE_NUMBER, appModeNumber);
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'settings_controller',methodName: 'saveAppModeNumberInHive()');
      return;
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'settings_controller',methodName: 'modeChangeSubmit()');
      return;
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
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'settings_controller',methodName: 'logOutFromApp()');
      return;
    }
  }


  //? to show complaint category in drop down
  updateSelectedComplaintType(String complaintType) {
    selectedComplaintType = complaintType;
    update();
  }


  //?insert credit debit
  Future insertComplaint() async {
    try {
      String phoneGet = '';
      String descriptionGet = '';
      phoneGet = complaintMobTD.text;
      descriptionGet = complaintTextTD.text;
      int phone = int.parse(phoneGet);

      if (descriptionGet.trim() != '' && phoneGet.trim() != '') {
        MyResponse response = await _complaintRepo.insertComplaint(phone,selectedComplaintType,descriptionGet);
        if (response.statusCode == 1) {
          AppSnackBar.successSnackBar('Success', response.message);
          btnControllerAddComplaint.success();
        } else {
          btnControllerAddComplaint.error();
          AppSnackBar.errorSnackBar('Error', response.message);
          return;
        }
      } else {
        btnControllerAddComplaint.error();
        AppSnackBar.errorSnackBar('Field is Empty', 'Pleas enter  name');
      }
    }
    on FormatException {
      AppSnackBar.errorSnackBar('Error', 'Pleas enter a number');
    }

    catch (e) {
      btnControllerAddComplaint.error();
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'settings_controller',methodName: 'insertComplaint()');
      return;
    }
    finally {
      complaintMobTD.text = '';
      complaintTextTD.text = '';
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerAddComplaint.reset();
      });
      update();
    }
  }


}
