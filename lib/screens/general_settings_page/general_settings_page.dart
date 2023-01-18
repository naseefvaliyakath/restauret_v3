import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/constants/app_colors/app_colors.dart';
import '../../alerts/change_password_prompt_alert/change_password_prompt_to_cashier_alert.dart';
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
        bool horizontal = 1.sh < 1.sw ? true : false;
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
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: horizontal ? 100.w : 0),
                    child: Column(
                      children: [
                        20.verticalSpace,
                        Visibility(
                          visible: Get.find<StartupController>().applicationPlan == 1 ? true : false,
                          child: ProfileMenu(
                            text: "Change password",
                            icon: Icons.password,
                            press: () => {
                              changePasswordPromptToCashierMode(context: context)
                            },
                          ),
                        ),
                        ProfileMenu(
                          text: "Show address in bill",
                          icon: Icons.remove_red_eye,
                          press: () {},
                          actionWidget: FlutterSwitch(
                            width: 50.sp,
                            height: 30.sp,
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
                          text: "Allow credit book to waiter",
                          icon: Icons.wallet,
                          press: () {},
                          actionWidget: FlutterSwitch(
                            width: 50.sp,
                            height: 30.sp,
                            activeColor: AppColors.mainColor,
                            value: ctrl.setAllowCreditBookToWaiterToggle,
                            onToggle: (bool value) {
                              ctrl.setAllowCreditBookToWaiter(value);
                            },
                          ),
                        ),
                        ProfileMenu(
                          text: "Allow purchase book to waiter",
                          icon: Icons.store_outlined,
                          press: () {},
                          actionWidget: FlutterSwitch(
                            width: 50.sp,
                            height: 30.sp,
                            activeColor: AppColors.mainColor,
                            value: ctrl.setAllowPurchaseBookToWaiterToggle,
                            onToggle: (bool value) {
                              ctrl.setAllowPurchaseBookToWaiter(value);
                            },
                          ),
                        ),
                        ProfileMenu(
                          text: "Advanced table management",
                          icon: Icons.table_bar_sharp,
                          press: () {},
                          actionWidget: FlutterSwitch(
                            width: 50.sp,
                            height: 30.sp,
                            activeColor: AppColors.mainColor,
                            value: ctrl.advancedTableManagement,
                            onToggle: (bool value) {
                              ctrl.setAdvancedTableManagement(value);
                            },
                          ),
                        ),
                        ProfileMenu(
                          text: "Show Error",
                          icon: Icons.error_outline,
                          press: () {},
                          actionWidget: FlutterSwitch(
                            width: 50.sp,
                            height: 30.sp,
                            activeColor: AppColors.mainColor,
                            value: ctrl.setShowErrorToggle,
                            onToggle: (bool value) {
                              ctrl.setShowError(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
