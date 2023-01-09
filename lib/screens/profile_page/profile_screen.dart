import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rest_verision_3/routes/route_helper.dart';
import 'package:rest_verision_3/screens/login_screen/controller/startup_controller.dart';
import 'package:rest_verision_3/screens/settings_page_screen/controller/settings_controller.dart';
import '../../widget/common_widget/common_text/heading_rich_text.dart';
import '../../widget/settings_page_screen/profile_menu.dart';
import '../../widget/settings_page_screen/profile_pic.dart';


class ProfilePageScreen extends StatelessWidget {
  const ProfilePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GetBuilder<SettingsController>(builder: (ctrl) {
        bool horizontal = 1.sh < 1.sw ? true : false;
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Padding(
                            padding:  EdgeInsets.only(left:5.sp),
                            child: BackButton(
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                          const HeadingRichText(name: 'My Account'),
                          Padding(
                            padding:  EdgeInsets.only(right:10.sp),
                            child: IconButton(
                                onPressed: () {
                                  Get.toNamed(RouteHelper.getNotificationScreen());
                                },
                                icon: Icon(
                                  FontAwesomeIcons.bell,
                                  size: 24.sp,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: horizontal ? 100.w : 0),
                  child: Column(
                    children: [
                      10.verticalSpace,
                      const ProfilePic(),
                      20.verticalSpace,
                      ProfileMenu(
                        text: Get.find<StartupController>().shopName,
                        icon: Icons.account_circle_rounded,
                        actionWidget: const SizedBox(),
                        press: () => {},
                      ),
                      ProfileMenu(
                        text: Get.find<StartupController>().shopNumber.toString(),
                        icon: Icons.phone,
                        actionWidget: const SizedBox(),
                        press: () {},
                      ),
                      ProfileMenu(
                        text: "ID NO : ${Get.find<StartupController>().subcId}",
                        icon: Icons.perm_identity,
                        actionWidget: const SizedBox(),
                        press: () {},
                      ),
                      ProfileMenu(
                        text: Get.find<StartupController>().shopAddr.toString(),
                        icon: Icons.location_city,
                        actionWidget: const SizedBox(),
                        press: () {

                        },
                      ),
                      ProfileMenu(
                        text: "EXPIRY : ${DateFormat('dd-MM-yyyy').format(Get.find<StartupController>().expiryDate)}",
                        icon: Icons.calendar_month,
                        actionWidget: const SizedBox(),
                        press: () async {
                        },
                      ),
                      ProfileMenu(
                        text: "STATUS : ${Get.find<StartupController>().subcIdStatus.toUpperCase()}",
                        icon: Icons.calendar_month,
                        actionWidget: const SizedBox(),
                        press: () async {
                        },
                      ),
                      ProfileMenu(
                        text: Get.find<StartupController>().applicationPlan == 1 ? "PLAN : ONLINE GOLD PLAN" : "PLAN : ONLINE SILVER PLAN",
                        icon: Icons.category,
                        actionWidget: const SizedBox(),
                        press: () {
                          ctrl.logOutFromApp();
                        },
                      ),
                    ],
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
