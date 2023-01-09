import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../alerts/common_alerts.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/strings/my_strings.dart';
import '../../routes/route_helper.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/snack_bar.dart';
import '../dash_bord_screen/dashboard_screen.dart';
import '../dash_bord_screen/pc_dashbord_screen.dart';
import '../home_screen_report/home_screen_report.dart';
import '../report_screen/controller/report_controller.dart';
import '../settings_page_screen/settings_page_screen.dart';
import '../today_food_screen/controller/today_food_controller.dart';
import '../today_food_screen/today_food_screen.dart';

class PcHomeScreen extends StatefulWidget {
  const PcHomeScreen({Key? key}) : super(key: key);

  @override
  State<PcHomeScreen> createState() => _PcHomeScreenState();
}

class _PcHomeScreenState extends State<PcHomeScreen> {
  final isDialOpen = ValueNotifier(false);
  bool isExpanded = false;
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodayFoodController>(builder: (ctrl) {
      return WillPopScope(
        onWillPop: () async {
          if(Platform.isAndroid){
            //? to close quick order floating if its open when click back btn
            if(isDialOpen.value){
              isDialOpen.value = false;
              return false;
            }
            else{
              appCloseConfirm(context);
            }
          }
          return false;
        },
        child: Scaffold(
            body: Row(
              children: [
                //Let's start by adding the Navigation Rail
                NavigationRail(
                    extended: true,
                    minExtendedWidth: 55.w,
                    leading: Text(
                      'Welcome',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.sp,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: AppColors.mainColor_2,
                    unselectedIconTheme: const IconThemeData(color: Colors.white, opacity: 1),
                    unselectedLabelTextStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    selectedIconTheme: const IconThemeData(color: Colors.black54),
                    selectedLabelTextStyle: const TextStyle(
                      color: Colors.black54,
                    ),

                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text("Home"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.bar_chart),
                        label: Text("Rapports"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.fastfood),
                        label: Text("Food"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text("Settings"),
                      ),
                    ],
                    onDestinationSelected: (selected) {
                      setState(() {
                        pageIndex = selected;
                      });
                    },
                    selectedIndex: pageIndex),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20.sp),
                    child: getBody(),
                  ),
                ),
              ],
            ),
            //let's add the floating action button
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              activeIcon: Icons.add,
              openCloseDial: isDialOpen,
              onOpen: () {
                if (ctrl.myTodayFoods
                    .where((element) => element.fdIsQuick == 'yes')
                    .isEmpty) {
                  AppSnackBar.myFlutterToast(message: 'Add quick items from today food', bgColor: Colors.black54, gravity: ToastGravity.CENTER);
                }
              },
              backgroundColor: AppColors.mainColor,
              foregroundColor: Colors.white,
              overlayColor: Colors.black54,
              overlayOpacity: 0.6,
              children: [
                ...ctrl.myTodayFoods.where((element) => element.fdIsQuick == 'yes').map((e) {
                  return SpeedDialChild(
                      child: CircleAvatar(
                        radius: 100.r,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: e.fdImg ?? 'https://mobizate.com/uploads/sample.jpg',
                            placeholder: (context, url) =>
                                Lottie.asset(
                                  'assets/lottie/img_holder.json',
                                  width: 50.sp,
                                  height: 50.sp,
                                  fit: BoxFit.fill,
                                ),
                            errorWidget: (context, url, error) =>
                                Lottie.asset(
                                  'assets/lottie/error.json',
                                  width: 10.sp,
                                  height: 10.sp,
                                ),
                            fit: BoxFit.cover,
                            width: 50.sp,
                            height: 100.sp,
                          ),
                        ),
                      ),
                      label: (e.fdName ?? 'error').length > 15 ? e.fdName!.substring(0, 15) : e.fdName ?? 'name',
                      onTap: () {
                        //? to send to TAKE AWAY screen with item , from their it pass to add to bill and call settled bill
                        Get.toNamed(RouteHelper.getBillingScreenScreen(), arguments: {
                          "quickBill": {
                            'typeOfBill': DINING,
                            'fdIsLoos': e.fdIsLoos ?? 'no',
                            'fdId': e.fdId ?? -1,
                            'fdName': e.fdName ?? 'error',
                            'qnt': 1,
                            'price': e.fdFullPrice ?? 10,
                            'ktNote': '',
                          }
                        });
                      },
                      onLongPress: () {
                        //? to send to TAKE AWAY screen with item , from their it pass to add to bill and call settled bill
                        //? to vibrate
                        HapticFeedback.mediumImpact();
                        Get.toNamed(RouteHelper.getBillingScreenScreen(), arguments: {
                          "quickBill": {
                            'typeOfBill': TAKEAWAY,
                            'fdIsLoos': e.fdIsLoos ?? 'no',
                            'fdId': e.fdId ?? -1,
                            'fdName': e.fdName ?? 'error',
                            'qnt': 1,
                            'price': e.fdFullPrice ?? 10,
                            'ktNote': '',
                          }
                        });
                      }
                  );
                }).toList()
              ],
            ),
        ),
      );
    });
  }

  List<Widget> pages = [
    const PcDashboardScreen(),
    const HomeScreenReport(),
    const TodayFoodScreen(),
    const SettingsPageScreen(),
  ];

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }
}
