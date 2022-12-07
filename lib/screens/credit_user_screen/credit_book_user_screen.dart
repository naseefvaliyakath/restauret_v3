import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/routes/route_helper.dart';
import 'package:rest_verision_3/screens/credit_user_screen/controller/credit_user_ctrl.dart';
import 'package:rest_verision_3/widget/common_widget/loading_page.dart';
import 'package:rest_verision_3/widget/credit_book_screen/credit_book_app_bar_widget.dart';
import 'package:rest_verision_3/widget/common_widget/buttons/app_round_mini_btn.dart';
import '../../alerts/add_new_user_alert/add_new_user_alert.dart';
import '../../alerts/common_alerts.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../widget/credit_book_screen/crdit_user_tile.dart';
import '../credit_user_screen/credit_book_user_screen.dart';

class CreditBookUserScreen extends StatelessWidget {
   const CreditBookUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditUserCTRL>(builder: (ctrl) {
      return Scaffold(
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
                  child: AppRoundMiniBtn(
                    text: 'ADD NEW USER',
                    color: AppColors.mainColor,
                    onTap: () {
                      addNewUserAlert(context: context);
                    },
                  ),
                )),
              ],
            ),
          ),
          body: ctrl.isLoading
              ? const MyLoading()
              : RefreshIndicator(
                onRefresh: () async {
                  //? to vibrate
                  HapticFeedback.mediumImpact();
                  await ctrl.refreshCreditUser(showLoad: true,showSnack: true);
                },
                child: SafeArea(
                    child: Column(
                      children: [
                        CreditBookAppBar(
                          onChanged: (val) {
                            ctrl.searchCreditUser();
                          },
                          title: 'Credit Book',
                        ),
                        Expanded(
                          child: ListView.separated(
                              padding: EdgeInsets.only(top: 10.sp, bottom: 40.sp),
                              itemBuilder: (context, index) {
                                return CreditUserTile(
                                  onTap: () {
                                    Get.toNamed(RouteHelper.getCreditDebitScreen(), arguments: {
                                      'userId': ctrl.myCreditUser[index].crUserId ?? -1,
                                      'crUserName': ctrl.myCreditUser[index].crUserName ?? 'error',
                                    });
                                  },
                                  onLongTap: () {
                                    twoFunctionAlert(
                                        context: context,
                                        onTap: () {
                                          ctrl.deleteCreditUser(ctrl.myCreditUser[index].crUserId ?? -1,
                                              ctrl.myCreditUser[index].crUserName ?? 'error');
                                        },
                                        onCancelTap: () {},
                                        title: 'Delete this user?',
                                        subTitle: 'Do you want to delete this user');
                                  },
                                  avatarString: ctrl.myCreditUser[index].crUserName?[0] ?? 'O',
                                  name: ctrl.myCreditUser[index].crUserName ?? 'error',
                                  amount: '',
                                  color: AppColors.mainColor,
                                );
                              },
                              separatorBuilder: (context, index) => const Divider(),
                              itemCount: ctrl.myCreditUser.length),
                        ),
                      ],
                    ),
                  ),
              ));
    });
  }
}