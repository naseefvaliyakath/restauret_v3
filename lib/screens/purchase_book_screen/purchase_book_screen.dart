import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../alerts/add_credit_or_debit_alert.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/text_field_widget.dart';
import '../../widget/common_widget/transaction_tile.dart';

class PurchaseBookScreen extends StatelessWidget {
  const PurchaseBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return TransactionTile(
                      leading: index < 5 ? Icons.remove : Icons.add,
                      titleText: 'Payment for vegetables from shop',
                      subTitle: 'Date: 12-12-2022',
                      color: (index < 5) ? AppColors.mainColor : AppColors.mainColor_2,
                      trailingText: index < 5 ? "-150" : "+250",
                      leadingColor: (index < 5) ? AppColors.mainColor : AppColors.mainColor_2,
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: 25),
            ),
          ],
        ));
  }
}
