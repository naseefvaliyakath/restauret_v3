import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rest_verision_3/constants/strings/my_strings.dart';
import 'package:rest_verision_3/models/kitchen_order_response/kitchen_order.dart';

import '../../constants/app_colors/app_colors.dart';
import '../../screens/kitchen_mode_screen/kitchen_mode_main/controller/kitchen_mode_main_controller.dart';
import '../../widget/common_widget/buttons/progress_button.dart';
import '../../widget/common_widget/common_text/mid_text.dart';
import 'kitche_kot_list_item_tile.dart';
import 'kitchen_kot_list_item_heading.dart';



class KitchenKotViewAlertContent extends StatelessWidget {
  //? index of full kot order
  final int kotId;
  const KitchenKotViewAlertContent({Key? key, required this.kotId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KitchenModeMainController>(builder: (ctrl) {
      KitchenOrder kotOrder = EMPTY_KITCHEN_ORDER;
      for (var element in ctrl.allKotBillingItems) {
        if(element.Kot_id == kotId){
          kotOrder = element;
        }
      }
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.sp),
        width: 0.95.sw,
        child: MediaQuery.removePadding(
          removeBottom: true,
          removeTop: true,
          context: context,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            MidText(text: 'KOT ID : ${kotOrder.Kot_id}'),
              5.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 MidText(text: 'TYPE : ${(kotOrder.fdOrderType ?? TAKEAWAY).toUpperCase()}',size: 15.sp,),
                 MidText(text: 'STATUS : ${(kotOrder.fdOrderStatus ?? PENDING).toUpperCase()}',size: 15.sp,),
                ],
              ),
              10.verticalSpace,

              Row(
                children: const [
                  Expanded(child: KitchenKotListItemHeading()),
                ],
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 1.sh * 0.7),
                child: SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return KitchenKotListItemTile(
                        //? this index is index of items in kot order
                        index: index,
                        //? this is the index of full kot
                        kotOrder:  kotOrder,
                        onLongTap: () {},
                      );
                    },
                    itemCount:kotOrder.fdOrder?.length ?? 0,
                  ),
                ),
              ),
              15.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: SizedBox(
                      height: 40.h,
                      child: ProgressButton(
                        ctrl: ctrl,
                        btnCtrlName: 'updateFullProgressOrdStatus',
                        color: Colors.blueAccent,
                        text: 'Progress',
                        onTap: () async {
                         await ctrl.updateFullOrderStatus(kotId: kotId, fdOrderStatus: PROGRESS, context: context);
                        },
                      ),
                    ),
                  ),
                  3.horizontalSpace,
                  Flexible(
                    child: SizedBox(
                      height: 40.h,
                      child: ProgressButton(
                        ctrl: ctrl,
                        btnCtrlName: 'updateFullReadyOrdStatus',
                        color: Colors.green,
                        text: 'Ready',
                        onTap: () async {
                          await ctrl.updateFullOrderStatus(kotId: kotId, fdOrderStatus: READY, context: context);
                        },
                      ),
                    ),
                  ),
                  3.horizontalSpace,
                  Flexible(
                    child: SizedBox(
                      height: 40.h,
                      child: ProgressButton(
                        ctrl: ctrl,
                        btnCtrlName: 'updateFullPendingOrdStatus',
                        color: AppColors.mainColor_2,
                        text: 'Pending',
                        onTap: () async {
                          await ctrl.updateFullOrderStatus(kotId: kotId, fdOrderStatus: PENDING, context: context);
                        },
                      ),
                    ),
                  ),
                  3.horizontalSpace,
                  Flexible(
                    child: SizedBox(
                      height: 40.h,
                      child: ProgressButton(
                        ctrl: ctrl,
                        btnCtrlName: 'updateFullRejectOrdStatus',
                        color: Colors.red,
                        text: 'Reject',
                        onTap: () async {
                          await ctrl.updateFullOrderStatus(kotId: kotId, fdOrderStatus: REJECT, context: context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              15.verticalSpace,
            ],
          ),
        ),
      );
    });
  }
}
