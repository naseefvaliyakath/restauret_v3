import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controller/report_controller.dart';
import '../graph_models/graph_model.dart';

class OrderTypeTable extends StatelessWidget {
  final ReportController ctrl;
  const OrderTypeTable({Key? key, required this.ctrl,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DataTable(
        headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade200),
        columns: const [
          DataColumn(label: Text("Order Type")),
          DataColumn(label: Text("Order count")),
          DataColumn(label: Text("Revenue")),
        ],
        rows: List.generate(ctrl.ordersByTypeList.length, (index) {
          return DataRow(cells: [
            DataCell(Text(ctrl.ordersByTypeList[index].type)),
            DataCell(Text('${ctrl.ordersByTypeList[index].orderCount}')),
            DataCell(Text('${ctrl.ordersByTypeList[index].priceTotal}')),
          ]);
        }),
      ),
    );
  }
}
