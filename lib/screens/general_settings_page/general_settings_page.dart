import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:rest_verision_3/constants/app_colors/app_colors.dart';
import '../../widget/common_widget/common_text/heading_rich_text.dart';
import '../../widget/settings_page_screen/profile_menu.dart';
import '../login_screen/controller/startup_controller.dart';
import 'controller/general_settings_controller.dart';

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<GeneralSettingsController>(builder: (ctrl) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    5.horizontalSpace,
                    BackButton(onPressed: () => Get.back()),
                    40.horizontalSpace,
                    const HeadingRichText(name: 'General settings'),
                  ],
                ),
                20.verticalSpace,
                ProfileMenu(
                  text: "Change password",
                  icon: Icons.account_circle_rounded,
                  press: () => {},
                ),
                ProfileMenu(
                  text: "Print KOT with bill",
                  icon: Icons.print,
                  press: () {},
                  actionWidget: FlutterSwitch(
                    width: 50,
                    height: 30,
                    activeColor: AppColors.mainColor,
                    value: true,
                    onToggle: (bool value) {

                    },
                  ),
                ),
                ProfileMenu(
                  text: "Show address in bill",
                  icon: Icons.remove_red_eye,
                  press: () {},
                  actionWidget: FlutterSwitch(
                    width: 50,
                    height: 30,
                    activeColor: AppColors.mainColor,
                    value: ctrl.setShowDeliveryAddressInBillToggle,
                    onToggle: (bool value) {
                      ctrl.setShowDeliveryAddressInBillInHive(value);
                      //? to update in general screen controller
                      ctrl.readShowDeliveryAddressInBillFromHive();
                      //? to update in StartupController for global use
                      Get.find<StartupController>().readShowDeliveryAddressInBillFromHive();
                    },
                  ),
                ),
                ProfileMenu(
                  text: "Clear app cache",
                  icon: Icons.clear_all,
                  press: () {},

                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
