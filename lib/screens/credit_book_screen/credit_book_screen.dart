import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/routes/route_helper.dart';
import 'package:rest_verision_3/screens/credit_book_screen/controller/credit_book_ctrl.dart';
import 'package:rest_verision_3/widget/credit_book_screen/credit_book_app_bar_widget.dart';
import 'package:rest_verision_3/widget/common_widget/buttons/app_round_mini_btn.dart';
import '../../alerts/add_new_user_alert/add_new_user_alert.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../widget/credit_book_screen/crdit_user_tile.dart';

class CreditBookScreen extends StatelessWidget {
  CreditBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditBookCTRL>(builder: (ctrl) {
      return Scaffold(
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
                      child: AppRoundMiniBtn(
                        text: 'Add user',
                        color: AppColors.mainColor,
                        onTap: () {
                          addNewUserAlert(context: context);
                        },
                      ),
                    )),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                CreditBookAppBar(
                  onChanged: () {},
                  title: 'Credit Book',
                ),
                Expanded(
                  child: ListView.separated(
                      padding: EdgeInsets.only(top: 10.sp, bottom: 40.sp),
                      itemBuilder: (context, index) {
                        return CreditUserTile(
                            onTap: () {},
                            avatarString: 'Wx$index'.length > 2 ? 'W$index'.substring(0, 2) : 'W$index',
                            name: 'Adam John $index',
                            amount: index < 5 ? "-150" : "+250",
                            color: (index < 5) ? AppColors.mainColor : AppColors.mainColor_2);

                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: 25),
                ),
              ],
            ),
          ));
    });
  }
}
