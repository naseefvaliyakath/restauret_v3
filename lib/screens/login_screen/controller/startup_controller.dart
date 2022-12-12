import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rest_verision_3/models/notice_and_update/notice_and_update.dart';
import 'package:rest_verision_3/models/notice_and_update/notice_and_update_response.dart';
import 'package:rest_verision_3/models/shop_response/shop.dart';
import 'package:rest_verision_3/models/shop_response/shop_response.dart';
import 'package:rest_verision_3/routes/route_helper.dart';
import 'package:rest_verision_3/widget/common_widget/snack_bar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../alerts/update_notice_alert/update_notice_alert.dart';
import '../../../constants/hive_constants/hive_costants.dart';
import '../../../constants/strings/my_strings.dart';
import '../../../local_storage/local_storage_controller.dart';
import '../../../models/my_response.dart';
import '../../../printer/controller/library/iosWinPrint.dart';
import '../../../repository/startup_repository.dart';
import '../../settings_page_screen/controller/settings_controller.dart';

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
  String subcIdStatus = 'Deactivate';
  DateTime expiryDate = DateTime.now();
  String logoImg = 'https://mobizate.com/uploadsOnlineApp/logo_hotel.png';

  //?  to hide login page while starting app normally
  //? els a small second login screen is showing
  bool showLogin = false;

  //? text-editing controllers
  late TextEditingController subIdTD;
  late TextEditingController passTd;
  late TextEditingController newPassTd;

  //? to get store get ShowDeliveryAddressInBill boll status
  bool setShowDeliveryAddressInBillToggle = true;

  //? to set toggle btn as per saved data
  bool setAllowCreditBookToWaiterToggle = false;

  //? to set toggle btn as per saved data
  bool setAllowPurchaseBookToWaiterToggle = false;

  @override
  void onInit() async {
    subIdTD = TextEditingController();
    passTd = TextEditingController();
    newPassTd = TextEditingController();
    await checkLoginAndAppMode();
    await readShowDeliveryAddressInBillFromHive();
    await readAllowCreditBookToWaiterFromHive();
    await readAllowPurchaseBookToWaiterFromHive();
    checkNoticeAndUpdate();
    _initBtPrinter();
    super.onInit();
  }

  _initBtPrinter() async {
    //Connect Bt printer
    IosWinPrint iOSWinPrintInstance = IosWinPrint();
    await iOSWinPrintInstance.getDevices();

    BluetoothPrinter? bluetoothPrinter =  IosWinPrint.getSelectedDevice();
    if(bluetoothPrinter!=null){
      await iOSWinPrintInstance.connectBtPrinter(bluetoothPrinter: bluetoothPrinter);
    }else{
      if (kDebugMode) {
        print('No device selected');
      }
    }
  }

  loginToApp() async {
    try {
      Shop shop = await getShop(subIdTD.text);

      if (shop.fdShopId != -1) {
        if (shop.subcIdStatus == 'Active') {
          await setShopInHive(shop);
          btnControllerLogin.success();
          Future.delayed(const Duration(milliseconds: 500), () {
            //? setting app mode 1
            resetAppModeNumberInHive();
            Get.offAllNamed(RouteHelper.getHome());
          });
        }
        else {
          AppSnackBar.errorSnackBar('Expired', 'Your subscription has expired');
        }
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
          return EMPTY_SHOP;
        } else {
          Shop shop = parsedResponse.data ?? EMPTY_SHOP;
          return shop;
        }
      } else {
        return EMPTY_SHOP;
      }
    } catch (e) {
      rethrow;
    }
  }

  //? to check  mode of app in every launching
  Future<int> readAppModeInHive() async {
    try {
      int appModeNumberGet = await _myLocalStorage.readData(HIVE_APP_MODE_NUMBER) ?? 1;
      _appModeNumber = appModeNumberGet;
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
      String subcIdStatus_ = shop.subcIdStatus ?? 'Deactivate';
      DateTime expiryDate_ = shop.expiryDate ?? DateTime.now();
      String logoImg_ = shop.logoImg ?? 'https://mobizate.com/uploadsOnlineApp/logo_hotel.png';

      Map<String, dynamic> shopToHive = {
        'fdShopId': fdShopId_,
        'shopName': shopName_,
        'shopNumber': shopNumber_,
        'shopAddr': shopAddr_,
        'subcId': subcId_,
        'subcIdStatus': subcIdStatus_,
        'expiryDate': expiryDate_,
        'logoImg': logoImg_,
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
        subcIdStatus = shopDetails['subcIdStatus'] ?? 'Deactivate';
        expiryDate = shopDetails['expiryDate'] ?? DateTime.now();
        logoImg = shopDetails['logoImg'] ?? 'https://mobizate.com/uploadsOnlineApp/logo_hotel.png';
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
        SHOPE_ID = shopDetails['fdShopId'] ?? -1;
        shopName = shopDetails['shopName'] ?? 'error';
        shopNumber = shopDetails['shopNumber'] ?? 0000;
        shopAddr = shopDetails['shopAddr'] ?? 'error';
        subcId = shopDetails['subcId'] ?? 0000;
        expiryDate = shopDetails['expiryDate'] ?? DateTime.now();
        logoImg = shopDetails['logoImg'] ?? 'https://mobizate.com/uploadsOnlineApp/logo_hotel.png';
        if (kDebugMode) {
          print('shop log in  in as name $shopName - id $shopName - subId $SHOPE_ID');
        }
        //? user is already log in then check witch mode od user
        if (SHOPE_ID != -1) {
          //? check app mode and redirect
          if (_appModeNumber == 2) {
            Get.offAllNamed(RouteHelper.getKitchenModeMainScreen());
          } else {
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
      if (passTd.text.trim() != '') {
        MyResponse response = await _startupRepo.getShopDetails(subcId);
        if (response.statusCode == 1) {
          ShopResponse parsedResponse = response.data;
          if (parsedResponse.data == null) {
            AppSnackBar.errorSnackBar('Error', 'Something went wrong !!');
            return false;
          } else {
            Shop shop = parsedResponse.data ?? EMPTY_SHOP;
            if (shop.password == passTd.text) {
              btnControllerPasswordPrompt.success();
              return true;
            } else {
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
      } else {
        AppSnackBar.errorSnackBar('Error', 'pleas fill the field !!');
        return false;
      }
    } catch (e) {
      AppSnackBar.errorSnackBar('Error', 'Something went wrong !!');
      btnControllerPasswordPrompt.error();
      rethrow;
    } finally {
      passTd.text = '';
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerPasswordPrompt.reset();
      });
      update();
    }
  }

  changePassword({
    required BuildContext context,
    required String subcId,
    required int fdShopId,
    required String password,
    required String newPassword,
  }) async {
    try {
      if (passTd.text.trim() != '') {
        MyResponse response = await _startupRepo.changePassword(subcId, fdShopId, password, newPassword);
        if (response.statusCode == 1) {
          AppSnackBar.successSnackBar('Success', 'Updated successfully');
          btnControllerPasswordPrompt.success();
          Navigator.pop(context);
        } else {
          AppSnackBar.errorSnackBar('Error', 'Something went wrong !!');
          btnControllerPasswordPrompt.error();
        }
      } else {
        AppSnackBar.errorSnackBar('Error', 'pleas fill the field !!');
      }
    } catch (e) {
      AppSnackBar.errorSnackBar('Error', 'Something went wrong !!');
      btnControllerPasswordPrompt.error();
      rethrow;
    } finally {
      passTd.text = '';
      newPassTd.text = '';
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerPasswordPrompt.reset();
      });
      update();
    }
  }

  //? to get store get ShowDeliveryAddressInBill boll status as global
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

  //? to get store get PurchaseBookToWaiter boll status as global
  Future<bool> readAllowPurchaseBookToWaiterFromHive() async {
    try {
      bool result = await _myLocalStorage.readData(ALLOW_PURCHASE_BOOK_TO_WAITER) ?? false;
      setAllowPurchaseBookToWaiterToggle = result;
      update();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> readAllowCreditBookToWaiterFromHive() async {
    try {
      bool result = await _myLocalStorage.readData(ALLOW_CREDIT_BOOK_TO_WAITER) ?? false;
      setAllowCreditBookToWaiterToggle = result;
      update();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  //? get the full shop details when user press submit ntn when login
  Future<NoticeAndUpdate> getNotice() async {
    try {
      MyResponse response = await _startupRepo.getNoticeAndUpdate();

      if (response.statusCode == 1) {
        NoticeAndUpdateResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          return EMPTY_NOTICE_UPDATE;
        } else {
          NoticeAndUpdate noticeAndUpdate = parsedResponse.data ?? EMPTY_NOTICE_UPDATE;
          return noticeAndUpdate;
        }
      } else {
        return EMPTY_NOTICE_UPDATE;
      }
    } catch (e) {
      rethrow;
    }
  }

  setNoticeInHive(NoticeAndUpdate noticeAndUpdate,String versionCode, DateTime lastShowingTime) async {
    try {
      Map<String, dynamic> noticeToHive = {
        'noticeUpdateId': noticeAndUpdate.noticeUpdateId,
        'nextShowingDate': noticeAndUpdate.nextShowingDate,
        'lastGetUpdateVersion': versionCode,
        'timeLastShowing': lastShowingTime,
      };
      await _myLocalStorage.setData(HIVE_NOTICE_UPDATE_DETAILS, noticeToHive);
    } catch (e) {
      return;
    }
  }

  Future<Map> readNoticeFromHive() async {
    try {
      Map<dynamic, dynamic> noticeDetails =
          await _myLocalStorage.readData(HIVE_NOTICE_UPDATE_DETAILS) ?? {'noticeUpdateId': -1, 'nextShowingDate': 365};
      return noticeDetails;
    } catch (e) {
      return {'noticeUpdateId': -1, 'nextShowingDate': 365};
    }
  }

  checkNoticeAndUpdate() async {
    NoticeAndUpdate newNotice = await getNotice();
    print('object ${newNotice.type}');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    getExtendedVersionNumber(version);

    Map<dynamic, dynamic> noticeFromHive = await readNoticeFromHive();
    //? checking successfully received data from server
    if (newNotice.noticeUpdateId != null && newNotice.noticeUpdateId != -1) {
      //? checking its notice or update
      if (newNotice.type == 'notice') {
        //? checking notice id is grater , then only it showing
        if (newNotice.noticeUpdateId! > (noticeFromHive['noticeUpdateId'])) {
          setNoticeInHive(newNotice,'0.0.0', DateTime.now());
          showKNoticeUpdateAlert(
            message: newNotice.message ?? 'Something went wrong',
            context: Get.context!,
            type: newNotice.type ?? 'notice',
            noticeAndUpdate: newNotice,
          );
        }
      }
      //? checking if its update
      if (newNotice.type == 'update') {
        //? checking inside platform device platform is containing
        if (newNotice.platform!.contains(Platform.operatingSystem)) {
          String versionCodeGet = Platform.isIOS ? ((newNotice.version?[0]) ?? '0.0.0') : Platform.isAndroid
              ? ((newNotice.version?[1]) ?? '0.0.0')
              : ((newNotice.version?[2]) ?? '0.0.0');

            if (kDebugMode) {
              print('versionCodeGet $versionCodeGet');
            }

        //? checking app version is grater  then current user is not updated new version
        if (getExtendedVersionNumber(versionCodeGet) > getExtendedVersionNumber(version)) {
          //? checking pop up already showing before
          if (noticeFromHive['lastGetUpdateVersion'] == versionCodeGet) {
            //? daysBeforeShowing is used to prevent continues popup in next day , its showing only after second day in array
            int daysBeforeShowing = DateTime
                .now()
                .difference(newNotice.createdAt ?? DateTime.now())
                .inDays;
            //? lastShowingTime is used to prevent continues popup in same day
            DateTime lastShowingTime = noticeFromHive['timeLastShowing'] ?? DateTime.now();
            int differenceOfTimeLastShowing = DateTime
                .now()
                .difference(lastShowingTime)
                .inMinutes;
            if (kDebugMode) {
              print('daysBeforeShowing $daysBeforeShowing');
              print('differenceOfTimeLastShowing $differenceOfTimeLastShowing');
            }
            //? loop out array of days , then showing if that day exceeded
            for (var element in newNotice.nextShowingDate!) {
              if (element == daysBeforeShowing) {
                //? next popup showing only after one hour
                if (differenceOfTimeLastShowing > 120) {
                  print('new ver $versionCodeGet}');
                  setNoticeInHive(newNotice,versionCodeGet, DateTime.now());
                  showKNoticeUpdateAlert(
                    message: newNotice.message ?? 'Something went wrong',
                    context: Get.context!,
                    type: newNotice.type ?? 'notice',
                    noticeAndUpdate: newNotice,
                  );
                }
              }
            }
          }
          else {
            setNoticeInHive(newNotice,versionCodeGet, DateTime.now());
            showKNoticeUpdateAlert(
              message: newNotice.message ?? 'Something went wrong',
              context: Get.context!,
              type: newNotice.type ?? 'notice',
              noticeAndUpdate: newNotice,
            );
          }
        }
      }

  }

  }
  }

  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }

  setIntervalCount(int intervalCount) async {
    try {
      await Get.find<MyLocalStorage>().setData(INTERVEL_COUNT_TO_CALL_EXPAIRY, intervalCount);
    } catch (e) {
      return;
    }
  }


  Future<int> readIntervalCount() async {
    try {
      int intervalCount = await Get.find<MyLocalStorage>().readData(INTERVEL_COUNT_TO_CALL_EXPAIRY) ?? 1;
      return intervalCount;
    } catch (e) {
      rethrow;
    }
  }

  //? this function val return int , and its incriment in evry count and reset after 15
  //? so we can call function to server without continues every time , its to avoid server load
  ///? used to log out app
  Future<int> getIntervalCount() async {
    try {
      int intervalCount = await Get.find<MyLocalStorage>().readData(INTERVEL_COUNT_TO_CALL_EXPAIRY) ?? 1;
      intervalCount = intervalCount > 15 ? 0 : intervalCount + 1;
      await Get.find<MyLocalStorage>().setData(INTERVEL_COUNT_TO_CALL_EXPAIRY, intervalCount);
      return intervalCount;
    } catch (e) {
      rethrow;
    }
  }

  checkSubscriptionStatusToLogout() async {
    int count = await getIntervalCount();
    if (count > 15) {
      Shop shop = await getShop(Get
          .find<StartupController>()
          .subcId);
      if (shop.subcIdStatus != 'Active') {
        Get.find<SettingsController>().logOutFromApp();
      }
    }
  }

}
