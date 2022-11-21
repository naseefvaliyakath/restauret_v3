import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rest_verision_3/alerts/kitchen_mode_kot_alert/progress_btn_for_kot_tile.dart';
import 'package:rest_verision_3/constants/strings/my_strings.dart';
import 'package:rest_verision_3/models/kitchen_order_response/kitchen_order.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../constants/app_colors/app_colors.dart';
import '../../screens/kitchen_mode_screen/kitchen_mode_main/controller/kitchen_mode_main_controller.dart';

class KitchenKotListItemTile extends StatefulWidget {
  final int index;
  final KitchenOrder kotOrder;
  final Function onLongTap;

  const KitchenKotListItemTile({
    Key? key,
    required this.index,
    required this.onLongTap, 
    required this.kotOrder,
  }) : super(key: key);

  @override
  State<KitchenKotListItemTile> createState() => _KitchenKotListItemTileState();
}

class _KitchenKotListItemTileState extends State<KitchenKotListItemTile> {

  //? to show and hide single item order status btns
  bool isTappedTile = false;
  //? single item order status update buttons
  RoundedLoadingButtonController btnControllerProgressUpdateSingleKotSts = RoundedLoadingButtonController();
  RoundedLoadingButtonController btnControllerReadyUpdateSingleKotSts = RoundedLoadingButtonController();
  RoundedLoadingButtonController btnControllerPendingUpdateSingleKotSts = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<KitchenModeMainController>(builder: (ctrl) {
      return InkWell(
        onLongPress: () {
          widget.onLongTap();
        },
        //? to close keyboard in search field
        onTap: () {
          //? toggling bool to show and hide tile expansion
           setState(() {
             isTappedTile = !isTappedTile;
           });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: (widget.index % 2 == 0) ? AppColors.textHolder : const Color(0xffd2e3ee),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5.r), topRight: Radius.circular(5.r))),
              height: 50.sp,
              width: 1.sw * 0.9,
              padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 2.sp),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 1.sw * 0.08,
                      padding: EdgeInsets.only(left: 5.sp),
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          (widget.index+1).toString(),
                          maxLines: 1,
                          style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 1.sp,
                    ),
                    SizedBox(
                      width: 1.sw * 0.485,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.kotOrder.fdOrder?[widget.index].name ?? '',
                              maxLines: 1,
                              style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.kotOrder.fdOrder?[widget.index].ktNote ?? '',
                              maxLines: 1,
                              style: TextStyle(fontSize: 18.sp, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 1.sp,
                    ),
                    SizedBox(
                      width: 1.sw * 0.065,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.fitWidth,
                        child: Text(
                          (widget.kotOrder.fdOrder?[widget.index].qnt ?? 0).toString(),
                          maxLines: 1,
                          style: TextStyle(fontSize: 23.sp),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 1.sp,
                    ),
                    SizedBox(
                      width: 1.sw * 0.08,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.kotOrder.fdOrder?[widget.index].ordStatus ?? PENDING,
                          style: TextStyle(
                              fontSize: 23.sp,
                              color: widget.kotOrder.fdOrder?[widget.index].ordStatus == READY
                                  ? Colors.green
                                  : widget.kotOrder.fdOrder?[widget.index].ordStatus == PENDING
                                      ? AppColors.mainColor_2
                                      : widget.kotOrder.fdOrder?[widget.index].ordStatus ==
                                              PROGRESS
                                          ? Colors.indigo
                                          : Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              decoration: BoxDecoration(
                  color: (widget.index % 2 == 0) ? AppColors.textHolder : const Color(0xffd2e3ee),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.r), bottomRight: Radius.circular(5.r))),
              height: isTappedTile ? 33.sp : 0,
              width: 1.sw * 0.9,
              padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 2.sp),
              margin: EdgeInsets.only(bottom: 2.sp),
              duration: const Duration(milliseconds: 300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: SizedBox(
                      height: 20.sp,
                      child: ProgressBtnForKotTile(
                        text: 'Progress',
                        btnCtrl: btnControllerProgressUpdateSingleKotSts,
                        bgColor: Colors.indigo,
                        onTap: () async {
                          await ctrl.updateSingleOrderStatus(
                            context: context,
                            kotId: widget.kotOrder.Kot_id ?? -1,
                            fdOrderIndex: widget.index,
                            fdOrderSingleStatus: PROGRESS,
                            btnControllerUpdateSingleKotSts: btnControllerProgressUpdateSingleKotSts,
                          );
                        },
                      ),
                    ),
                  ),
                  3.horizontalSpace,
                  Flexible(
                    child: SizedBox(
                      height: 20.sp,
                      child: ProgressBtnForKotTile(
                        text: 'Ready',
                        btnCtrl: btnControllerReadyUpdateSingleKotSts,
                        bgColor: Colors.green,
                        onTap: () async {
                          await ctrl.updateSingleOrderStatus(
                            context: context,
                            kotId: widget.kotOrder.Kot_id ?? -1,
                            fdOrderIndex: widget.index,
                            fdOrderSingleStatus: READY,
                            btnControllerUpdateSingleKotSts: btnControllerReadyUpdateSingleKotSts,
                          );
                        },
                      ),
                    ),
                  ),
                  3.horizontalSpace,
                  Flexible(
                    child: SizedBox(
                      height: 20.sp,
                      child: ProgressBtnForKotTile(
                        text: 'Pending',
                        btnCtrl: btnControllerPendingUpdateSingleKotSts,
                        bgColor: Colors.orangeAccent,
                        onTap: () async {
                          await ctrl.updateSingleOrderStatus(
                            context: context,
                            kotId: widget.kotOrder.Kot_id ?? -1,
                            fdOrderIndex: widget.index,
                            fdOrderSingleStatus: PENDING,
                            btnControllerUpdateSingleKotSts: btnControllerPendingUpdateSingleKotSts,
                          );
                        },
                      ),
                    ),
                  ),
                  3.horizontalSpace,
                  Flexible(
                    child: SizedBox(
                      height: 20.sp,
                      child: ProgressBtnForKotTile(
                        text: 'Reject',
                        btnCtrl: btnControllerPendingUpdateSingleKotSts,
                        bgColor: Colors.redAccent,
                        onTap: () async {
                          await ctrl.updateSingleOrderStatus(
                            context: context,
                            kotId: widget.kotOrder.Kot_id ?? -1,
                            fdOrderIndex: widget.index,
                            fdOrderSingleStatus: REJECT,
                            btnControllerUpdateSingleKotSts: btnControllerPendingUpdateSingleKotSts,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
