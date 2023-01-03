import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../widget/common_widget/common_text/big_text.dart';
import '../controller/report_controller.dart';
import '../graph_models/graph_model.dart';

class OrderProductGraphAndTable extends StatelessWidget {
  final ReportController ctrl;
  const OrderProductGraphAndTable({Key? key, required this.ctrl,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: BigText(text:'Orders By product'.toUpperCase() ),
          ),
          Card(
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade200),
              columns: const [
                DataColumn(label: Text("Title")),
                DataColumn(label: Text("Quantity")),
                DataColumn(label: Text("Revenue")),
              ],
              rows: List.generate(ctrl.sortByFoodList.length, (index) {
                return DataRow(cells: [
                  DataCell(Text(ctrl.sortByFoodList[index].title)),
                  DataCell(Text('${ctrl.sortByFoodList[index].qtyTotal}')),
                  DataCell(Text('${ctrl.sortByFoodList[index].priceTotal}')),
                ]);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
