import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_colors/app_colors.dart';
import '../dash_bord_screen/dashboard_screen.dart';
import '../today_food_screen/today_food_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
  //pages of application home
  List<Widget> pages = [
   const DashBordScreen(),
    const Center(child: Text('fourth screen')),
    const TodayFoodScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: getBody(),
        bottomNavigationBar: getFooter(),
        floatingActionButton: FloatingActionButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {

            },
            backgroundColor: AppColors.mainColor,
            child:  Icon(
              Icons.add,
              size: 35.sp,
              color: Colors.white,
            )
          //params
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked);
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
      Icons.person_pin,
    ];

    return AnimatedBottomNavigationBar(
      activeColor: AppColors.mainColor,
      splashColor: Colors.red,
      inactiveColor: AppColors.mainColor_2,
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10.r,
      iconSize: 25.sp,
      rightCornerRadius: 10.r,
      onTap: (index) {
        selectedTab(index);
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
