import 'dart:io';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/routes/route_helper.dart';
import '../../alerts/common_alerts.dart';
import '../../alerts/show_tables_alert/table_shift_select_alert.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/strings/my_strings.dart';
import '../../screens/table_manage_screen/controller/table_manage_controller.dart';
import '../../widget/common_widget/add_category_card.dart';
import '../../widget/common_widget/add_catogory_card_text_field.dart';
import '../../widget/common_widget/catogory_card.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/create_table_screen/table_widget.dart';

class TableShiftSelectContent extends StatelessWidget {
  const TableShiftSelectContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CrossFadeState stateCategory = CrossFadeState.showFirst;
    return Scaffold(
      body: GetBuilder<TableManageController>(builder: (ctrl) {
        bool horizontal = 1.sh < 1.sw ? true : false;

        return ctrl.isLoading == true
            ? const MyLoading()
            : SafeArea(
                child: CustomScrollView(
                  primary: false,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.all(20.sp),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.sp,
                          mainAxisSpacing: 18.sp,
                          crossAxisSpacing: 18.sp,
                          childAspectRatio: 2 / 2.8,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return TableWidget(
                              showOrder: false,
                              shapeId: ctrl.myTableChairSet[index].tableShape ?? 1,
                              tableNumber: ctrl.myTableChairSet[index].tableNumber ?? -1,
                              tableId: ctrl.myTableChairSet[index].tableId ?? -1,
                              roomName: ctrl.myTableChairSet[index].roomName ?? MAIN_ROOM,
                              onTap: () {
                                ctrl.shiftOrLinkOrUnLinkTable(
                                  newTableId: ctrl.myTableChairSet[index].tableId ?? -1,
                                  newTableNumber: ctrl.myTableChairSet[index].tableNumber ?? -1,
                                  newRoom: ctrl.myTableChairSet[index].roomName ?? MAIN_ROOM,
                                );
                              },
                            );
                          },
                          childCount: ctrl.myTableChairSet.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
