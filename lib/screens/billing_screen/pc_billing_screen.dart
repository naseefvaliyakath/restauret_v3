import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../alerts/common_alerts.dart';
import '../../alerts/delivery_address_alert/delivery_address_alert.dart';
import '../../alerts/food_billing_alert/food_billing_alert.dart';
import '../../alerts/select_online_app_alert/select_online_app_alert.dart';
import '../../alerts/table_select_alert/table_select_alert.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/strings/my_strings.dart';
import '../../routes/route_helper.dart';
import '../../widget/all_food_screen/category_drop_down_all.dart';
import '../../widget/billing_screen/billing_food_card.dart';
import '../../widget/billing_screen/billing_food_err_card.dart';
import '../../widget/billing_screen/billing_item_tile.dart';
import '../../widget/billing_screen/billing_table_heading.dart';
import '../../widget/billing_screen/category_drop_down_billing.dart';
import '../../widget/billing_screen/clear_all_bill_widget.dart';
import '../../widget/billing_screen/search_bar_in_billing_screen.dart';
import '../../widget/billing_screen/totel_price_txt.dart';
import '../../widget/billing_screen/white_button_with_icon.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/buttons/progress_button.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/common_text/heading_rich_text.dart';
import '../../widget/common_widget/food_card.dart';
import '../../widget/common_widget/food_search_bar.dart';
import '../../widget/common_widget/refresh_icon_btn.dart';
import '../../widget/common_widget/snack_bar.dart';
import '../login_screen/controller/startup_controller.dart';
import 'controller/billing_screen_controller.dart';

class PcBillingScreen extends StatelessWidget {
  const PcBillingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BillingScreenController>(builder: (ctrl) {
        return GestureDetector(
          onTap: () {
            //? to close key bord on outside touch
            //? so normally key bord not close touch list view
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
              child: Container(
                height: 1.sh,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                10.verticalSpace,
                //? back arrow and heading and notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //? back arrow and heading
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BackButton(
                            onPressed: () async {
                              //? if navigated from kot update  tab on back press not ask save in hive
                              if (ctrl.isNavigateFromKotUpdate == true) {
                                Get.back();
                              } else {
                                if (ctrl.billingItems.isNotEmpty) {
                                  await Get.find<BillingScreenController>().saveBillInHive();
                                  Get.back();
                                } else {
                                  Get.back();
                                }
                              }
                            },
                          ),
                          15.horizontalSpace,
                          HeadingRichText(name: ctrl.screenName),
                        ],
                      ),
                    ),

                    //? notification icon
                    RefreshIconBtn(
                      onTap: () {
                        if(Platform.isWindows){
                          //? to vibrate
                          HapticFeedback.mediumImpact();
                          ctrl.refreshTodayFood();
                          ctrl.refreshCategory();
                        }else{
                          AppSnackBar.myFlutterToast(message: 'Long press for refresh', bgColor: Colors.black54);
                        }

                      },
                      onLongTap: () {
                        //? to vibrate
                        HapticFeedback.mediumImpact();
                        ctrl.refreshTodayFood();
                        ctrl.refreshCategory();
                      },
                    ),
                  ],
                ),
                //?  search and category
                Row(
                  children: [
                    //? search bar
                    SearchBarInBillingScreen(onChanged: (value) {
                      //? search value taken from TextCtrl
                      ctrl.searchTodayFood();
                    }),
                    //? category dropdown
                    const CategoryDropDownBilling()
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                              //? Items Ordered text
                              Flexible(
                                child: BigText(
                                  text: 'Available foods ',
                                  size: 20.sp,
                                ),
                              ),

                              10.horizontalSpace,
                              //? this will change if homeDelivery it will select address
                              //? if its dining it will select table
                              ctrl.orderType == TAKEAWAY ? const SizedBox() : Flexible(
                                child: WhiteButtonWithIcon(
                                  text: ctrl.orderType == HOME_DELEVERY
                                      ? (ctrl.selectDeliveryAddrTxt.length > 12 ? ctrl.selectDeliveryAddrTxt.substring(0, 13) : ctrl.selectDeliveryAddrTxt)
                                      : ctrl.orderType == DINING
                                      ? ctrl.selectTableTxt
                                      : ctrl.orderType == ONLINE
                                      ? (ctrl.selectedOnlineAppNameTxt.length > 12 ? ctrl.selectedOnlineAppNameTxt.substring(0, 13) : ctrl.selectedOnlineAppNameTxt)
                                      : 'Take away',
                                  icon: Icons.edit,
                                  onTap: () async {
                                    if (ctrl.orderType == HOME_DELEVERY) {
                                      deliveryAddressAlert(context: context, ctrl: ctrl);
                                    }
                                    if (ctrl.orderType == ONLINE) {
                                      selectOnlineAppAlert(context: context);
                                    }

                                    if (ctrl.orderType == DINING) {
                                      //tableSelectAlert(context: context);
                                      if (ctrl.billingItems.isNotEmpty) {
                                        await Get.find<BillingScreenController>().saveBillInHive();
                                      }
                                      if(ctrl.isNavigateFromTableManage){
                                        AppSnackBar.errorSnackBar('Cant change table', 'You cannot change table !!');
                                      }else{
                                        if(Get.find<StartupController>().advancedTableManagementToggle){
                                          Get.offNamed(RouteHelper.getTableManageScreen());
                                        }else{
                                          tableSelectAlert(context: context);
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),

                              //? clear bill btn
                              Flexible(
                                child: ClearAllBill(onTap: () {
                                  //? if settled button clicked cant clear item
                                  if (ctrl.isClickedSettle.value) {
                                    AppSnackBar.errorSnackBar('This bill is already settled', 'Click new order !');
                                  } else {
                                    ctrl.clearAllBillItems();
                                  }
                                }),
                              ),
                            ]),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 20.sp),
                                  child: SafeArea(
                                    child: CustomScrollView(
                                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                      primary: false,
                                      slivers: <Widget>[
                                        //? body section
                                        SliverPadding(
                                          padding: EdgeInsets.all(20.sp),
                                          sliver: SliverGrid(
                                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 200.0.sp,
                                              mainAxisSpacing: 18.sp,
                                              crossAxisSpacing: 18.sp,
                                              childAspectRatio: 3 / 3.5,
                                            ),
                                            delegate: SliverChildBuilderDelegate(
                                              (BuildContext context, int index) {
                                                return ctrl.isLoading
                                                    ? const BillingFoodErrCard()
                                                    : BillingFoodCard(
                                                  onTap: () {
                                                    // ? if settled button clicked cant add new item
                                                    if (ctrl.isClickedSettle.value) {
                                                      AppSnackBar.errorSnackBar('This bill is already settled', 'Click new order !');
                                                    } else {
                                                      //? billing alert popup
                                                      foodBillingAlert(
                                                        context,
                                                        index: index,
                                                        price: ctrl.myTodayFoods[index].fdFullPrice ?? 0,
                                                        img: ctrl.myTodayFoods[index].fdImg ?? IMG_LINK,
                                                        name: ctrl.myTodayFoods[index].fdName ?? '',
                                                        fdIsLoos: ctrl.myTodayFoods[index].fdIsLoos ?? 'no',
                                                        fdId: ctrl.myTodayFoods[index].fdId ?? -1,
                                                      );
                                                    }
                                                    //? to close key bord on outside touch
                                                    FocusScope.of(context).requestFocus(FocusNode());
                                                  },
                                                  onLongTap: () {
                                                    // ? if settled button clicked cant add new item
                                                    if (ctrl.isClickedSettle.value) {
                                                      AppSnackBar.errorSnackBar('This bill is already settled', 'Click new order !');
                                                    } else {
                                                      //? check billing item is empty , direct billing only foe 1 item
                                                      if (ctrl.billingItems.isEmpty) {
                                                        //? adding the item with qnt 1 and price default to billing
                                                        ctrl.addFoodToBill(
                                                            ctrl.myTodayFoods[index].fdIsLoos ?? 'no',
                                                            ctrl.myTodayFoods[index].fdId ?? 0,
                                                            ctrl.myTodayFoods[index].fdName ?? '',
                                                            1,
                                                            ctrl.myTodayFoods[index].fdFullPrice,
                                                            '' //? no kitchen note for direct billing item ,
                                                        );
                                                        //? billing alert popup
                                                        ctrl.settleBillingCashAlertShowing(context, ctrl);
                                                      } else {
                                                        AppSnackBar.errorSnackBar('Clear bill first', 'direct bill only available for single item');
                                                      }
                                                    }
                                                    //? to close key bord on outside touch
                                                    FocusScope.of(context).requestFocus(FocusNode());
                                                  },
                                                  img: ctrl.myTodayFoods[index].fdImg ?? IMG_LINK,
                                                  name: ctrl.myTodayFoods[index].fdName ?? '',
                                                  price: ctrl.myTodayFoods[index].fdFullPrice ?? 0,
                                                  priceThreeByTwo: ctrl.myTodayFoods[index].fdThreeBiTwoPrsPrice ?? 0,
                                                  priceHalf: ctrl.myTodayFoods[index].fdHalfPrice ?? 0,
                                                  priceQuarter: ctrl.myTodayFoods[index].fdQtrPrice ?? 0,
                                                  fdIsLoos: ctrl.myTodayFoods[index].fdIsLoos ?? 'no',
                                                  onSwipe: () {
                                                    ctrl.addFoodToBill(
                                                        ctrl.myTodayFoods[index].fdIsLoos ?? 'no',
                                                        ctrl.myTodayFoods[index].fdId ?? 0,
                                                        ctrl.myTodayFoods[index].fdName ?? '',
                                                        1,
                                                        ctrl.myTodayFoods[index].fdFullPrice,
                                                        '' //? no kitchen note for swipe adding item  to bill,
                                                    );
                                                  },
                                                );
                                              },
                                              childCount:ctrl.isLoading ? 8 : ctrl.myTodayFoods.length,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          child: Column(
                            children: [
                              //? billing table
                              Expanded(
                                  child: Container(
                                decoration: BoxDecoration(border: Border.all(color: AppColors.mainColor), borderRadius: BorderRadius.circular(5.r)),
                                padding: EdgeInsets.all(3.sp),
                                width: double.maxFinite,
                                child: ListView(
                                  children: [
                                    //? billing table heading
                                    DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade200),
                                      columns: const [
                                        DataColumn(label: Text("Name")),
                                        DataColumn(label: Text("Quantity")),
                                        DataColumn(label: Text("Price")),
                                      ],
                                      rows: ctrl.billingItems.map((e) {
                                        return DataRow(cells: [
                                          DataCell(
                                            ListTile(
                                              title: Text((e['name'] ?? '')),
                                              subtitle: Text((e['ktNote'] ?? '')),
                                              dense: true,
                                            ),
                                          ),
                                          DataCell(Text((e['qnt'] ?? 0).toString())),
                                          DataCell(ListTile(
                                            title: Text((e['price'] ?? 0).toString()),
                                            trailing: IconButton(
                                              onPressed: () {
                                                deleteItemFromBillAlert(context, ctrl.billingItems.indexOf(e));
                                              },
                                              icon: Icon(Icons.edit,size: 24.sp,),
                                            ),
                                          )),
                                        ]);
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              )),
                              TotalPriceTxt(price: ctrl.totalPrice),
                              //?  controller buttons
                              //? if navigate from orderViewScreen for updating order
                              //? then it only showing update order and cancel btn
                              ctrl.isNavigateFromKotUpdate
                                  ? Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(vertical: 3.h),
                                      height: 40.h,
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Flexible(
                                              child: ProgressButton(
                                                btnCtrlName: 'kotUpdate',
                                                text: 'Update KOT Order',
                                                ctrl: ctrl,
                                                color: Colors.green,
                                                onTap: () async {
                                                  ctrl.updateKotOrder();
                                                },
                                              ),
                                            ),
                                            3.horizontalSpace,
                                            Flexible(
                                              child: AppMiniButton(
                                                color: Colors.redAccent,
                                                text: 'Cancel Update',
                                                onTap: () {
                                                  Get.offNamed(RouteHelper.getOrderViewScreen());
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  : Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(vertical: 3.h),
                                      height: 40.h,
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Flexible(
                                              child: ProgressButton(
                                                btnCtrlName: 'kot',
                                                text: 'Order',
                                                ctrl: ctrl,
                                                color: Colors.green,
                                                onTap: () async {
                                                  //? if settled button clicked cant add new item
                                                  if (ctrl.isClickedSettle.value) {
                                                    AppSnackBar.errorSnackBar('This bill is already settled', 'Click new order !');
                                                    ctrl.btnControllerKot.error();
                                                    await Future.delayed(const Duration(milliseconds: 500), () {
                                                      ctrl.btnControllerKot.reset();
                                                    });
                                                  } else {
                                                    await ctrl.sendKotOrder();
                                                  }
                                                },
                                              ),
                                            ),
                                            3.horizontalSpace,
                                            Flexible(
                                              child: AppMiniButton(
                                                color: const Color(0xffee588f),
                                                text: 'Settle',
                                                onTap: () async {
                                                  ctrl.settleBillingCashAlertShowing(context, ctrl);
                                                },
                                              ),
                                            ),
                                            3.horizontalSpace,
                                            Flexible(
                                              child: ProgressButton(
                                                btnCtrlName: 'hold',
                                                text: 'Hold',
                                                ctrl: ctrl,
                                                color: AppColors.mainColor_2,
                                                onTap: () async {
                                                  await ctrl.addHoldBillItem();
                                                },
                                              ),
                                            ),
                                            3.horizontalSpace,
                                            Flexible(
                                              child: AppMiniButton(
                                                color: AppColors.mainColor,
                                                text: 'KOT',
                                                onTap: () {
                                                  ctrl.kotDialogBox(context);
                                                },
                                              ),
                                            ),
                                            3.horizontalSpace,
                                            Flexible(
                                              child: AppMiniButton(
                                                color: AppColors.mainColor,
                                                text: 'New Order',
                                                onTap: () async {
                                                  //Get.find<HiveHoldBillController>().clearBill(index: 1);
                                                  ctrl.enableNewOrder();
                                                },
                                              ),
                                            ),
                                            3.horizontalSpace,
                                            Flexible(
                                              child: AppMiniButton(
                                                color: const Color(0xff62c5ce),
                                                text: 'All Order',
                                                onTap: () {
                                                  Get.offNamed(RouteHelper.getOrderViewScreen(),arguments: {'from':ctrl.orderType});
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                              10.verticalSpace,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
        );
      }),
    );
  }
}
