import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
import 'package:rest_verision_3/screens/notification_screen/controller/notification_controller.dart';

import '../../constants/app_colors/app_colors.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/common_widget/transaction_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

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
                  text: 'Notifications',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.sp, color: AppColors.textColor)),
            ]),
            maxLines: 1,
          ),

        ),
        body: GetBuilder<NotificationController>(builder: (ctrl) {
          return SafeArea(
            child: ctrl.isLoading
                ? const MyLoading()
                : RefreshIndicator(
              onRefresh: () async {
                await ctrl.refreshNotification();
              },
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: horizontal ? 100.w : 0),
                      child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    return TransactionTile(
                                      leading: Icons.notifications_outlined,
                                      titleText: ctrl.myNotification[index].title ?? 'no title',
                                      subTitle:
                                          'Date: ${DateFormat('dd-MM-yyyy  hh:mm aa').format(ctrl.myNotification[index].createdAt ?? DateTime.now())}',
                                      color: AppColors.mainColor,
                                      trailingText: '',
                                      leadingColor: AppColors.mainColor,
                                      leadingOnTap: () {

                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) => const Divider(),
                                  itemCount: ctrl.myNotification.length),
                            ),
                          ],
                        ),
                    ),
                  ),
                ),
          );
        }));
  }
}
