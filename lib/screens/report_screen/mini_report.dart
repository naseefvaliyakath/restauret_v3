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


class MiniReport extends StatelessWidget {
  const MiniReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (ctrl){
      int totalOrder = 0;
      num totalCash = 0;
      Map<String, Map<String, num>> ordersByTypeMap = {};
      List<OrdersByType> ordersByTypeList = [];

      for (var element in ctrl.mySettledItem) {
        totalOrder += 1;
        totalCash += element.grandTotal ?? 0;

        // ordersByType
        if (element.fdOrderType != null) {
          if (ordersByTypeMap[element.fdOrderType] == null) {
            ordersByTypeMap[element.fdOrderType!] = {'orderCount': 0, 'total': 0};
          }
          num orderCount = (ordersByTypeMap[element.fdOrderType!]!['orderCount'])! + 1;
          num total = (ordersByTypeMap[element.fdOrderType!]!['total'])! + (element.grandTotal!);
          ordersByTypeMap[element.fdOrderType!] = {'orderCount': orderCount, 'total': total};
        }
      }

      ordersByTypeMap.forEach((key, value) {
        ordersByTypeList.add(OrdersByType(type: key, orderCount: value['orderCount'] ?? 0, priceTotal: value['total'] ?? 0));
      });




      Color getColorForBarChart({required int index}) {
        List<Color> color = [
          Colors.lightBlue,
          Colors.teal,
          Colors.deepPurpleAccent,
          Colors.pinkAccent,
          Colors.cyan,
          Colors.amberAccent,
          Colors.greenAccent,
          Colors.purpleAccent,
          Colors.brown,
          Colors.orange,
        ];
        if (index >= color.length) {
          return Colors.deepPurpleAccent;
        }
        return color[index];
      }

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
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    10.horizontalSpace,
                    const BigText(text: 'Today sales' ),
                    10.horizontalSpace,
                  ],
                ),
                5.verticalSpace,
                const SmallText(text: 'Pull to refresh'),
                20.verticalSpace,
                if(ctrl.mySettledItem.isNotEmpty)...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      20.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MidText(text: 'Total order: $totalOrder'),
                          5.verticalSpace,
                          MidText(text:'TotalCash : $totalCash'),
                        ],
                      ),
                    ],
                  ),

                  30.verticalSpace,
                  Card(
                    child: Column(
                      children: [
                        SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            axisLabelFormatter: (axisLabelRenderArgs) {
                              return ChartAxisLabel(axisLabelRenderArgs.text, const TextStyle());
                            },
                          ),
                          title: ChartTitle(text: 'ORDERS BY TYPE'),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: [
                            StackedColumnSeries(
                                pointColorMapper: (datum, index) {
                                  return getColorForBarChart(index: index);
                                },
                                dataSource: ordersByTypeList,
                                xValueMapper: (OrdersByType data, _) => data.type,
                                yValueMapper: (OrdersByType data, _) => data.orderCount),
                          ],
                        ),
                        const ListTile(
                          dense: true,
                          title: Text('Order count', style: TextStyle(fontWeight: FontWeight.bold)),
                          leading: Text('Order Type', style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Text('Revenue', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Column(
                          children: List.generate(ordersByTypeList.length, (index) {
                            return ListTile(
                              dense: true,
                              leading: Text(ordersByTypeList[index].type),
                              title: Text('${ordersByTypeList[index].orderCount}'),
                              trailing: Text('${ordersByTypeList[index].priceTotal}'),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                  250.verticalSpace
                ]else...[
                  250.verticalSpace,
                  //TODO : overflow not added in MidText
                  // MidText(text: 'There is no records to display for the selected date rangegsdfg df gd f g',overflow: TextOverflow.visible),
                  const MidText(text: 'No record fount !!')
                ],

              ],
            ),
          ),
        ),
      );
    });
  }
}
