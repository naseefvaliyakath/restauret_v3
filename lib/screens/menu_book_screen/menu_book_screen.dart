import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/printer/controller/print_controller.dart';
import 'package:rest_verision_3/widget/common_widget/common_text/big_text.dart';

import '../../alerts/show_qr_alert/show_qr_alert.dart';
import '../../constants/strings/my_strings.dart';
import '../../routes/route_helper.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/menu_book_screen/icon_btn_with_text.dart';
import '../../widget/menu_book_screen/menu_food_card.dart';
import 'controller/menu_book_controller.dart';

class MenuBookScreen extends StatelessWidget {
  const MenuBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MenuBookController>(builder: (ctrl) {
        bool horizontal = 1.sh < 1.sw ? true : false;
        return ctrl.isLoading
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
                                onTap: () {
                                  Get.find<PrintCTRL>().printQrCode(ctrl.menuBookUrl);
                                },
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
                        title:   BigText(text:'SPECIAL FOOD'),
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
                                img: ctrl.specialFoods[index].fdImg ?? IMG_LINK,
                                name: ctrl.specialFoods[index].fdName ?? '',
                                price: ctrl.specialFoods[index].fdFullPrice ?? 0,
                                priceThreeByTwo: ctrl.specialFoods[index].fdThreeBiTwoPrsPrice ?? 0,
                                priceHalf: ctrl.specialFoods[index].fdHalfPrice ?? 0,
                                priceQuarter: ctrl.specialFoods[index].fdQtrPrice ?? 0,
                                available: ctrl.specialFoods[index].fdIsAvailable ?? 'no',
                                special: ctrl.specialFoods[index].fdIsSpecial ?? 'no',
                                showPrice: true,
                                showSpecial: true,
                                fdIsLoos: ctrl.specialFoods[index].fdIsLoos ?? 'no',
                              ),
                            );
                          },
                          //? to hide special food on toggling byn in setup page
                          childCount:  ctrl.specialFoods.length,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(20.sp),
                      sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Column(
                            children: [
                              ListTile(title: BigText(text:(ctrl.foodsByCategory[index]['title']).toString().toUpperCase())),
                              GridView.builder(
                                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: horizontal ? 7 :  2,
                                    mainAxisSpacing: 18.sp,
                                    crossAxisSpacing: 18.sp,
                                    childAspectRatio: 0.8 / 0.8,
                                  ),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: ctrl.foodsByCategory[index]['products'].length,
                                  itemBuilder: (BuildContext context, int index2) {
                                    return MenuFoodCard(
                                      img: ctrl.foodsByCategory[index]['products'][index2].fdImg ?? IMG_LINK,
                                      name: ctrl.foodsByCategory[index]['products'][index2].fdName ?? '',
                                      price: ctrl.foodsByCategory[index]['products'][index2].fdFullPrice ?? 0,
                                      priceThreeByTwo: ctrl.foodsByCategory[index]['products'][index2].fdThreeBiTwoPrsPrice ?? 0,
                                      priceHalf: ctrl.foodsByCategory[index]['products'][index2].fdHalfPrice ?? 0,
                                      priceQuarter: ctrl.foodsByCategory[index]['products'][index2].fdQtrPrice ?? 0,
                                      available: ctrl.foodsByCategory[index]['products'][index2].fdIsAvailable ?? 'no',
                                      special: ctrl.foodsByCategory[index]['products'][index2].fdIsSpecial ?? 'no',
                                      showPrice: true,
                                      showSpecial: true,
                                      fdIsLoos: ctrl.foodsByCategory[index]['products'][index2].fdIsLoos ?? 'no',
                                    );
                                  }
                              )
                            ],
                          );
                        },
                        childCount: ctrl.foodsByCategory.length,
                      )),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
