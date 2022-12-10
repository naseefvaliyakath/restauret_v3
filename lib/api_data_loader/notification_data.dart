import 'package:get/get.dart';
import 'package:rest_verision_3/models/notification_response/notification.dart';
import 'package:rest_verision_3/models/notification_response/notification_response.dart';
import 'package:rest_verision_3/models/purchase_items/purchase_item.dart';
import 'package:rest_verision_3/models/purchase_items/purchase_item_response.dart';
import 'package:rest_verision_3/repository/notification_repository.dart';
import '../models/my_response.dart';
import '../repository/purchase_item_repository.dart';

class NotificationData extends GetxController {
  final NotificationRepo _notificationRepo = Get.find<NotificationRepo>();
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
          return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
        } else {
          _allNotification.clear();
          _allNotification.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _allNotification, status: 'Success', message:  'Updated successfully');
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
      }
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
    }finally{
      update();
    }

  }



}