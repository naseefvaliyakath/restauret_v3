import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controller/report_controller.dart';
import '../graph_models/graph_model.dart';

class OrderTypeGraph extends StatelessWidget {
  final ReportController ctrl;
  const OrderTypeGraph({Key? key, required this.ctrl,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          axisLabelFormatter: (axisLabelRenderArgs) {
            return ChartAxisLabel(axisLabelRenderArgs.text, TextStyle());
          },
        ),
        title: ChartTitle(text: 'ORDERS BY TYPE'),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [
          StackedColumnSeries(
              pointColorMapper: (datum, index) {
                return ctrl.getColorForBarChart(index: index);
              },
              dataSource: ctrl.ordersByTypeList,
              xValueMapper: (OrdersByType data, _) => data.type,
              yValueMapper: (OrdersByType data, _) => data.orderCount),
        ],
      ),
    );
  }
}
