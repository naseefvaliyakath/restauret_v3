import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/constants/strings/my_strings.dart';
import 'package:rest_verision_3/screens/login_screen/controller/startup_controller.dart';
import 'package:rest_verision_3/services/service.dart';
import 'package:rest_verision_3/widget/common_widget/snack_bar.dart';
import '../../alerts/password_prompt_alert/password_prompt_to_cashier_alert.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../routes/route_helper.dart';
import '../../widget/common_widget/common_text/heading_rich_text.dart';
import '../../widget/common_widget/notification_icon.dart';
import '../../widget/dash_bord_screen/dash_bord_card.dart';
import '../report_screen/controller/report_controller.dart';

class DashBordScreen extends StatelessWidget {
  const DashBordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: <Widget>[
        10.verticalSpace,
        Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // heading my restaurant
              HeadingRichText(name: Get.find<StartupController>().shopName),
              //notification icon
              NotificationIcon(
                onTap: () async {
                  Get.toNamed(RouteHelper.getTableManageScreen());

                 // Get.toNamed(RouteHelper.getNotificationScreen());
                },
              )
            ],
          ),
        ),
        20.verticalSpace,
        Expanded(
          child: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            //?menu cards
            child: GridView.count(
                physics: const BouncingScrollPhysics(),
                childAspectRatio: 2.7 / 2.2,
                padding: const EdgeInsets.only(left: 16, right: 16).r,
                crossAxisCount: 2,
                crossAxisSpacing: 18.sp,
                mainAxisSpacing: 18.sp,
                children: [
                  DashBordCard(
                    title: 'Take Away',
                    subTitle: 'food take away',
                    bgColor: AppColors.mainColor,
                    icon: FontAwesomeIcons.burger,
                    onTap: () async {
                      Get.toNamed(RouteHelper.getBillingScreenScreen(), arguments: {"billingPage": TAKEAWAY});
                    },
                  ),
                  DashBordCard(
                    title: 'Home Delivery',
                    subTitle: 'Home delivery Bills',
                    bgColor: const Color(0xff4db6ac),
                    icon: FontAwesomeIcons.wallet,
                    onTap: () =>
                        Get.toNamed(RouteHelper.getBillingScreenScreen(), arguments: {"billingPage": HOME_DELEVERY}),
                  ),
                  DashBordCard(
                    title: 'Online Booking',
                    subTitle: 'Online Booking',
                    bgColor: const Color(0xff62c5ce),
                    icon: FontAwesomeIcons.kitchenSet,
                    onTap: () => Get.toNamed(RouteHelper.getBillingScreenScreen(), arguments: {"billingPage": ONLINE}),
                  ),
                  DashBordCard(
                      title: 'Dining',
                      subTitle: 'Dining Foods',
                      bgColor: const Color(0xff4caf50),
                      icon: FontAwesomeIcons.burger,
                      onTap: () =>
                          Get.toNamed(RouteHelper.getBillingScreenScreen(), arguments: {"billingPage": DINING})),
                  DashBordCard(
                    title: 'Credit Book',
                    subTitle: 'Costumers Credit status',
                    bgColor: const Color(0xff727070),
                    icon: FontAwesomeIcons.wallet,
                    onTap: () async {
                      //? checking app mode is cashier then he has direct access
                      if (Get.find<StartupController>().appModeNumber == 1) {
                        Get.toNamed(RouteHelper.getCreditBookUserScreen());
                      } else {
                        //? if waiter then check its allowed in general settings
                        await Get.find<StartupController>().readAllowCreditBookToWaiterFromHive();
                        if (Get.find<StartupController>().setAllowCreditBookToWaiterToggle) {
                          Get.toNamed(RouteHelper.getCreditBookUserScreen());
                        } else {
                          AppSnackBar.myFlutterToast(message: 'You are not authorized !!', bgColor: Colors.redAccent);
                        }
                      }
                    },
                  ),
                  DashBordCard(
                    title: 'Purchase Book',
                    subTitle: 'Purchase details',
                    bgColor: const Color(0xffd838de),
                    icon: FontAwesomeIcons.shop,
                    onTap: () async {
                      //? checking app mode is cashier then he has direct access
                      if (Get.find<StartupController>().appModeNumber == 1) {
                        Get.toNamed(RouteHelper.getPurchaseBookScreen());
                      } else {
                        //? if waiter then check its allowed in general settings
                        await Get.find<StartupController>().readAllowPurchaseBookToWaiterFromHive();
                        if (Get.find<StartupController>().setAllowPurchaseBookToWaiterToggle) {
                          Get.toNamed(RouteHelper.getPurchaseBookScreen());
                        } else {
                          AppSnackBar.myFlutterToast(message: 'You are not authorized !!', bgColor: Colors.redAccent);
                        }
                      }
                    },
                  ),
                  DashBordCard(
                    title: 'Menu book',
                    subTitle: 'Food menu book',
                    bgColor: const Color(0xffd838de),
                    icon: Icons.menu_book,
                    onTap: () async {
                      if (Get.find<StartupController>().applicationPlan == 1) {
                        Get.toNamed(RouteHelper.getMenuBookScreen());
                      }
                      else{
                        AppSnackBar.myFlutterToast(message: 'This feature is not available in this package', bgColor: Colors.red);
                      }
                    },
                  ),
                  DashBordCard(
                    title: 'Report',
                    subTitle: 'Sales Report',
                    bgColor: AppColors.mainColor_2,
                    icon: Icons.auto_graph,
                    onTap: () async {
                      //? to refresh report page
                      Get.find<ReportController>().refreshSettledOrder(showSnack: false);
                      if(Get.find<StartupController>().appModeNumber == 1){
                        passwordPromptToCashierMode(context: context,reason: ENTER_TO_REPORT);
                      }else{
                        AppSnackBar.myFlutterToast(message: 'You are not authorized', bgColor: Colors.red);
                      }

                    },
                  ),
                ]),
          ),
        )
      ],
    ));
  }
}
