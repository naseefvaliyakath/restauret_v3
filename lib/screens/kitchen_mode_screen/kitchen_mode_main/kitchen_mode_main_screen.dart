import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/alerts/common_alerts.dart';
import 'package:rest_verision_3/constants/strings/my_strings.dart';
import '../../../alerts/kitchen_mode_kot_alert/kitchen_mode_kot_alert.dart';
import '../../../constants/app_colors/app_colors.dart';
import '../../../widget/common_widget/common_text/big_text.dart';
import '../../../widget/kitchen_mode_screen/kitchen_mode_drop_down.dart';
import '../../../widget/order_view_screen/date_picker_for_order_view.dart';
import '../../../widget/order_view_screen/order_category.dart';
import '../../../widget/order_view_screen/order_status_card.dart';
import 'controller/kitchen_mode_main_controller.dart';


class KitchenModeMainScreen extends StatelessWidget {
  KitchenModeMainScreen({Key? key}) : super(key: key);

  final List categoryCard = [
    {'text': PENDING, 'circleColor': Colors.orange},
    {'text': PROGRESS, 'circleColor': Colors.purple},
    {'text': READY, 'circleColor': Colors.green},
    {'text': REJECT, 'circleColor': Colors.red},
    {'text': 'ALL KOT', 'circleColor': Colors.cyan},
  ];

  final List items = ["Notification", "settings"];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        appCloseConfirm(context);
        return true;
      },
      child: Scaffold(
        body: GetBuilder<KitchenModeMainController>(builder: (ctrl) {
          return RefreshIndicator(
            onRefresh: () async{
              //? to vibrate
              HapticFeedback.mediumImpact();
              ctrl.refreshDatabaseKot();
            },
            child: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                primary: false,
                slivers: <Widget>[
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    //? for ios no exit btn
                    leading: Platform.isAndroid ? IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 24.sp,
                      ),
                      onPressed: () {
                        appCloseConfirm(context);
                      },
                      splashRadius: 24.sp,
                    ) : const SizedBox(),
                    snap: true,
                    title: const Text(
                      'Kitchen Orders',
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    titleTextStyle: TextStyle(fontSize: 26.sp, color: Colors.black, fontWeight: FontWeight.w600),
                    actions: [SizedBox(height: 50.sp, child: const KitchenModeDropDown()), 15.horizontalSpace],
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(110.h),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                    child: BigText(
                                  text: 'Today KOT',
                                  size: 18.sp,
                                )),
                                DatePickerForOrderView(
                                  dateTime: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
                                  onTap: () async {
                                   // await ctrl.datePickerForSettledOrder(context);
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0.w),
                                  child: Container(
                                      padding: EdgeInsets.all(8.sp),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F7F7),
                                        borderRadius: BorderRadius.circular(50),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black87.withOpacity(0.1),
                                            spreadRadius: 1.sp,
                                            blurRadius: 1.r,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                          child: Icon(
                                        Icons.qr_code_scanner,
                                        size: 24.sp,
                                        color: Colors.grey,
                                      ))),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 55.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categoryCard.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return OrderCategory(
                                    onTap: () async {
                                      //? for color change tapped category
                                      ctrl.setStatusTappedIndex(index);
                                      //?for show different orders
                                      ctrl.updateTappedTabName(categoryCard[index]['text']);
                                      //? sorting items in all tabs PENDING , PROGRESS , READY .. etc
                                      ctrl.updateKotItemsAsPerTab();
                                    },
                                    color: ctrl.tappedIndex == index ? AppColors.mainColor_2 : Colors.white,
                                    circleColor: categoryCard[index]['circleColor'],
                                    text: categoryCard[index]['text'],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    backgroundColor: const Color(0xfffafafa),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0.sp,
                        mainAxisSpacing: 18.sp,
                        crossAxisSpacing: 18.sp,
                        childAspectRatio: 2 / 2.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          //? checking witch tab is selected
                          if (ctrl.tappedTabName == PENDING) {
                            return OrderStatusCard(
                              name: (ctrl.kotBillingItems[index].fdOrder ?? []).isEmpty
                                  ? "error"
                                  : ctrl.kotBillingItems[index].fdOrder![0].name ?? "",
                              price: (ctrl.kotBillingItems[index].totalPrice ?? 0).toString(),
                              onTap: () {
                                print('index $index');
                                viewKitchenKotAlert(context: context,  kotId: ctrl.kotBillingItems[index].Kot_id ?? -1);
                              },
                              borderColor: Colors.orange,
                              orderId: ctrl.kotBillingItems[index].Kot_id ?? -1,
                              orderStatus: ctrl.kotBillingItems[index].fdOrderStatus ?? PENDING,
                              orderType: ctrl.kotBillingItems[index].fdOrderType ?? TAKEAWAY,
                              dateTime: ctrl.kotBillingItems[index].kotTime ?? DateTime.now(),
                              totalItem: ctrl.kotBillingItems[index].fdOrder?.length ?? 0,
                            );
                          }
                          if (ctrl.tappedTabName == PROGRESS) {
                            return OrderStatusCard(
                              name: (ctrl.kotBillingItems[index].fdOrder ?? []).isEmpty
                                  ? "error"
                                  : ctrl.kotBillingItems[index].fdOrder![0].name ?? "",
                              price: (ctrl.kotBillingItems[index].totalPrice ?? 0).toString(),
                              onTap: () {
                                viewKitchenKotAlert(context: context, kotId: ctrl.kotBillingItems[index].Kot_id ?? -1);
                              },
                              borderColor: Colors.pink,
                              orderId: ctrl.kotBillingItems[index].Kot_id ?? -1,
                              orderStatus: ctrl.kotBillingItems[index].fdOrderStatus ?? PENDING,
                              orderType: ctrl.kotBillingItems[index].fdOrderType ?? TAKEAWAY,
                              dateTime: ctrl.kotBillingItems[index].kotTime ?? DateTime.now(),
                              totalItem: ctrl.kotBillingItems[index].fdOrder?.length ?? 0,
                            );
                          }
                          if (ctrl.tappedTabName == READY) {
                            return OrderStatusCard(
                              name: (ctrl.kotBillingItems[index].fdOrder ?? []).isEmpty
                                  ? "error"
                                  : ctrl.kotBillingItems[index].fdOrder![0].name ?? "",
                              price: (ctrl.kotBillingItems[index].totalPrice ?? 0).toString(),
                              onTap: () {
                                //? sending kot id , and retrve kot order from allKotList in controller
                                viewKitchenKotAlert(context: context,  kotId: ctrl.kotBillingItems[index].Kot_id ?? -1);
                              },
                              borderColor: Colors.green,
                              cardColor: Colors.green.withOpacity(0.1),
                              orderId: ctrl.kotBillingItems[index].Kot_id ?? -1,
                              orderStatus: ctrl.kotBillingItems[index].fdOrderStatus ?? PENDING,
                              orderType: ctrl.kotBillingItems[index].fdOrderType ?? TAKEAWAY,
                              dateTime: ctrl.kotBillingItems[index].kotTime ?? DateTime.now(),
                              totalItem: ctrl.kotBillingItems[index].fdOrder?.length ?? 0,
                            );
                          }

                          if (ctrl.tappedTabName == REJECT) {
                            return OrderStatusCard(
                              name: (ctrl.kotBillingItems[index].fdOrder ?? []).isEmpty
                                  ? "error"
                                  : ctrl.kotBillingItems[index].fdOrder?[0].name ?? "",
                              price: (ctrl.kotBillingItems[index].totalPrice ?? 0).toString(),
                              onTap: () {
                                viewKitchenKotAlert(context: context,  kotId: ctrl.kotBillingItems[index].Kot_id ?? -1);
                              },
                              borderColor: Colors.red,
                              cardColor: Colors.red.withOpacity(0.1),
                              orderId: ctrl.kotBillingItems[index].Kot_id ?? -1,
                              orderStatus: ctrl.kotBillingItems[index].fdOrderStatus ?? PENDING,
                              orderType: ctrl.kotBillingItems[index].fdOrderType ?? TAKEAWAY,
                              dateTime: ctrl.kotBillingItems[index].kotTime ?? DateTime.now(),
                              totalItem: ctrl.kotBillingItems[index].fdOrder!.length,
                            );
                          } else {
                            return OrderStatusCard(
                              name: (ctrl.kotBillingItems[index].fdOrder ?? []).isEmpty
                                  ? "error"
                                  : ctrl.kotBillingItems[index].fdOrder![0].name ?? "",
                              price: (ctrl.kotBillingItems[index].totalPrice ?? 0).toString(),
                              onTap: () {
                                viewKitchenKotAlert(context: context,kotId: ctrl.kotBillingItems[index].Kot_id ?? -1);
                              },
                              borderColor: ctrl.allKotBillingItems[index].fdOrderStatus == PENDING
                                  ? Colors.orange
                                  : ctrl.allKotBillingItems[index].fdOrderStatus == PROGRESS
                                      ? Colors.pink
                                      : ctrl.allKotBillingItems[index].fdOrderStatus == READY
                                          ? Colors.green
                                          : ctrl.allKotBillingItems[index].fdOrderStatus == REJECT
                                              ? Colors.red
                                              : Colors.orange,
                              cardColor: ctrl.kotBillingItems[index].fdOrderStatus == REJECT
                                  ? Colors.red.withOpacity(0.1)
                                  : ctrl.kotBillingItems[index].fdOrderStatus == READY
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.white,
                              orderId: ctrl.kotBillingItems[index].Kot_id ?? -1,
                              orderStatus: ctrl.kotBillingItems[index].fdOrderStatus ?? PENDING,
                              orderType: ctrl.kotBillingItems[index].fdOrderType ?? TAKEAWAY,
                              dateTime: ctrl.kotBillingItems[index].kotTime ?? DateTime.now(),
                              totalItem: ctrl.kotBillingItems[index].fdOrder?.length ?? 0,
                            );
                          }
                        },
                        childCount: ctrl.kotBillingItems.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

}
