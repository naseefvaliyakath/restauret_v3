import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controller/report_controller.dart';
import '../graph_models/graph_model.dart';

class OrderOnlineGraphAndTable extends StatelessWidget {
  final ReportController ctrl;
  const OrderOnlineGraphAndTable({Key? key, required this.ctrl,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SfCircularChart(
            // primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'ORDERS BY ONLINE APP'),
            tooltipBehavior: TooltipBehavior(enable: true),
            legend: Legend(isVisible: true, position: LegendPosition.bottom, overflowMode: LegendItemOverflowMode.wrap),
            series: [
              PieSeries<OrdersByOnlineApp, String>(
                dataSource: ctrl.ordersByOnlineAppList,
                xValueMapper: (OrdersByOnlineApp data, _) => data.appName,
                yValueMapper: (OrdersByOnlineApp data, _) => data.orderCount,
                // radius: '60%',
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
              ),
            ],
          ),
          DataTable(
            headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade200),
            columns: const [
              DataColumn(label: Text("App Name")),
              DataColumn(label: Text("Order count")),
              DataColumn(label: Text("Revenue")),
            ],
            rows: List.generate(ctrl.ordersByOnlineAppList.length, (index) {
              return DataRow(cells: [
                DataCell(Text(ctrl.ordersByOnlineAppList[index].appName)),
                DataCell(Text('${ctrl.ordersByOnlineAppList[index].orderCount}')),
                DataCell(Text('${ctrl.ordersByOnlineAppList[index].priceTotal}')),
              ]);
            }),
          ),
        ],
      ),
    );
  }
}
