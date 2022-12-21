import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/notification_data.dart';
import 'package:rest_verision_3/models/notification_response/notification.dart';
import '../../../check_internet/check_internet.dart';
import '../../../error_handler/error_handler.dart';
import '../../../models/my_response.dart';
import '../../../widget/common_widget/snack_bar.dart';
import '../../login_screen/controller/startup_controller.dart';

class NotificationController extends GetxController {
  final NotificationData _notificationData = Get.find<NotificationData>();
  bool showErr  = Get.find<StartupController>().showErr;
  final ErrorHandler errHandler = Get.find<ErrorHandler>();

  //? for show full screen loading
  bool isLoading = false;


  //? this will store all purchaser from the server
  //? not showing in UI or change
  final List<NotificationModel> _storedNotification = [];

  //? _myPurchaseItem to show in UI
  final List<NotificationModel> _myNotification = [];

  List<NotificationModel> get myNotification => _myNotification;


  @override
  void onInit() async {
    checkInternetConnection();
    getInitialNotification();
    super.onInit();
  }

  @override
  void onClose() async {
    super.onInit();
  }


  //? to load o first screen loading
  getInitialNotification() {

    try {
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedPurchaseItem from NotificationData controller
      if (_notificationData.allNotification.isEmpty) {
        if (kDebugMode) {
          print(_notificationData.allNotification.length);
          print('data loaded from db');
        }
        refreshNotification(showSnack: false);
      } else {
        if (kDebugMode) {
          print('data loaded from Notification data');
        }
        //? load data from variable in this controller
        _storedNotification.clear();
        _storedNotification.addAll(_notificationData.allNotification);
        //? to show full Notification items in UI
        _myNotification.clear();
        _myNotification.addAll(_storedNotification);
      }
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'notification_controller',methodName: 'getInitialNotification()');
      return;
    }
    finally{
      update();
    }
  }

  //? this function will call getNotification() in NotificationData
  //? ad refresh fresh data from server
  refreshNotification({bool showLoad = true, bool showSnack = true}) async {
    try {
      if (showLoad) {
        showLoading();
      }
      MyResponse response = await _notificationData.getAllNotification();
      if (response.statusCode == 1) {
        if (response.data != null) {
          List<NotificationModel> notification = response.data;
          _storedNotification.clear();
          _storedNotification.addAll(notification);
          //? to show full notification item in UI
          _myNotification.clear();
          _myNotification.addAll(_storedNotification);
          if (showSnack) {
            AppSnackBar.successSnackBar('Success', response.message);
          }
        }
      } else {
        if (showSnack) {
          AppSnackBar.errorSnackBar('Error', response.message);
        }
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'notification_controller',methodName: 'refreshNotification()');
      return;
    } finally {
      hideLoading();
      update();
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