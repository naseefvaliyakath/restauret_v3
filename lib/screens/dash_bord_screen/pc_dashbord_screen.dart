import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../alerts/password_prompt_alert/password_prompt_to_cashier_alert.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/strings/my_strings.dart';
import '../../routes/route_helper.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/snack_bar.dart';
import '../../widget/dash_bord_screen/dash_bord_card.dart';
import '../login_screen/controller/startup_controller.dart';
import '../report_screen/controller/report_controller.dart';

class PcDashboardScreen extends StatelessWidget {
  const PcDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                //let's trigger the navigation expansion
              },
              icon: Icon(Icons.menu,size: 24.sp),
            ),
            BigText(text: 'DASHBOARD',size: 30.sp),
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: (){
                Get.toNamed(RouteHelper.getProfileScreen());
              },
              child: CircleAvatar(
                radius: 26.r,
                child: const Icon(Icons.person),
              ),
            ),

          ],
        ),
      20.verticalSpace,
      //Now let's start with the dashboard main rapports
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child:  DashBordCard(
              title: 'Take Away',
              subTitle: 'food take away',
              bgColor: AppColors.mainColor,
              icon: FontAwesomeIcons.burger,
              onTap: () async {
                //  Get.find<StartupController>().checkSubscriptionStatusToLogout();
                Get.toNamed(RouteHelper.getBillingScreenScreen(), arguments: {"billingPage": TAKEAWAY});
              },
            ),
          ),
          20.horizontalSpace,
          Expanded(
            child: DashBordCard(
              title: 'Home Delivery',
              subTitle: 'Home delivery Bills',
              bgColor: const Color(0xff4db6ac),
              icon: FontAwesomeIcons.wallet,
              onTap: () =>
                  Get.toNamed(RouteHelper.getBillingScreenScreen(), arguments: {"billingPage": HOME_DELEVERY}),
            ),
          ),
          20.horizontalSpace,
          Expanded(
            child:  DashBordCard(
              title: 'Online Booking',
              subTitle: 'Online Booking',
              bgColor: const Color(0xff62c5ce),
              icon: FontAwesomeIcons.kitchenSet,
              onTap: () => Get.toNamed(RouteHelper.getBillingScreenScreen(), arguments: {"billingPage": ONLINE}),
            ),
          ),
          20.horizontalSpace,
          Expanded(
            child: DashBordCard(
                title: 'Dining',
                subTitle: 'Dining Foods',
                bgColor: const Color(0xff4caf50),
                icon: FontAwesomeIcons.burger,
                onTap: () =>
                    Get.toNamed(RouteHelper.getBillingScreenScreen(), arguments: {"billingPage": DINING})),
          ),
        ],
      ),
      //Now let's set the article section
      30.verticalSpace,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child:   DashBordCard(
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
          ),
          20.horizontalSpace,
          Expanded(
            child:   DashBordCard(
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
          ),
          20.horizontalSpace,
          Expanded(
            child:  DashBordCard(
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
          ),
          20.horizontalSpace,
          Expanded(
            child:  DashBordCard(
              title: 'Report',
              subTitle: 'Sales Report',
              bgColor: AppColors.mainColor_2,
              icon: Icons.auto_graph,
              onTap: () async {
                Get.find<ReportController>().refreshSettledOrder(showSnack: false);
                if(Get.find<StartupController>().appModeNumber == 1){
                  passwordPromptToCashierMode(context: context,reason: ENTER_TO_REPORT);
                }else{
                  AppSnackBar.myFlutterToast(message: 'You are not authorized', bgColor: Colors.red);
                }

              },
            ),
          ),
        ],
      ),
      20.verticalSpace,
      //Now let's add the Table
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DataTable(
              headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.grey.shade200),
              columns: const [
                DataColumn(label: Text("Order type")),
                DataColumn(label: Text("Total sale")),
                DataColumn(label: Text("Total cash")),

              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text("Take away")),
                  DataCell(
                      Text("50")),
                  DataCell(Text("Rs : 4000")),

                ]),
                DataRow(cells: [
                  DataCell(Text("Home delivery")),
                  DataCell(
                      Text("90")),
                  DataCell(Text("Rs : 5689")),

                ]),
                DataRow(cells: [
                  DataCell(Text("Online")),
                  DataCell(
                      Text("89")),
                  DataCell(Text("Rs : 4000")),

                ]),
                DataRow(cells: [
                  DataCell(Text("Dining")),
                  DataCell(
                      Text("300")),
                  DataCell(Text("Rs : 7900")),

                ]),
              ]),
        ],
      )
    ],);
  }
}
