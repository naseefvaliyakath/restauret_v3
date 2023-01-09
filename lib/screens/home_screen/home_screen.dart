import 'dart:io';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:rest_verision_3/screens/today_food_screen/controller/today_food_controller.dart';
import 'package:rest_verision_3/widget/common_widget/snack_bar.dart';
import '../../alerts/common_alerts.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/strings/my_strings.dart';
import '../../routes/route_helper.dart';
import '../dash_bord_screen/dashboard_screen.dart';
import '../home_screen_report/home_screen_report.dart';
import '../report_screen/controller/report_controller.dart';
import '../settings_page_screen/settings_page_screen.dart';
import '../today_food_screen/today_food_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //? to close quick order floating if its open when click back btn
  final isDialOpen = ValueNotifier(false);
  int pageIndex = 0;


  //pages of application home
  List<Widget> pages = [
    const DashBordScreen(),
    const HomeScreenReport(),
    const TodayFoodScreen(),
    const SettingsPageScreen(),
  ];

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
            body: getBody(),
            bottomNavigationBar: getFooter(),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              activeIcon: Icons.add,
             openCloseDial: isDialOpen,
              onOpen: (){
                if(ctrl.myTodayFoods.where((element) => element.fdIsQuick == 'yes').isEmpty){
                  AppSnackBar.myFlutterToast(message: 'Add quick items from today food',bgColor: Colors.black54,gravity: ToastGravity.CENTER);
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
                            imageUrl:  e.fdImg ?? 'https://mobizate.com/uploads/sample.jpg',
                            placeholder: (context, url) => Lottie.asset(
                              'assets/lottie/img_holder.json',
                              width: 50.sp,
                              height: 50.sp,
                              fit: BoxFit.fill,
                            ),
                            errorWidget: (context, url, error) => Lottie.asset(
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
                            'typeOfBill':DINING,
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
                            'typeOfBill':TAKEAWAY,
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
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked),
      );
    });
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Icons.home,
      Icons.stacked_bar_chart,
      Icons.fastfood,
      Icons.settings,
    ];

    List<String> label = [
      'Home',
      'Report',
      'Food',
      'Settings',
    ];

    return AnimatedBottomNavigationBar.builder(

      // activeColor: AppColors.mainColor,
      splashColor: Colors.red,
      //inactiveColor: AppColors.mainColor_2,
      //icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10.r,
      //iconSize: 25.sp,
      rightCornerRadius: 10.r,
      onTap: (index) {
        selectedTab(index);
      }, itemCount: 4, tabBuilder: (int index, bool isActive) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconItems[index] ,color: isActive ? AppColors.mainColor : AppColors.mainColor_2,size: 24.sp,),
            Text(label[index],style: TextStyle(color: isActive ? AppColors.mainColor : AppColors.mainColor_2,fontSize: 14.sp)),
          ],
        );
    },
      //other params
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
