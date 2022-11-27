import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rest_verision_3/screens/credit_book_screen/controller/credit_book_ctrl.dart';
import 'package:rest_verision_3/widget/common_widget/buttons/app_min_button.dart';
import '../../alerts/add_credit_or_debit_alert.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../widget/common_widget/transaction_tile.dart';


class CreditBookUserScreen extends StatelessWidget {
  const CreditBookUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditBookCTRL>(builder: (ctrl) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: RichText(
              softWrap: false,
              text: TextSpan(children: [
                TextSpan(
                    text: 'Adem json',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.sp, color: AppColors.textColor)),
              ]),
              maxLines: 1,
            ),
            actions: [
              Container(
                  margin: EdgeInsets.only(right: 10.w),
                  child: Icon(
                    FontAwesomeIcons.bell,
                    size: 24.sp,
                  )),
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
            height: 80.sp,
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 25.sp, right: 25.sp, bottom: 20.sp),
                        child: AppMiniButton(
                          text: 'CREDIT',
                          color: AppColors.mainColor_2,
                          onTap: () {
                            addCreditOrDebit(context);
                          },
                        ))),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.sp, right: 25.sp, bottom: 20.sp),
                      child: AppMiniButton(
                        text: 'DEBIT',
                        color: AppColors.mainColor,
                        onTap: () {
                          addCreditOrDebit(context);
                        },
                      ),
                    )),
              ],
            ),
          ),
          body: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.currency_rupee, size: 25.sp, color: Colors.deepPurple[200]),
                        Text("500", style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    5.verticalSpace,
                    Text("You will get Rs: 500", style: TextStyle(fontSize: 15.sp)),
                    10.verticalSpace,
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return TransactionTile(
                        leading: Icons.delete_forever_rounded,
                        titleText: 'Payment for vegetables from shop',
                        subTitle: 'Date: 12-12-2022',
                        color: (index < 5) ? AppColors.mainColor : AppColors.mainColor_2,
                        trailingText: index < 5 ? "-150" : "+250",
                        leadingColor: Colors.redAccent,
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: 25),
              ),
            ],
          ));
    });
  }
}
