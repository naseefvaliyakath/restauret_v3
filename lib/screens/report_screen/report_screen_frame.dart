import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/report_screen/pc_report_screen.dart';
import 'package:rest_verision_3/screens/report_screen/report_screen.dart';

import 'controller/report_controller.dart';

class ReportScreenFrame extends StatelessWidget {
  const ReportScreenFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (logic) {
      bool horizontal = 1.sh < 1.sw ? true : false;
      return Scaffold(body: horizontal ? const PcReportScreen() : const ReportScreen());
    });
  }
}
