import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/routes/route_helper.dart';
import 'package:rest_verision_3/screens/settings_page_screen/controller/settings_controller.dart';
import '../../alerts/change_mode_of_alert/change_mode_of_alert.dart';
import '../../widget/common_widget/common_text/heading_rich_text.dart';
import '../../widget/settings_page_screen/profile_menu.dart';
import '../../widget/settings_page_screen/profile_pic.dart';


class SettingsPageScreen extends StatelessWidget {
  const SettingsPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (ctrl) {
      return SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //? back arrow
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        HeadingRichText(name: 'Settings'),
                      ],
                    ),
                  ),
                ],
              ),

              10.verticalSpace,
              const ProfilePic(),
              20.verticalSpace,
              ProfileMenu(
                text: "My Account",
                icon: Icons.account_circle_rounded,
                press: () => {},
              ),
              ProfileMenu(
                text: "Renew plan",
                icon: Icons.autorenew,
                press: () {},
              ),
              ProfileMenu(
                text: "General",
                icon: Icons.settings,
                press: () {
                  Get.toNamed(RouteHelper.getPreferenceScreen());
                },
              ),
              ProfileMenu(
                text: "Help Center",
                icon: Icons.help,
                press: () {},
              ),
              ProfileMenu(
                text: "Change mode",
                icon: Icons.mode_sharp,
                press: () {
                  changeModeOfAppAlert(context: context);
                },
              ),
              ProfileMenu(
                text: "Log Out",
                icon: Icons.logout,
                press: () {
                    ctrl.logOutFromApp();
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
