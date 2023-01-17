import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/constants/app_colors/app_colors.dart';
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

  const TableWidget({Key? key,
    required this.shapeId,
    required this.onTap,
    required this.tableId,
    this.showOrder = true,
    required this.tableNumber,
    this.showLinkButton = false,
    required this.roomName})
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
      final GlobalKey draggableKey = GlobalKey();

      //? retrieving array of kot fot this table only
      List<KitchenOrder> orderInTable = [];
      for (var order in ctrl.kotBillingItems) {
        for (var table in order.kotTableChairSet!) {
          if (table['tableId'] == tableId) {
            orderInTable.add(order);
          }
        }
      }

      return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              if (showLinkButton) ...[
                Positioned(
                  left: constraints.maxWidth/2 - 35.sp,
                  child: DragTarget(
                    builder: (context, candidateData, rejectedData) {
                      return ShakeWidget(
                          autoPlay: true,
                          duration: const Duration(milliseconds: 1000),
                          shakeConstant: ShakeDefaultConstant2(),
                          enableWebMouseHover: false,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              padding: EdgeInsets.all(15.sp),
                              color: AppColors.mainColor,
                              child: Icon(
                                Icons.add,
                                size: 24.sp,
                                color: Colors.white,
                              ),
                            ),
                          ));
                    },
                    onMove: (details) {
                      ctrl.isDraggableOnLinkButton = true;
                    },
                    onLeave: (data) {
                      HapticFeedback.mediumImpact();
                      ctrl.isDraggableOnLinkButton = false;
                    },
                    onWillAccept: (data) {
                      return false;
                    },
                  ),
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
                            HapticFeedback.mediumImpact();
                            ctrl.updateDragStarted(true);
                          },
                          onDragEnd: (details) {
                            ctrl.updateDragStarted(false);
                          },
                          delay: const Duration(milliseconds: 500),
                          data: {
                            'tableNumber': tableNumber,
                            'tableId': tableId,
                            'kotId': order.Kot_id,
                          },
                          dragAnchorStrategy: (draggable, context, position) {
                            return const Offset(25, 60);
                          },
                          feedbackOffset: const Offset(0, -30),
                          feedback: Card(
                            key: draggableKey,
                            child: SizedBox(width: 50, height: 50, child: OrderWidget(text: '${order.Kot_id}', onTap: () {})),
                          ),
                          child: OrderWidget(
                              text: '${order.Kot_id}',
                              color: Colors.primaries[(order.Kot_id ?? 0) % 10],
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
    });
  }
}
