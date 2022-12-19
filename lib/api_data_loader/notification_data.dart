import 'package:get/get.dart';
import 'package:rest_verision_3/models/notification_response/notification.dart';
import 'package:rest_verision_3/models/notification_response/notification_response.dart';
import 'package:rest_verision_3/repository/notification_repository.dart';
import '../error_handler/error_handler.dart';
import '../models/my_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';


class NotificationData extends GetxController {
  final NotificationRepo _notificationRepo = Get.find<NotificationRepo>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr  = Get.find<StartupController>().showErr;

  //? to store notification
  final List<NotificationModel> _allNotification = [];
  List<NotificationModel> get allNotification => _allNotification;

  @override
  Future<void> onInit() async {
    super.onInit();
  }


  Future<MyResponse> getAllNotification() async {
    try {
      MyResponse response = await _notificationRepo.getAllNotification();

      if (response.statusCode == 1) {
        NotificationResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allNotification;
          return MyResponse(statusCode: 0, status: 'Error', message: response.message);
        } else {
          _allNotification.clear();
          _allNotification.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _allNotification, status: 'Success', message:  response.message);
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message: response.message);
      }
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'notificationData',methodName: 'getAllNotification()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }finally{
      update();
    }

  }



}