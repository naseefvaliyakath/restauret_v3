import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/billing_screen/billing_screen.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';
import 'package:rest_verision_3/screens/billing_screen/pc_billing_screen.dart';

class BillingScreenFrame extends StatelessWidget {
  const BillingScreenFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return GetBuilder<BillingScreenController>(builder: (logic) {
      return Scaffold(
        body: horizontal ? const PcBillingScreen() : const BillingScreen(),
      );
    });
  }
}
