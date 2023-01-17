import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rest_verision_3/alerts/kot_order_manage_alert/view_order_list_alert/view_order_list_alert.dart';
import 'package:rest_verision_3/routes/route_helper.dart';
import 'package:rest_verision_3/screens/login_screen/controller/startup_controller.dart';

import '../../constants/app_colors/app_colors.dart';
import '../../constants/strings/my_strings.dart';
import '../../models/kitchen_order_response/kitchen_order.dart';
import '../../models/kitchen_order_response/order_bill.dart';
import '../../screens/order_view_screen/controller/order_view_controller.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/buttons/progress_button.dart';
import '../../widget/common_widget/snack_bar.dart';

//? in order view page to show different action buttons for kot
//? eg Settle , RING , EDIT ..etc
kotOrderManageAlert({required BuildContext context, required OrderViewController ctrl, required int index}) {
  bool horizontal = 1.sh < 1.sw ? true : false;
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
          insetPadding: EdgeInsets.all(0.sp),
          titlePadding: EdgeInsets.all(0.sp),
          actionsAlignment: MainAxisAlignment.center,
          contentPadding: EdgeInsets.symmetric(vertical: 0.sp, horizontal: 3.sp),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Colors.transparent,
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    width: horizontal ? 0.4.sw : 0.8.sw,
                    height: Get.find<StartupController>().applicationPlan == 1 ? 330.h : 280.h,
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Positioned(
                          top: 45.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.sp),
                            width: horizontal ? 0.4.sw : 0.8.sw,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                20.verticalSpace,
                                //? to show heading in alert
                                Text(
                                  ctrl.kotBillingItems.isNotEmpty
                                      ? ('${ctrl.kotBillingItems[index].fdOrder?.first.name ?? ''} and other ${ctrl.kotBillingItems[index].fdOrder!.length - 1} items')
                                      : '',
                                  style: TextStyle(fontSize: 20.sp, color: AppColors.titleColor, fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                                10.verticalSpace,
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                                  height: 45.h,
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        3.horizontalSpace,
                                        //? to settle KOT
                                        Expanded(
                                          child: AppMiniButton(
                                            color: AppColors.mainColor_2,
                                            text: 'Settle',
                                            onTap: () {
                                              Navigator.pop(context);
                                              ctrl.settleKotBillingCash(context, ctrl, index);
                                            },
                                          ),
                                        ),
                                        3.horizontalSpace,
                                        //? to show KOT bill
                                        Expanded(
                                          child: AppMiniButton(
                                            color: const Color(0xff62c5ce),
                                            text: 'KOT',
                                            onTap: () {
                                              if (ctrl.kotBillingItems.isNotEmpty) {
                                                //? billing list
                                                final List<OrderBill> fdOrder = [];
                                                final List<dynamic> billingItems = [];
                                                fdOrder.addAll(ctrl.kotBillingItems[index].fdOrder?.toList() ?? []);
                                                billingItems.clear();
                                                for (var element in fdOrder) {
                                                  billingItems.add({
                                                    'fdId': element.fdId ?? -1,
                                                    'name': element.name ?? '',
                                                    'qnt': element.qnt ?? 0,
                                                    'price': (element.price ?? 0).toDouble(),
                                                    'ktNote': element.ktNote ?? ''
                                                  });
                                                }
                                                Navigator.pop(context);
                                                ctrl.kotDialogBox(context, billingItems, ctrl.kotBillingItems[index].Kot_id ?? -1, ctrl.kotBillingItems[index]);
                                              }
                                            },
                                          ),
                                        ),
                                        3.horizontalSpace,
                                        //? to view order in kot from this alert
                                        Expanded(
                                          child: AppMiniButton(
                                            color: Colors.purple,
                                            text: 'View Order',
                                            onTap: () {
                                              Navigator.pop(context);
                                              viewOrderListAlert(ctrl: ctrl, context: context, kotIndex: index);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                10.verticalSpace,
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                                  height: 45.h,
                                  child: IntrinsicHeight(
                                    //for make all button same height
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        3.horizontalSpace,
                                        //? when this btn click page will navigated to billing screen to update the order
                                        Expanded(
                                          child: AppMiniButton(
                                            color: const Color(0xff4caf50),
                                            text: 'Edit',
                                            onTap: () {
                                              if (ctrl.kotBillingItems.isNotEmpty) {
                                                //? before navigation should pop alert
                                                Navigator.pop(context);
                                                //? making emptyKotOrder otherwise will throw error
                                                KitchenOrder emptyKotOrder = EMPTY_KITCHEN_ORDER;
                                                ctrl.updateKotOrder(
                                                  //? sending full kot order , so need kot id also
                                                  kotBillingOrder: ctrl.kotBillingItems[index],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        3.horizontalSpace,
                                        //? to delete the KOT
                                        Expanded(
                                          child: ProgressButton(
                                            btnCtrlName: 'CancelOrder',
                                            text: 'Cancel',
                                            ctrl: ctrl,
                                            color: const Color(0xffef2f28),
                                            onTap: () async {
                                              if (ctrl.kotBillingItems.isNotEmpty) {
                                                await ctrl.deleteKotOrder(ctrl.kotBillingItems[index].Kot_id ?? -1);
                                                ctrl.refreshDatabaseKot();
                                                Future.delayed(const Duration(seconds: 1), () {
                                                  Navigator.pop(context);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                        3.horizontalSpace,
                                        //? close popup
                                        Expanded(
                                          child: AppMiniButton(
                                            text: 'Close',
                                            color: Colors.orangeAccent,
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                10.verticalSpace,
                                Visibility(
                                  //? in application type 2 not showing ring option
                                  visible: Get.find<StartupController>().applicationPlan == 1 ? true : false,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                                    height: 45.h,
                                    child: IntrinsicHeight(
                                      //for make all button same height
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          3.horizontalSpace,
                                          Expanded(
                                            child: AppMiniButton(
                                              color: AppColors.mainColor,
                                              text: 'Ring',
                                              onTap: () {
                                                if (ctrl.kotBillingItems.isNotEmpty) {
                                                  ctrl.ringKot(ctrl.kotBillingItems[index].Kot_id ?? -1);
                                                }
                                              },
                                            ),
                                          ),
                                          3.horizontalSpace,
                                          Expanded(
                                            child: AppMiniButton(
                                              color: Colors.pinkAccent,
                                              text: 'Add Table',
                                              onTap: () {
                                                //? checking if advancedTableManagementToggle & order is DINING and first object in kotTableChairSet has table is -1
                                                //? table is -1 is when  no table is selected
                                                if (Get.find<StartupController>().advancedTableManagementToggle) {
                                                  if ((ctrl.kotBillingItems[index].kotTableChairSet ?? []).isNotEmpty) {
                                                    if ((ctrl.kotBillingItems[index].kotTableChairSet?.first['table'] ?? -2) == -1) {
                                                      Get.back();
                                                      Get.toNamed(RouteHelper.getTableManageScreen(), arguments: {'kotId': '${ctrl.kotBillingItems[index].Kot_id ?? -1}'});
                                                    }else{
                                                      AppSnackBar.errorSnackBar('Already added!', 'table already added for this order !!');
                                                    }
                                                  }
                                                }else{
                                                  AppSnackBar.errorSnackBar('Not available !', 'this feature is not available !!');
                                                }
                                              },
                                            ),
                                          ),
                                          3.horizontalSpace,
                                          Expanded(
                                            child: AppMiniButton(
                                              color: const Color(0xff62c5ce),
                                              text: 'Add Chair',
                                              onTap: () {
                                                AppSnackBar.errorSnackBar('Not available', 'this feature is currently not available');
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: CircleAvatar(
                            minRadius: 26.r,
                            maxRadius: 38.r,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.question_mark_sharp,
                              size: 38.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 3,
                          child: CircleAvatar(
                            minRadius: 19.r,
                            maxRadius: 31.r,
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.question_mark_sharp,
                              size: 38.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(milliseconds: 900),
  );
}
