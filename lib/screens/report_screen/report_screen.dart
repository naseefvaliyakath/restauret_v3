import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rest_verision_3/screens/report_screen/controller/report_controller.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/order_view_screen/date_picker_for_order_view.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

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
                text: 'Sales Report',
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
      body: GetBuilder<ReportController>(builder: (ctrl) {
        return SafeArea(
          child: ctrl.isLoading
              ? const MyLoading()
              : RefreshIndicator(
            onRefresh: () async {
              await ctrl.refreshSettledOrder();
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    10.horizontalSpace,
                    DatePickerForOrderView(
                      maninAxisAlignment: MainAxisAlignment.center,
                      dateTime: ctrl.selectedDateRangeForSettledOrder,
                      onTap: () async {
                        ctrl.datePickerForSettledOrder(context);
                      },
                    ),
                    10.horizontalSpace,
                  ],
                ),

              ],
            ),
          ),
        );
      }),
    );
  }
}
