import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rest_verision_3/constants/strings/my_strings.dart';
import '../../alerts/common_alerts.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../routes/route_helper.dart';
import '../../widget/common_widget/common_text/heading_rich_text.dart';
import '../../widget/common_widget/notification_icon.dart';
import '../../widget/dash_bord_screen/dash_bord_card.dart';

class DashBordScreen extends StatelessWidget {
  const DashBordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        appCloseConfirm(context);
        return false;
      },
      child: SafeArea(
          child: Column(
        children: <Widget>[
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // heading my restaurant
                const HeadingRichText(name: 'Quality Restaurants '),
                //notification icon
                NotificationIcon(
                  onTap: () {},
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
                      onTap: () =>Get.toNamed(RouteHelper.getBillingScreenScreen(),arguments:{"billingPage":TAKEAWAY}),
                    ),
                    DashBordCard(
                      title: 'Home Delivery',
                      subTitle: 'Home delivery Bills',
                      bgColor: const Color(0xff4db6ac),
                      icon: FontAwesomeIcons.wallet,
                      onTap: () =>Get.toNamed(RouteHelper.getBillingScreenScreen(),arguments:{"billingPage":HOME_DELEVERY}),
                    ),
                    DashBordCard(
                      title: 'Online Booking',
                      subTitle: 'Online Booking',
                      bgColor: const Color(0xff62c5ce),
                      icon: FontAwesomeIcons.kitchenSet,
                        onTap: () =>Get.toNamed(RouteHelper.getBillingScreenScreen(),arguments:{"billingPage":ONLINE}),
                    ),
                    DashBordCard(
                      title: 'Dining',
                      subTitle: 'Dining Foods',
                      bgColor: const Color(0xff4caf50),
                      icon: FontAwesomeIcons.burger,
                        onTap: () =>Get.toNamed(RouteHelper.getBillingScreenScreen(),arguments:{"billingPage":DINING})
                    ),
                    DashBordCard(
                      title: 'Waiter',
                      subTitle: 'Waiter status',
                      bgColor: const Color(0xff727070),
                      icon: FontAwesomeIcons.bowlFood,
                      onTap: () {},
                    ),
                    DashBordCard(
                      title: 'Food Court',
                      subTitle: 'Today Foods',
                      bgColor: const Color(0xffd838de),
                      icon: FontAwesomeIcons.burger,
                      onTap: () {},
                    ),
                    DashBordCard(
                      title: 'Food Court',
                      subTitle: 'Today Foods',
                      bgColor: const Color(0xffd838de),
                      icon: FontAwesomeIcons.burger,
                      onTap: () {},
                    ),
                    DashBordCard(
                      title: 'Bill',
                      subTitle: 'Costumer Bills',
                      bgColor: AppColors.mainColor_2,
                      icon: FontAwesomeIcons.wallet,
                      onTap: () {},
                    ),
                  ]),
            ),
          )
        ],
      )),
    );
  }
}
