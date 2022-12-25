import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rest_verision_3/screens/report_screen/controller/report_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
            TextSpan(text: 'Sales Report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.sp, color: AppColors.textColor)),
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

        int totalOrder = 0;
        num totalCash = 0;
        Map<String, num> ordersByTypeMap = {};
        List<OrdersByType> ordersByTypeList = [];

        Map<String, Map<String, num>> sortByFoodMap = {};
        List<OrdersByFoodName> sortByFoodList = [];

        Map<String, num> ordersByPaymentTypeMap = {};
        List<OrdersByPaymentMethod> ordersByPaymentTypeList = [];

        Map<String, num> ordersByOnlineAppMap = {};
        List<OrdersByOnlineApp> ordersByOnlineAppList = [];


        for (var element in ctrl.mySettledItem) {
          totalOrder += 1;
          totalCash += element.grandTotal ?? 0;

          // ordersByType
          if (element.fdOrderType != null) {
            if (ordersByTypeMap[element.fdOrderType] == null) {
              ordersByTypeMap[element.fdOrderType!] = 0;
            }
            ordersByTypeMap[element.fdOrderType!] = ordersByTypeMap[element.fdOrderType]! + 1;
          }

          //GroupBypayment type
          if (element.paymentType != null) {
            if (ordersByPaymentTypeMap[element.paymentType] == null) {
              ordersByPaymentTypeMap[element.paymentType!] = 0;
            }
            ordersByPaymentTypeMap[element.paymentType!] = ordersByPaymentTypeMap[element.paymentType]! + 1;
          }

          //Group by online app
          if (element.fdOnlineApp != null) {
            if (ordersByOnlineAppMap[element.fdOnlineApp] == null) {
              ordersByOnlineAppMap[element.fdOnlineApp!] = 0;
            }
            ordersByOnlineAppMap[element.fdOnlineApp!] = ordersByOnlineAppMap[element.fdOnlineApp]! + 1;
          }

          //sort by food name
          if (element.fdOrder != null) {
            for (var element in element.fdOrder!) {
              if (element.name == null || element.qnt == null || element.price == null) {
                continue;
              }
              if (sortByFoodMap[element.name] == null) {
                sortByFoodMap[element.name!] = {'qty': 0, 'total': 0};
              }
              num qty = (sortByFoodMap[element.name!]!['qty'])! + element.qnt!;
              num total = (sortByFoodMap[element.name!]!['total'])! + (element.price! * element.qnt!);
              sortByFoodMap[element.name!] = {'qty': qty, 'total': total};
            }
          }
        }

        ordersByTypeMap.forEach((key, value) {
          ordersByTypeList.add(OrdersByType(type: key, orderCount: value));
        });

        ordersByPaymentTypeMap.forEach((key, value) {
          ordersByPaymentTypeList.add(OrdersByPaymentMethod(paymentMethod: key, orderCount: value));
        });

        ordersByOnlineAppMap.forEach((key, value) {
          ordersByOnlineAppList.add(OrdersByOnlineApp(appName: key, orderCount: value));
        });

        sortByFoodMap.forEach((key, value) {
          sortByFoodList.add(OrdersByFoodName(title: key, qtyTotal: value['qty']??0,priceTotal: value['total']??0));
        });

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
                        ListTile(
                          title: Text('total order: $totalOrder'),
                        ),
                        ListTile(
                          title: Text('totalCash : $totalCash'),
                        ),
                        SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          title: ChartTitle(text: 'ORDERS BY TYPE'),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: [
                            StackedColumnSeries(
                                dataSource: ordersByTypeList,
                                xValueMapper: (OrdersByType data, _) => data.type,
                                yValueMapper: (OrdersByType data, _) => data.orderCount),
                          ],
                        ),
                        ListTile(
                          title: Text('Qty',style: TextStyle(fontWeight: FontWeight.bold),),
                          leading: Text('Title',style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Text('Total',style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Column(
                            children: List.generate(sortByFoodList.length, (index) {
                          return ListTile(
                            title: Text(sortByFoodList[index].title),
                            leading: Text('${sortByFoodList[index].qtyTotal}'),
                            trailing: Text('${sortByFoodList[index].priceTotal}'),
                          );
                        })),
                        SfCircularChart(
                          // primaryXAxis: CategoryAxis(),
                          title: ChartTitle(text: 'ORDERS BY PAYMENT TYPE'),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          legend: Legend(isVisible: true,position: LegendPosition.bottom,overflowMode: LegendItemOverflowMode.wrap),
                          series: [
                            PieSeries<OrdersByPaymentMethod, String>(
                              dataSource: ordersByPaymentTypeList,
                              xValueMapper: (OrdersByPaymentMethod data, _) => data.paymentMethod,
                              yValueMapper: (OrdersByPaymentMethod data, _) => data.orderCount,
                              // radius: '60%',
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                              ),
                            ),
                          ],
                        ),
                        SfCircularChart(
                          // primaryXAxis: CategoryAxis(),
                          title: ChartTitle(text: 'ORDERS BY ONLINE APP'),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          legend: Legend(isVisible: true,position: LegendPosition.bottom,overflowMode: LegendItemOverflowMode.wrap),
                          series: [
                            PieSeries<OrdersByOnlineApp, String>(
                              dataSource: ordersByOnlineAppList,
                              xValueMapper: (OrdersByOnlineApp data, _) => data.appName,
                              yValueMapper: (OrdersByOnlineApp data, _) => data.orderCount,
                              // radius: '60%',
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 250)
                      ],
                    ),
                  ),
                ),
        );
      }),
    );
  }
}

class OrdersByType {
  OrdersByType({required this.type, required this.orderCount});

  final String type;
  final num orderCount;
}

class OrdersByPaymentMethod {
  OrdersByPaymentMethod({required this.paymentMethod, required this.orderCount});

  final String paymentMethod;
  final num orderCount;
}

class OrdersByOnlineApp {
  OrdersByOnlineApp({required this.appName, required this.orderCount});

  final String appName;
  final num orderCount;
}

class OrdersByFoodName {
  OrdersByFoodName({required this.title, required this.qtyTotal, required this.priceTotal});

  final String title;
  final num qtyTotal;
  final num priceTotal;
}