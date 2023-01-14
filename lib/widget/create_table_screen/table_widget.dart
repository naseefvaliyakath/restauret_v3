import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/models/kitchen_order_response/kitchen_order.dart';
import '../../alerts/table_manage_alert/table_manage_alert.dart';
import '../../screens/create_table_screen/controller/create_table_controller.dart';
import '../../screens/table_manage_screen/controller/table_manage_controller.dart';
import 'order_widget.dart';
import 'table_shape.dart';

class TableWidget extends StatelessWidget {
  final int shapeId;
  final int tableId;
  final int tableNumber;
  final Function onTap;
  final bool showOrder;
  final bool showLinkButton;
  final String roomName;

  const TableWidget(
      {Key? key,
      required this.shapeId,
      required this.onTap,
      required this.tableId,
      this.showOrder = true,
      required this.tableNumber,
      this.showLinkButton = false, required this.roomName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 200.sp;
    double height = 260.sp;
    double radius = 5.r;
    //? rectangle
    if (shapeId == 1) {
      width = 260.sp;
      height = 200.sp;
      radius = 5.r;
    }
    //? square
    else if (shapeId == 2) {
      width = 260.sp;
      height = 260.sp;
      radius = 5.r;
    } else if (shapeId == 3) {
      width = 260.sp;
      height = 260.sp;
      radius = 100.r;
    } else if (shapeId == 4) {
      width = 260.sp;
      height = 200.sp;
      radius = 100.r;
    } else {
      width = 200.sp;
      height = 260.sp;
      radius = 5.r;
    }
    return GetBuilder<TableManageController>(builder: (ctrl) {
      final GlobalKey _draggableKey = GlobalKey();

      //? retrieving array of kot fot this table only
      List<KitchenOrder> orderInTable = [];
      for (var order in ctrl.kotBillingItems) {
        for (var table in order.kotTableChairSet!) {
          if (table['tableId'] == tableId) {
            orderInTable.add(order);
          }
        }
      }

      // Visibility(
      //   child: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
      //   maintainSize: true,
      //   maintainAnimation: true,
      //   maintainState: true,
      //   visible: false,
      // ),

      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            if (showLinkButton) ...[
              DragTarget(
                builder: (context, candidateData, rejectedData) {
                  return ShakeWidget(
                      autoPlay: true,
                      shakeConstant: ShakeDefaultConstant1(),
                      enableWebMouseHover: false,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.red,
                        ),
                      ));
                },
                onMove: (details) {
                  print('qqqqqqqqqqqqqq');
                },
                onLeave: (data) {
                  print('rrrrrrrrrrr');
                },
                onWillAccept: (data) {
                  return false;
                },
              )
            ],
            Center(
                child: TableShape(
                  text: "Table $tableNumber",
                  width: height - 150.sp,
                  height: width - 150.sp,
                  onLongTap: () {},
                  onTap: onTap,
                  radius: radius,
                )),
            showOrder
                ? Positioned(
                    top: 0.h,
                    bottom: 0.h,
                    child: SizedBox(
                      width: 40.sp,
                      height: height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: orderInTable.map((order) {
                          return Expanded(
                            child: LongPressDraggable(
                              onDragStarted: () {
                                ctrl.updateDragStarted(true);
                              },
                              onDragEnd: (details) {
                                ctrl.updateDragStarted(false);
                              },
                              delay: Duration(milliseconds: 500),
                              data: {
                                'tableNumber': tableNumber,
                                'tableId': tableId,
                                'kotId': order.Kot_id,
                              },
                              dragAnchorStrategy: (draggable, context, position) {
                                return  const Offset(25, 60);
                              },
                              feedbackOffset: const Offset(0, -30),
                              feedback: Card(
                                key: _draggableKey,
                                child: SizedBox(width: 50,height: 50, child: OrderWidget(text: '${order.Kot_id}', onTap: () {})),
                              ),
                              child: OrderWidget(
                                  text: '${order.Kot_id}',
                                  onTap: () {
                                    viewOrderInTableAlert(context: context, kot: order, tableNumber: tableNumber, tableId: tableId);
                                  }),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      );
    });
  }
}
