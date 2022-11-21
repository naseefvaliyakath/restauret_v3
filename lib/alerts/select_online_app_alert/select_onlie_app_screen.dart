import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/constants/strings/my_strings.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';
import 'package:rest_verision_3/widget/common_widget/loading_page.dart';

import '../common_alerts.dart';
import 'add_new_online_app_alert.dart';
import 'add_new_online_app_card.dart';
import 'onlene_app_card.dart';

class SelectOnlineAppScreen extends StatelessWidget {
  const SelectOnlineAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillingScreenController>(builder: (ctrl) {
      return ctrl.isLoading ?  SizedBox(
        //? to make same size in loading
          width: 1.sw * 0.8,
          height: 1.sh * 0.5,
          child: const MyLoading()) : SizedBox(
        width: 1.sw * 0.8,
        height: 1.sh * 0.5,
        child: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.all(20.sp),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0.sp,
                  mainAxisSpacing: 18.sp,
                  crossAxisSpacing: 18.sp,
                  childAspectRatio: 2 / 2,
                ),
                //? if empty showing add online app card
                delegate: ctrl.myOnlineApp.isEmpty
                    ? SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return InkWell(
                              onTap: () {
                                //? when list item zero then only this show
                                addNewOnlineAppAlert(context: context);
                              },
                              child: const AddNewOnlineAppCard());
                        },
                        childCount: 1,
                      )
                    : SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index < ctrl.myOnlineApp.length) {
                            return InkWell(
                              onTap: () {
                                ctrl.selectOnlineApp(ctrl.myOnlineApp[index].appName ?? NO_ONLINE_APP);
                                Navigator.pop(context);
                              },
                              onLongPress: () {
                                //? to delete online app
                                twoFunctionAlert(
                                    context: context,
                                    onTap: () async {
                                      ctrl.deleteOnlineApp(ctrl
                                              .myOnlineApp[index]
                                              .onlineApp_id ??
                                          -1);
                                    },
                                    onCancelTap: () {},
                                    title: 'Delete ?',
                                    subTitle: 'Do you want to delete the app');
                              },
                              child: OnlineAppCard(
                                text:
                                    ctrl.myOnlineApp[index].appName ?? NO_ONLINE_APP
                              ),
                            );
                          } else {
                            return InkWell(
                                onTap: () {
                                  //? when list item not zero then only this show
                                  addNewOnlineAppAlert(context: context);
                                },
                                child: const AddNewOnlineAppCard());
                          }
                        },
                        childCount: ctrl.myOnlineApp.isEmpty
                            ? 0
                            : ctrl.myOnlineApp.length + 1,
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
