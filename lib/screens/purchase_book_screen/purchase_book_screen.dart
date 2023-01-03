import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rest_verision_3/screens/purchase_book_screen/controller/purchase_book_controller.dart';
import '../../alerts/add_new_purchase_alert/add_new_purchase_alert.dart';
import '../../alerts/common_alerts.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../routes/route_helper.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/common_widget/transaction_tile.dart';
import '../../widget/order_view_screen/date_picker_for_order_view.dart';

class PurchaseBookScreen extends StatelessWidget {
  const PurchaseBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: RichText(
            softWrap: false,
            text: TextSpan(children: [
              TextSpan(
                  text: 'Purchase Book',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.sp, color: AppColors.textColor)),
            ]),
            maxLines: 1,
          ),
          actions: [
            Container(
                margin: EdgeInsets.only(right: 10.w),
                child: IconButton(
                    onPressed: () {
                      Get.toNamed(RouteHelper.getNotificationScreen());
                    },
                    icon: Icon(
                      FontAwesomeIcons.bell,
                      size: 24.sp,
                    ))),
            10.horizontalSpace
          ],
        ),
        bottomNavigationBar:horizontal ? const SizedBox() :  Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 8, spreadRadius: 4, offset: Offset(0, 10)),
            ],
          ),
          height: 60.sp,
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 25.sp, right: 25.sp, bottom: 5.sp),
                child: AppMiniButton(
                  text: 'ADD NEW PURCHASE',
                  color: AppColors.mainColor,
                  onTap: () {
                    addNewPurchaseAlert(context: context);
                  },
                ),
              )),
            ],
          ),
        ),
        floatingActionButton: horizontal ? FloatingActionButton(
          onPressed: () {
            addNewPurchaseAlert(context: context);
          },
          child: Icon(Icons.add, size: 24.sp, color: Colors.white),
        ) : const SizedBox(),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        body: GetBuilder<PurchaseBookCTRL>(builder: (ctrl) {
          return SafeArea(
            child: ctrl.isLoading
                ? const MyLoading()
                : RefreshIndicator(
              onRefresh: () async {
                await ctrl.refreshPurchaseItem(startDate: DateTime.now().subtract(const Duration(days: 30)),endTime: DateTime.now());
              },
                  child: Column(
                      children: [
                      horizontal ?  BigText(text: 'SELECT DATE',size: horizontal ? 30.sp : 25.sp,) : const SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            10.horizontalSpace,
                            DatePickerForOrderView(
                              maninAxisAlignment: MainAxisAlignment.center,
                              dateTime: ctrl.selectedDateRangeForPurchase,
                              onTap: () async {
                                ctrl.datePickerForPurchaseItem(context);
                              },
                            ),
                            10.horizontalSpace,
                          ],
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: horizontal ? 100.w : 0),
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return TransactionTile(
                                    leading: Icons.remove,
                                    titleText: ctrl.myPurchaseItem[index]?.description ?? 'no description',
                                    subTitle:
                                        'Date: ${DateFormat('dd-MM-yyyy  hh:mm aa').format(ctrl.myPurchaseItem[index].createdAt ?? DateTime.now())}',
                                    color: AppColors.mainColor,
                                    trailingText: (ctrl.myPurchaseItem[index]?.price ?? 0).toString(),
                                    leadingColor: AppColors.mainColor,
                                    leadingOnTap: () {
                                      twoFunctionAlert(
                                          context: context,
                                          onTap: () {
                                            ctrl.deletePurchase(ctrl.myPurchaseItem[index].purchaseId ?? -1);
                                          },
                                          onCancelTap: () {},
                                          title: 'Delete this purchase?',
                                          subTitle: 'Do you want to delete this purchase');
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) => const Divider(),
                                itemCount: ctrl.myPurchaseItem.length),
                          ),
                        ),
                      ],
                    ),
                ),
          );
        }));

  }
}
