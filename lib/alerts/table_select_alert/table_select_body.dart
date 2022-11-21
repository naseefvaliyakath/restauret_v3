import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rest_verision_3/models/room_response/room.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';
import 'package:rest_verision_3/widget/common_widget/common_text/mid_text.dart';
import 'package:rest_verision_3/widget/common_widget/common_text/small_text.dart';
import 'package:rest_verision_3/widget/common_widget/loading_page.dart';
import '../../constants/strings/my_strings.dart';
import '../../widget/common_widget/add_catogory_card_text_field.dart';
import '../common_alerts.dart';

class TableSelectBody extends StatelessWidget {
  const TableSelectBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? selectedValue;
    return GetBuilder<BillingScreenController>(builder: (ctrl) {
      return Container(
        width: 0.75.sw,
        color: Colors.white,
        padding: EdgeInsets.all(10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                const MidText(text: 'SELECT ROOM'),
                3.verticalSpace,
                AnimatedSwitcher(
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  duration: const Duration(seconds: 1),
                  child: ctrl.showAddRoom
                      ? ctrl.addRoomLoading
                          ? const MyLoading()
                          : AddCategoryCardTextField(
                              onTapAdd: () {
                                ctrl.insertRoom();
                              },
                              onTapBack: () => ctrl.updateShowAddRoom(false),
                              nameController: ctrl.roomNameTD,
                              height: 42.h,
                            )
                      : Center(
                          key: const Key('2'),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              alignment: AlignmentDirectional.center,
                              isExpanded: true,
                              hint: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.room_outlined,
                                    size: 16.sp,
                                    color: Colors.black,
                                  ),
                                  4.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      ctrl.selectedRoom.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: ctrl.myRoom
                                  .map((item) => DropdownMenuItem<Room>(
                                        alignment: AlignmentDirectional.centerEnd,
                                        value: item,
                                        child: GestureDetector(
                                          onLongPress: () {
                                            twoFunctionAlert(
                                              context: context,
                                              onTap: () {
                                                ctrl.deleteRoom(roomId: item.room_id ?? -1, roomName: item.roomName ?? MAIN_ROOM);
                                              },
                                              onCancelTap: () {},
                                              title: 'Delete ?',
                                              subTitle: 'do you want to delete thi item ?',
                                            );
                                          },
                                          child: SizedBox(
                                            height: double.maxFinite,
                                            width: double.maxFinite,
                                            child: Text(
                                              (item.roomName ?? MAIN_ROOM).toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (value) {
                                //? casting object to Room
                                Room room = value as Room;
                                ctrl.updateSelectedRoom(room.roomName ?? MAIN_ROOM);
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14.sp,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                              buttonHeight: 50.sp,
                              buttonWidth: 160.sp,
                              buttonPadding: EdgeInsets.only(left: 14.w, right: 14.w),
                              buttonDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                                color: Colors.white,
                              ),
                              buttonElevation: 2,
                              itemHeight: 40.sp,
                              itemPadding: EdgeInsets.only(left: 14.w, right: 14.w),
                              dropdownMaxHeight: 200.sp,
                              dropdownWidth: 200.sp,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                              ),
                              dropdownElevation: 8,
                              scrollbarRadius: Radius.circular(40.r),
                              scrollbarThickness: 0,
                              scrollbarAlwaysShow: true,
                              offset: const Offset(-20, 0),
                            ),
                          ),
                        ),
                ),
                TextButton(
                    onPressed: () => ctrl.updateShowAddRoom(true),
                    child: const MidText(
                      text: 'Add new room',
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const SmallText(text: 'SELECT TABLE'),
                    3.verticalSpace,
                    Center(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.table_bar_rounded,
                                size: 14.sp,
                                color: Colors.black,
                              ),
                              6.horizontalSpace,
                              Expanded(
                                child: Text(
                                  'T-${ctrl.selectedTable}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: ctrl.tableNumber
                              .map((item) => DropdownMenuItem<int>(
                                    value: item,
                                    child: Text(
                                      'T - $item',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            ctrl.updateSelectedTable(int.parse(value.toString()));
                          },
                          iconSize: 14.sp,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.grey,
                          buttonHeight: 40.sp,
                          buttonWidth: 100.sp,
                          buttonPadding: EdgeInsets.only(left: 14.w, right: 14.w),
                          buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: Colors.white,
                          ),
                          buttonElevation: 2,
                          itemHeight: 40.sp,
                          itemPadding: const EdgeInsets.only(left: 14, right: 14),
                          dropdownMaxHeight: 200.sp,
                          dropdownWidth: 100.sp,
                          dropdownPadding: null,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                          ),
                          dropdownElevation: 8,
                          scrollbarRadius: const Radius.circular(40),
                          scrollbarThickness: 0,
                          scrollbarAlwaysShow: false,
                          offset: const Offset(-20, 0),
                        ),
                      ),
                    ),
                  ],
                ),
                5.horizontalSpace,
                Column(
                  children: [
                    const SmallText(text: 'SELECT CHAIR'),
                    3.verticalSpace,
                    Center(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.chair_alt,
                                size: 14.sp,
                                color: Colors.black,
                              ),
                              6.horizontalSpace,
                              Expanded(
                                child: Text(
                                  'C-${ctrl.selectedChair}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: ctrl.chairNumber
                              .map((item) => DropdownMenuItem<int>(
                                    value: item,
                                    child: Text(
                                      'C-$item',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            ctrl.updateSelectedChair(int.parse(value.toString()));
                          },
                          iconSize: 14.sp,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.grey,
                          buttonHeight: 40.sp,
                          buttonWidth: 100.sp,
                          buttonPadding: EdgeInsets.only(left: 14.w, right: 14.w),
                          buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: Colors.white,
                          ),
                          buttonElevation: 2,
                          itemHeight: 40.sp,
                          itemPadding: const EdgeInsets.only(left: 14, right: 14),
                          dropdownMaxHeight: 200.sp,
                          dropdownWidth: 100.sp,
                          dropdownPadding: null,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                          ),
                          dropdownElevation: 8,
                          scrollbarRadius: const Radius.circular(40),
                          scrollbarThickness: 0,
                          scrollbarAlwaysShow: false,
                          offset: const Offset(-20, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
