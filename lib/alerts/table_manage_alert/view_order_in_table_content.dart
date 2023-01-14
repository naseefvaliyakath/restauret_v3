import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_verision_3/models/kitchen_order_response/kitchen_order.dart';
import 'package:get/get.dart';
import '../../screens/table_manage_screen/controller/table_manage_controller.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/buttons/progress_button.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/common_text/mid_text.dart';
import '../kot_order_manage_alert/view_order_list_alert/view_order_list_item_heading.dart';
import '../kot_order_manage_alert/view_order_list_alert/view_order_list_item_tile.dart';
import '../show_tables_alert/table_shift_select_alert.dart';

class ViewOrderInTaleContent extends StatelessWidget {
  final KitchenOrder kot;
  final int tableNumber;
  final int tableId;

  const ViewOrderInTaleContent({Key? key, required this.kot, required this.tableNumber, required this.tableId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TableManageController>(builder: (ctrl) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.sp),
        width: 0.8.sw,
        child: MediaQuery.removePadding(
          removeBottom: true,
          removeTop: true,
          context: context,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MidText(text: 'KOT ID : ${kot.Kot_id}'),
              5.verticalSpace,
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return const ViewOrderListItemHeading();
                },
                itemCount: 1,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 1.sh * 0.7),
                child: SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ViewOrderListItemTile(
                        index: index,
                        slNumber: index + 1,
                        itemName: kot.fdOrder?[index].name ?? 'Error',
                        qnt: kot.fdOrder?[index].qnt ?? 0,
                        kitchenNote: kot.fdOrder?[index].ktNote ?? 'Error',
                        price: (kot.fdOrder?[index].price ?? 0).toDouble(),
                        ordStatus: kot.fdOrder?[index].ordStatus ?? 'pending',
                        onLongTap: () {},
                      );
                    },
                    itemCount: kot.fdOrder?.length ?? 0,
                  ),
                ),
              ),
              10.verticalSpace,
              Align(alignment: Alignment.center, child: BigText(text: 'Total Price : ${kot.totalPrice}', size: 20.sp)),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 30.h,
                    width: 1.sw * 0.25,
                    child: AppMiniButton(
                      color: Colors.cyan,
                      text: 'Ring',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                    width: 1.sw * 0.25,
                    child: AppMiniButton(
                      color: Colors.green,
                      text: 'Edit',
                      onTap: () {
                        Navigator.pop(context); //this not add then page note kill
                        ctrl.updateKotOrder(kotBillingOrder: kot);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                    width: 1.sw * 0.25,
                    child: AppMiniButton(
                      color: Colors.teal,
                      text: 'Shift',
                      onTap: () {
                        ctrl.updateShiftMode(true);
                        Navigator.pop(context);
                        ctrl.saveCurrentTableIdAndTableNumber(
                          tableId: tableId,
                          tableNumber: tableNumber,
                          kotId: kot.Kot_id ?? -1,
                        );
                        selectTableAlert(context: context);
                      },
                    ),
                  ),
                ],
              ),
              8.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 30.h,
                    width: 1.sw * 0.25,
                    child: AppMiniButton(
                      color: Colors.blueAccent,
                      text: 'Shift',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                    width: 1.sw * 0.25,
                    child: AppMiniButton(
                      color: Colors.purpleAccent,
                      text: 'Link Chair',
                      onTap: () {
                        ctrl.updateLinkMode(true);
                        Navigator.pop(context);
                        ctrl.saveCurrentTableIdAndTableNumber(
                          tableId: tableId,
                          tableNumber: tableNumber,
                          kotId: kot.Kot_id ?? -1,
                        );
                        selectTableAlert(context: context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                    width: 1.sw * 0.25,
                    child: ProgressButton(
                      btnCtrlName: 'CancelOrderInTable',
                      text: 'Cancel',
                      ctrl: ctrl,
                      color: const Color(0xffef2f28),
                      onTap: () async {
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                ],
              ),
              8.verticalSpace,
            ],
          ),
        ),
      );
    });
  }
}
