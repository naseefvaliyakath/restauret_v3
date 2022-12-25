import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/login_screen/controller/startup_controller.dart';
import 'package:rest_verision_3/screens/report_screen/controller/report_controller.dart';

class HomeScreenReport extends StatelessWidget {
  const HomeScreenReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int appModeNumber = Get.find<StartupController>().appModeNumber ?? 2;
    return GetBuilder<ReportController>(builder: (ctrl) {
      return SafeArea(
          child:
              appModeNumber == 1 ? const Center(child: Text('report')) : const Center(child: Text('not autherizes')));
    });
  }
}
