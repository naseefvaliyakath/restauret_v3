import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/notification_data.dart';
import 'package:rest_verision_3/api_data_loader/purchase_item_data.dart';
import 'package:rest_verision_3/repository/purchase_item_repository.dart';
import 'package:rest_verision_3/screens/notification_screen/controller/notification_controller.dart';
import 'package:rest_verision_3/screens/purchase_book_screen/controller/purchase_book_controller.dart';

class NotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<NotificationData>(NotificationData(), permanent: true);
    Get.lazyPut(() => NotificationController());
  }
}
