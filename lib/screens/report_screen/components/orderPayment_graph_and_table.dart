import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controller/report_controller.dart';
import '../graph_models/graph_model.dart';

class OrderPaymentGraphAndTable extends StatelessWidget {
  final ReportController ctrl;
  const OrderPaymentGraphAndTable({Key? key, required this.ctrl,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          10.verticalSpace,
          SfCircularChart(
            title: ChartTitle(text: 'Orders by payment method'.toUpperCase()),
            // backgroundColor: Colors.red,
            // margin: EdgeInsets.zero,
            tooltipBehavior: TooltipBehavior(enable: true),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            series: [
              PieSeries<OrdersByPaymentMethod, String>(
                dataSource: ctrl.ordersByPaymentTypeList,
                xValueMapper: (OrdersByPaymentMethod data, _) => data.paymentMethod,
                yValueMapper: (OrdersByPaymentMethod data, _) => data.orderCount,
                // radius: '70%',
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
              ),
            ],
          ),
          DataTable(
            headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade200),
            columns: const [
              DataColumn(label: Text("Payment")),
              DataColumn(label: Text("Order count")),
              DataColumn(label: Text("Revenue")),
            ],
            rows: List.generate(ctrl.ordersByPaymentTypeList.length, (index) {
              return DataRow(cells: [
                DataCell(Text(ctrl.ordersByPaymentTypeList[index].paymentMethod)),
                DataCell(Text('${ctrl.ordersByPaymentTypeList[index].orderCount}')),
                DataCell(Text('${ctrl.ordersByPaymentTypeList[index].priceTotal}')),
              ]);
            }),
          ),
        ],
      ),
    );
  }
}
