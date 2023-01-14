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
import '../../widget/common_widget/add_category_card.dart';
import '../../widget/common_widget/add_catogory_card_text_field.dart';
import '../../widget/common_widget/catogory_card.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/create_table_screen/table_widget.dart';
import 'controller/table_manage_controller.dart';

class PcTableManageScreen extends StatelessWidget {
  const PcTableManageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CrossFadeState stateCategory = CrossFadeState.showFirst;
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(RouteHelper.getBillingScreenScreen(), arguments: {"billingPage": DINING});
        return false;
      },
      child: Scaffold(
        body: GetBuilder<TableManageController>(builder: (ctrl) {
          bool horizontal = 1.sh < 1.sw ? true : false;

          return ctrl.isLoading == true
              ? const MyLoading()
              : SafeArea(
                  child: CustomScrollView(
                    primary: false,
                    slivers: <Widget>[
                      SliverAppBar(
                        floating: true,
                        pinned: true,
                        leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 24.sp,
                          ),
                          onPressed: () {
                            Get.offNamed(RouteHelper.getBillingScreenScreen(), arguments: {"billingPage": DINING});
                          },
                          splashRadius: 24.sp,
                        ),
                        snap: true,
                        title: const Text(
                          'Manage Table',
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        titleTextStyle: TextStyle(fontSize: 26.sp, color: Colors.black, fontWeight: FontWeight.w600),
                        actions: [
                          Badge(
                            badgeColor: Colors.red,
                            child: Container(
                                margin: EdgeInsets.only(right: 10.w),
                                child: Icon(
                                  FontAwesomeIcons.bell,
                                  size: 24.sp,
                                )),
                          ),
                        ],
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(60.h),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 60.h,
                                  child: ctrl.isLoadingRoom == true
                                      ? const SizedBox()
                                      : Scrollbar(
                                          controller: ctrl.scrollController,
                                          trackVisibility: false,
                                          thickness: Platform.isWindows ? null : 0,
                                          child: ListView.builder(
                                            controller: ctrl.scrollController,
                                            physics: const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: ctrl.myRoom.isEmpty ? 1 : ctrl.myRoom.length + 1,
                                            itemBuilder: (BuildContext ctx, index) {
                                              if (ctrl.myRoom.isNotEmpty) {
                                                //? category's
                                                if (index < ctrl.myRoom.length) {
                                                  return SizedBox(
                                                    width: horizontal ? 50.w : null,
                                                    child: CategoryCard(
                                                      onTap: () {
                                                        ctrl.setCategoryTappedIndex(index);
                                                      },
                                                      color: ctrl.tappedIndex == index ? AppColors.mainColor_2 : Colors.white,
                                                      text: ctrl.myRoom[index].roomName ?? 'Error'.toUpperCase(),
                                                      onLongTap: () {
                                                        twoFunctionAlert(
                                                          context: context,
                                                          onTap: () {
                                                            ctrl.deleteRoom(
                                                                roomId: ctrl.myRoom[index].room_id ?? -1, roomName: ctrl.myRoom[index].roomName ?? MAIN_ROOM);
                                                          },
                                                          onCancelTap: () {},
                                                          title: 'Delete ?',
                                                          subTitle: 'do you want to delete thi item ?',
                                                        );
                                                      },
                                                    ),
                                                  );
                                                }
                                                //? add category card
                                                else {
                                                  return AnimatedCrossFade(
                                                    firstChild: SizedBox(
                                                      width: horizontal ? 50.w : null,
                                                      child: AddCategoryCard(
                                                        onTap: () {
                                                          ctrl.setAddCategoryToggle(!ctrl.addCategoryToggle);
                                                          stateCategory =
                                                              ctrl.addCategoryToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;
                                                        },
                                                      ),
                                                    ),
                                                    secondChild: ctrl.addCategoryLoading
                                                        ? const MyLoading()
                                                        : AddCategoryCardTextField(
                                                            onTapAdd: () async {
                                                              await ctrl.insertRoom();
                                                              stateCategory =
                                                                  ctrl.addCategoryToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;
                                                            },
                                                            onTapBack: () {
                                                              ctrl.setAddCategoryToggle(false);
                                                              stateCategory =
                                                                  ctrl.addCategoryToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;
                                                            },
                                                            nameController: ctrl.roomNameTD,
                                                            height: 60.h,
                                                          ),
                                                    duration: const Duration(seconds: 1),
                                                    crossFadeState: stateCategory,
                                                    firstCurve: Curves.fastLinearToSlowEaseIn,
                                                    secondCurve: Curves.linear,
                                                  );
                                                }
                                              } else {
                                                return AnimatedCrossFade(
                                                  firstChild: SizedBox(
                                                    width: horizontal ? 50.w : null,
                                                    child: AddCategoryCard(
                                                      onTap: () {
                                                        ctrl.setAddCategoryToggle(!ctrl.addCategoryToggle);
                                                        stateCategory = ctrl.addCategoryToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;
                                                      },
                                                    ),
                                                  ),
                                                  secondChild: ctrl.addCategoryLoading
                                                      ? const MyLoading()
                                                      : AddCategoryCardTextField(
                                                          onTapAdd: () async {
                                                            await ctrl.insertRoom();
                                                            stateCategory =
                                                                ctrl.addCategoryToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;
                                                          },
                                                          onTapBack: () {
                                                            ctrl.setAddCategoryToggle(false);
                                                            stateCategory =
                                                                ctrl.addCategoryToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;
                                                          },
                                                          nameController: ctrl.roomNameTD,
                                                          height: 60.h,
                                                        ),
                                                  duration: const Duration(seconds: 1),
                                                  crossFadeState: stateCategory,
                                                  firstCurve: Curves.fastLinearToSlowEaseIn,
                                                  secondCurve: Curves.linear,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        backgroundColor: const Color(0xfffafafa),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.all(20.sp),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 280.sp,
                            mainAxisSpacing: 18.sp,
                            crossAxisSpacing: 18.sp,
                            childAspectRatio: 2 / 2.8,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return TableWidget(
                                shapeId: ctrl.myTableChairSet[index].tableShape ?? 1,
                                tableNumber: ctrl.myTableChairSet[index].tableNumber ?? -1,
                                tableId: ctrl.myTableChairSet[index].tableId ?? -1,
                                onTap: () {
                                  if (ctrl.shiftMode) {
                                  } else {
                                    Get.offNamed(RouteHelper.getBillingScreenScreen(), arguments: {
                                      'roomName': ctrl.myTableChairSet[index].roomName,
                                      'room_id': ctrl.myTableChairSet[index].room_id,
                                      'tableId': ctrl.myTableChairSet[index].tableId,
                                      'tableIndex': ctrl.myTableChairSet[index].tableNumber,
                                    });
                                  }
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
        floatingActionButton: GetBuilder<TableManageController>(builder: (ctrl) {
          return FloatingActionButton(
              child: Icon(Icons.add, size: 24.sp, color: Colors.white),
              onPressed: () {
                Get.offNamed(RouteHelper.getCreateTableScreen(), arguments: {'roomId': ctrl.selectedRoomId, 'roomName': ctrl.selectedRoomName});
              });
        }),
      ),
    );
  }
}
