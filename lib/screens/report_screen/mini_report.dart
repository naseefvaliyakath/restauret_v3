import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rest_verision_3/screens/report_screen/controller/report_controller.dart';
import 'package:rest_verision_3/screens/report_screen/report_screen.dart';
import 'package:rest_verision_3/widget/common_widget/common_text/big_text.dart';
import 'package:rest_verision_3/widget/common_widget/common_text/small_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../widget/common_widget/common_text/mid_text.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/order_view_screen/date_picker_for_order_view.dart';
import 'components/orderType_graph.dart';
import 'components/orderType_table.dart';
import 'graph_models/graph_model.dart';


class MiniReport extends StatelessWidget {
  const MiniReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (ctrl) {
      bool horizontal = 1.sh < 1.sw ? true : false;
      return SafeArea(
        child: ctrl.isLoading
            ? const MyLoading()
            : RefreshIndicator(
          onRefresh: () async {
            await ctrl.refreshSettledOrder();
          },
          child: SingleChildScrollView(
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
                10.verticalSpace,
                if (ctrl.mySettledItem.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      20.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MidText(text: 'Total order: ${ctrl.totalOrder}'),
                          5.verticalSpace,
                          MidText(text: 'TotalCash : ${ctrl.totalCash}'),
                        ],
                      ),
                    ],
                  ),
                  30.verticalSpace,
                  Card(
                    child: horizontal?Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: OrderTypeGraph(ctrl: ctrl)),
                        Expanded(child: OrderTypeTable(ctrl: ctrl)),
                      ],
                    ):Column(
                      children: [
                        OrderTypeGraph(ctrl: ctrl),
                        OrderTypeTable(ctrl: ctrl)
                      ],
                    ),
                  ),

                  250.verticalSpace,
                ] else ...[
                  200.verticalSpace,
                  //TODO : overflow not added in MidText
                  const BigText(text: 'No orders !!')
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}
