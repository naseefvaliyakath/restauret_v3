import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
import 'package:rest_verision_3/screens/credit_user_screen/controller/credit_user_ctrl.dart';
import 'package:rest_verision_3/widget/common_widget/buttons/app_min_button.dart';
import 'package:rest_verision_3/widget/common_widget/loading_page.dart';
import '../../alerts/add_credit_or_debit_alert.dart';
import '../../alerts/common_alerts.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../routes/route_helper.dart';
import '../../widget/common_widget/transaction_tile.dart';
import 'controller/credit_debit_ctrl.dart';

class CreditDebitScreen extends StatelessWidget {
  const CreditDebitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditDebitCtrl>(builder: (ctrl) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: RichText(
              softWrap: false,
              text: TextSpan(children: [
                TextSpan(
                    text: ctrl.userNamGet,
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
          bottomNavigationBar: Container(
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
                          text: 'CREDIT',
                          color: AppColors.mainColor_2,
                          onTap: () {
                            addCreditOrDebit(context, 'CREDIT');
                          },
                        ))),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 25.sp, right: 25.sp, bottom: 5.sp),
                  child: AppMiniButton(
                    text: 'DEBIT',
                    color: AppColors.mainColor,
                    onTap: () {
                      addCreditOrDebit(context, 'DEBIT');
                    },
                  ),
                )),
              ],
            ),
          ),
          body: ctrl.isLoading
              ? const MyLoading()
              : Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          10.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.currency_rupee, size: 25.sp, color: Colors.deepPurple[200]),
                              Text(ctrl.calculateTotal().toString(),
                                  style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          5.verticalSpace,
                          Text("You will get Rs: ${ctrl.calculateTotal().toString()}",
                              style: TextStyle(fontSize: 15.sp)),
                          10.verticalSpace,
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return TransactionTile(
                              leading: Icons.delete_forever_rounded,
                              titleText: ctrl.allCreditDebit[index].description ?? '',
                              subTitle: DateFormat('dd-MM-yyyy  hh:mm aa')
                                  .format(ctrl.allCreditDebit[index].createdAt ?? DateTime.now()),
                              color: ctrl.allCreditDebit[index].debitAmount == 0 ? Colors.green : Colors.redAccent,
                              trailingText: (ctrl.allCreditDebit[index].debitAmount ?? 0) == 0
                                  ? (ctrl.allCreditDebit[index].creditAmount ?? 0).toString()
                                  : (ctrl.allCreditDebit[index].debitAmount ?? 0).toString(),
                              leadingColor: Colors.redAccent,
                              leadingOnTap: () {
                                twoFunctionAlert(
                                    context: context,
                                    onTap: () {
                                      ctrl.deleteCreditDebit(ctrl.allCreditDebit[index].crUserId ?? -1,
                                          ctrl.allCreditDebit[index].creditDebitId ?? -1);
                                    },
                                    onCancelTap: () {},
                                    title: 'Delete this user?',
                                    subTitle: 'Do you want to delete this user');
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: ctrl.allCreditDebit.length),
                    ),
                  ],
                ));
    });
  }
}
