import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
import 'package:rest_verision_3/screens/notification_screen/controller/notification_controller.dart';
import 'package:rest_verision_3/screens/purchase_book_screen/controller/purchase_book_controller.dart';
import '../../alerts/add_credit_or_debit_alert.dart';
import '../../alerts/add_new_purchase_alert/add_new_purchase_alert.dart';
import '../../alerts/common_alerts.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/common_widget/text_field_widget.dart';
import '../../widget/common_widget/transaction_tile.dart';
import '../../widget/order_view_screen/date_picker_for_order_view.dart';
import '../../widget/order_view_screen/qr_scanner_icon_btn.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

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
                  child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return TransactionTile(
                                  leading: Icons.notifications_outlined,
                                  titleText: ctrl.myNotification[index]?.title ?? 'no title',
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
          );
        }));
  }
}
