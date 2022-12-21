import 'package:get/get.dart';
import 'package:rest_verision_3/screens/report_screen/controller/report_controller.dart';

import '../../../api_data_loader/settled_order_data.dart';

class ReportBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SettledOrderData>(SettledOrderData(), permanent: true);
    Get.lazyPut(() => ReportController());
  }
}