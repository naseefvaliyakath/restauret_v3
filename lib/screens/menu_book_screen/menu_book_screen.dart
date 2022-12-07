import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/widget/common_widget/common_text/mid_text.dart';
import '../../alerts/common_alerts.dart';
import '../../alerts/show_qr_alert/show_qr_alert.dart';
import '../../constants/strings/my_strings.dart';
import '../../models/foods_response/foods.dart';
import '../../routes/route_helper.dart';
import '../../widget/all_food_screen/category_drop_down_all.dart';
import '../../widget/common_widget/food_card.dart';
import '../../widget/common_widget/food_search_bar.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/common_widget/two_button-bottom_sheet.dart';
import '../../widget/menu_book_screen/icon_btn_with_text.dart';
import '../../widget/menu_book_screen/menu_food_card.dart';
import 'controller/menu_book_controller.dart';

class MenuBookScreen extends StatelessWidget {
  const MenuBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MenuBookController>(builder: (ctrl) {
        List<Foods> specialFoods = [];
        ctrl.myAllFoods.forEach((element) {
          if (element.fdIsSpecial == 'yes') {
            specialFoods.add(element);
          }
        });

        Set keys = {};
        List<Map<String, dynamic>> foodsByCategory = [];
        ctrl.myAllFoods.forEach((element) {
          if (keys.contains(element.fdCategory)) {
            int index = keys.toList().indexOf(element.fdCategory);
            foodsByCategory[index]['products'] = foodsByCategory[index]['products'] + [element];
          } else {
            foodsByCategory.add({
              'title': element.fdCategory,
              'products': [element]
            });
            keys.add(element.fdCategory);
          }
        });

        //Moving "COMMON to last"
        int idOfCOMMON = keys.toList().indexOf('COMMON');
        if(idOfCOMMON!=-1){
          Map<String, dynamic> temp = foodsByCategory[idOfCOMMON];
          foodsByCategory.removeAt(idOfCOMMON);
          foodsByCategory.add(temp);
        }
        //Moving "common to last"
        idOfCOMMON = keys.toList().indexOf('common');
        if(idOfCOMMON!=-1){
          Map<String, dynamic> temp = foodsByCategory[idOfCOMMON];
          foodsByCategory.removeAt(idOfCOMMON);
          foodsByCategory.add(temp);
        }


        return RefreshIndicator(
          onRefresh: () async {
            //? to vibrate
            HapticFeedback.mediumImpact();
            await ctrl.refreshAllFood();
          },
          child: ctrl.isLoading
              ? const MyLoading()
              : SafeArea(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    primary: false,
                    slivers: <Widget>[
                      SliverAppBar(
                        floating: true,
                        pinned: true,
                        snap: true,
                        title: const Text(
                          'Menu Book ',
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        titleTextStyle: TextStyle(fontSize: 26.sp, color: Colors.black, fontWeight: FontWeight.w600),
                        actions: [
                          Badge(
                            badgeColor: Colors.red,
                            child: Container(
                                margin: EdgeInsets.only(right: 10.w),
                                child: Icon(
                                  FontAwesomeIcons.bell,
                                  size: 24.sp,
                                )),
                          ),
                        ],
                        leading: BackButton(
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        //? search bar and sort icon
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(60.h),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconBtnWithText(
                                  text: 'Show QR',
                                  icons: Icons.qr_code,
                                  onTap: () {
                                    showQrAlert(context: context);
                                  },
                                ),
                                IconBtnWithText(
                                  text: 'Print QR',
                                  icons: Icons.print,
                                  onTap: () {},
                                ),
                                Visibility(
                                  visible: ctrl.isCashier,
                                  child: IconBtnWithText(
                                    text: 'Setup',
                                    icons: Icons.settings,
                                    onTap: () {
                                      Get.toNamed(RouteHelper.getMenuSetupScreen());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        backgroundColor: const Color(0xfffafafa),
                      ),
                      //? body section
                      const SliverToBoxAdapter(
                        child: ListTile(
                          title: Text('Special Food'),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.all(20.sp),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0.sp,
                            mainAxisSpacing: 18.sp,
                            crossAxisSpacing: 18.sp,
                            childAspectRatio: 0.8 / 0.8,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {},
                                onLongPress: () {},
                                child: MenuFoodCard(
                                  img: specialFoods[index].fdImg ?? IMG_LINK,
                                  name: specialFoods[index].fdName ?? '',
                                  price: specialFoods[index].fdFullPrice ?? 0,
                                  priceThreeByTwo: specialFoods[index].fdThreeBiTwoPrsPrice ?? 0,
                                  priceHalf: specialFoods[index].fdHalfPrice ?? 0,
                                  priceQuarter: specialFoods[index].fdQtrPrice ?? 0,
                                  available: specialFoods[index].fdIsAvailable ?? 'no',
                                  special: specialFoods[index].fdIsSpecial ?? 'no',
                                  fdIsLoos: specialFoods[index].fdIsLoos ?? 'no',
                                ),
                              );
                            },
                            childCount: specialFoods.length,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: ListTile(
                          title: Text('End of special'),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.all(20.sp),
                        sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Column(
                              children: [
                                ListTile(title: Text(foodsByCategory[index]['title'])),
                                GridView.builder(
                                    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 18.sp,
                                      crossAxisSpacing: 18.sp,
                                      childAspectRatio: 0.8 / 0.8,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: foodsByCategory[index]['products'].length,
                                    itemBuilder: (BuildContext context, int index2) {
                                      return MenuFoodCard(
                                        img: foodsByCategory[index]['products'][index2].fdImg ?? IMG_LINK,
                                        name: foodsByCategory[index]['products'][index2].fdName ?? '',
                                        price: foodsByCategory[index]['products'][index2].fdFullPrice ?? 0,
                                        priceThreeByTwo: foodsByCategory[index]['products'][index2].fdThreeBiTwoPrsPrice ?? 0,
                                        priceHalf: foodsByCategory[index]['products'][index2].fdHalfPrice ?? 0,
                                        priceQuarter: foodsByCategory[index]['products'][index2].fdQtrPrice ?? 0,
                                        available: foodsByCategory[index]['products'][index2].fdIsAvailable ?? 'no',
                                        special: foodsByCategory[index]['products'][index2].fdIsSpecial ?? 'no',
                                        fdIsLoos: foodsByCategory[index]['products'][index2].fdIsLoos ?? 'no',
                                      );
                                    }
                                )
                              ],
                            );
                          },
                          childCount: foodsByCategory.length,
                        )),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
