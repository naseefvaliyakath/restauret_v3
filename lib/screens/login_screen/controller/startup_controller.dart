import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/models/shop_response/shop.dart';
import 'package:rest_verision_3/models/shop_response/shop_response.dart';
import 'package:rest_verision_3/routes/route_helper.dart';
import 'package:rest_verision_3/widget/common_widget/snack_bar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../constants/hive_constants/hive_costants.dart';
import '../../../local_storage/local_storage_controller.dart';
import '../../../models/my_response.dart';
import '../../../repository/startup_repository.dart';

class StartupController extends GetxController {
  final MyLocalStorage _myLocalStorage = Get.find<MyLocalStorage>();
  final StartupRepo _startupRepo = Get.find<StartupRepo>();

  final RoundedLoadingButtonController btnControllerLogin = RoundedLoadingButtonController();
  final RoundedLoadingButtonController btnControllerPasswordPrompt = RoundedLoadingButtonController();
  final RoundedLoadingButtonController btnControllerChangePasswordPrompt = RoundedLoadingButtonController();


  //?application mode number its assigned from shared preferences
  int _appModeNumber = 1;

  int get appModeNumber => _appModeNumber;

  int SHOPE_ID = -1;
  String shopName = 'Restaurant';
  int shopNumber = 0000;
  String shopAddr = 'error';
  String subcId = '0000';

  //?  to hide login page while starting app normally
  //? els a small second login screen is showing
  bool showLogin = false;

  //? text-editing controllers
  late TextEditingController subIdTD;
  late TextEditingController passTd;
  late TextEditingController newPassTd;

  //? to get store get ShowDeliveryAddressInBill boll status
  bool setShowDeliveryAddressInBillToggle = true;

  @override
  void onInit() async {
    subIdTD = TextEditingController();
    passTd = TextEditingController();
    newPassTd = TextEditingController();
    await checkLoginAndAppMode();
    readShowDeliveryAddressInBillFromHive();
    super.onInit();
  }

  loginToApp() async {
    try {
      Shop shop = await getShop(subIdTD.text);
      await setShopInHive(shop);

      if (shop.fdShopId != -1) {
            btnControllerLogin.success();
            Future.delayed(const Duration(milliseconds: 500), () {
              //? setting app mode 1
              resetAppModeNumberInHive();
              Get.offAllNamed(RouteHelper.getHome());
            });
          } else {
            btnControllerLogin.error();
            AppSnackBar.errorSnackBar('Error', 'Cannot login to app !!');

          }
    } catch (e) {
      btnControllerLogin.error();
      rethrow;
    } finally {
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerLogin.reset();
      });
    }
  }

  //? get the full shop details when user press submit ntn when login
  Future<Shop> getShop(String subscId) async {
    try {
      MyResponse response = await _startupRepo.getShopDetails(subscId);

      if (response.statusCode == 1) {
        ShopResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          return Shop(-1, 'error', 0000, 'error', '0000', '0000');
        } else {
          Shop shop = parsedResponse.data ?? Shop(-1, 'error', 0000, 'error', '0000', '0000');
          return shop;
        }
      } else {
        return Shop(-1, 'error', 0000, 'error', '0000', '0000');
      }
    } catch (e) {
      rethrow;
    }
  }

  //? to check  mode of app in every launching
  Future<int> readAppModeInHive() async {
    try {
      int appModeNumberGet = await _myLocalStorage.readData(HIVE_APP_MODE_NUMBER) ?? 1;
      _appModeNumber = appModeNumberGet!;
      if (kDebugMode) {
        print('application mode $_appModeNumber');
      }
      update();
      return appModeNumberGet;

    } catch (e) {
      rethrow;
    }
  }

  //? to set shop details in local db when user login first time
  Future setShopInHive(Shop shop) async {
    try {
      int fdShopId_ = shop.fdShopId ?? -1;
      String shopName_ = shop.shopName ?? 'Restaurant';
      int shopNumber_ = shop.shopNumber ?? 0000;
      String shopAddr_ = shop.shopAddr ?? 'error';
      String subcId_ = shop.subcId ?? '0000';

      Map<String, dynamic> shopToHive = {
        'fdShopId': fdShopId_,
        'shopName': shopName_,
        'shopNumber': shopNumber_,
        'shopAddr': shopAddr_,
        'subcId': subcId_,
      };
      await _myLocalStorage.setData(HIVE_SHOP_DETAILS, shopToHive);
      //? after saving retrieving details to variable to future use
      Map<dynamic, dynamic>? shopDetails = await _myLocalStorage.readData(HIVE_SHOP_DETAILS);
      if (shopDetails != null) {
        SHOPE_ID = shopDetails['fdShopId'] ?? -1;
        shopName = shopDetails['shopName'] ?? 'Restaurant';
        shopNumber = shopDetails['shopNumber'] ?? 0000;
        shopAddr = shopDetails['shopAddr'] ?? 'error';
        subcId = shopDetails['subcId'] ?? '0000';
      }
      if (kDebugMode) {
        print('Shop name $shopName');
      }
      update();
    } catch (e) {
      rethrow;
    }
  }

  //? to check user is longed in or not
  Future readShopDetailsFromHive() async {
    try {
      Map<dynamic, dynamic>? shopDetails = await _myLocalStorage.readData(HIVE_SHOP_DETAILS);

      if (shopDetails != null) {
        SHOPE_ID = shopDetails['fdShopId'];
        shopName = shopDetails['shopName'];
        shopNumber = shopDetails['shopNumber'];
        shopAddr = shopDetails['shopAddr'];
        subcId = shopDetails['subcId'];
        if (kDebugMode) {
          print('shop log in  in as name $shopName - id $shopName - subId $SHOPE_ID');
        }
        //? user is already log in then check witch mode od user
        if (SHOPE_ID != -1) {
          //? check app mode and redirect
            if (_appModeNumber == 2) {
            Get.offAllNamed(RouteHelper.getKitchenModeMainScreen());
          }
          else {
            Get.offAllNamed(RouteHelper.getHome());
          }
        }
      }
      //? user not log in yet
      else {
        if (kDebugMode) {
          print('not login');
        }
        showLogin = true;
      }

      update();
    } catch (e) {
      rethrow;
    }
  }

  //? reset appMode in to cashier or  setting app mode 1
  resetAppModeNumberInHive() {
    try {
      _myLocalStorage.setData(HIVE_APP_MODE_NUMBER, 1);
    } catch (e) {
      rethrow;
    }
  }

  //? this will only call app launching because controller ios permanent
  checkLoginAndAppMode() async {
    await readAppModeInHive();
    await readShopDetailsFromHive();
  }

  //? this will call when logout from app then it make showLogin = true
  //?  else it will false (controller is permanent , so it will not destroy)
  showLoginScreen() {
    showLogin = true;
    update();
  }

  Future<bool> checkPassword() async {
    try {
    if(passTd.text.trim() != '')
      {
        MyResponse response = await _startupRepo.getShopDetails(subcId);
        if (response.statusCode == 1) {
          ShopResponse parsedResponse = response.data;
          if (parsedResponse.data == null) {
            AppSnackBar.errorSnackBar('Error', 'Something went wrong !!');
            return false;
          } else {
            Shop shop = parsedResponse.data ?? Shop(-1, 'error', 0000, 'error', '0000', '0000');
            if(shop.password == passTd.text){
              btnControllerPasswordPrompt.success();
              return true;
            }
            else{
              AppSnackBar.errorSnackBar('Error', 'wrong password !!');
              btnControllerPasswordPrompt.error();
              return false;
            }

          }
        } else {
          AppSnackBar.errorSnackBar('Error', 'Something went wrong !!');
          btnControllerPasswordPrompt.error();
          return false;
        }
      }
    else{
      AppSnackBar.errorSnackBar('Error', 'pleas fill the field !!');
      return false;
    }
    } catch (e) {
      AppSnackBar.errorSnackBar('Error', 'Something went wrong !!');
      btnControllerPasswordPrompt.error();
      rethrow;
    }
    finally{
      passTd.text = '';
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerPasswordPrompt.reset();
      });
      update();
    }
  }

  Future<bool> changePassword() async {
    try {
      if(passTd.text.trim() != '')
      {
        MyResponse response = await _startupRepo.getShopDetails(subcId);
        if (response.statusCode == 1) {
          ShopResponse parsedResponse = response.data;
          if (parsedResponse.data == null) {
            AppSnackBar.errorSnackBar('Error', 'Something went wrong !!');
            return false;
          } else {
            Shop shop = parsedResponse.data ?? Shop(-1, 'error', 0000, 'error', '0000', '0000');
            if(shop.password == passTd.text){
              btnControllerPasswordPrompt.success();
              return true;
            }
            else{
              AppSnackBar.errorSnackBar('Error', 'wrong password !!');
              btnControllerPasswordPrompt.error();
              return false;
            }

          }
        } else {
          AppSnackBar.errorSnackBar('Error', 'Something went wrong !!');
          btnControllerPasswordPrompt.error();
          return false;
        }
      }
      else{
        AppSnackBar.errorSnackBar('Error', 'pleas fill the field !!');
        return false;
      }
    } catch (e) {
      AppSnackBar.errorSnackBar('Error', 'Something went wrong !!');
      btnControllerPasswordPrompt.error();
      rethrow;
    }
    finally{
      passTd.text = '';
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerPasswordPrompt.reset();
      });
      update();
    }
  }

  //? to get store get ShowDeliveryAddressInBill boll status
  Future<bool> readShowDeliveryAddressInBillFromHive() async {
    try {

      bool result = await _myLocalStorage.readData(HIVE_SHOW_ADDRESS_IN_BILL) ?? true;
      setShowDeliveryAddressInBillToggle = result;
      update();
      return result;
    } catch (e) {
      rethrow;
    }
  }

}
