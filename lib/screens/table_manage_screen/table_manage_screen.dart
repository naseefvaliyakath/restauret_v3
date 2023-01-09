// import 'package:badges/badges.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:rest_verision_3/widget/common_widget/add_category_card.dart';
// import 'package:rest_verision_3/widget/common_widget/catogory_card.dart';
// import '../../constants/app_colors/app_colors.dart';
// import '../../routes/route_helper.dart';
// import '../../widget/common_widget/add_catogory_card_text_field.dart';
// import '../../widget/common_widget/common_text/big_text.dart';
// import '../../widget/common_widget/loading_page.dart';
// import 'controller/table_manage_controller.dart';
//
// class TableManageScreen extends StatelessWidget {
//   TableManageScreen({Key? key}) : super(key: key);
//
//   int tappedIndex = 0;
//   CrossFadeState stateCategory = CrossFadeState.showFirst;
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         //to go back from chair shift mode
//         if (Get.find<TableManageController>().chairShiftMode) {
//           Get.find<TableManageController>().updateShiftedMode(false);
//           return false;
//         } else if (Get.find<TableManageController>().linkChairMode) {
//           Get.find<TableManageController>().updateLinkChairMode(false);
//           return false;
//         } else {
//           //should make this back transition go down
//           //now this go up side so new transition
//           Get.offNamed(RouteHelper.getBillingScreenScreen());
//           return true;
//         }
//       },
//       child: Scaffold(
//         body: GetBuilder<TableManageController>(builder: (ctrl) {
//           return ctrl.isLoading == true
//               ? const MyLoading()
//               : SafeArea(
//                   child: CustomScrollView(
//                     primary: false,
//                     slivers: <Widget>[
//                       SliverAppBar(
//                         floating: true,
//                         pinned: true,
//                         leading: IconButton(
//                           icon: Icon(
//                             Icons.arrow_back,
//                             size: 24.sp,
//                           ),
//                           onPressed: () {
//                             //to go back from chare shift mode
//                             if (ctrl.chairShiftMode) {
//                               ctrl.updateShiftedMode(false);
//                             } else if (ctrl.linkChairMode) {
//                               ctrl.updateLinkChairMode(false);
//                             } else {
//                               //should make this back transition go down
//                               //now this go up side so new transition
//                               Get.offNamed(RouteHelper.getBillingScreenScreen());
//                             }
//                           },
//                           splashRadius: 24.sp,
//                         ),
//                         snap: true,
//                         title: const Text(
//                           'Manage Table',
//                           overflow: TextOverflow.fade,
//                           softWrap: false,
//                         ),
//                         titleTextStyle: TextStyle(fontSize: 26.sp, color: Colors.black, fontWeight: FontWeight.w600),
//                         actions: [
//                           Badge(
//                             badgeColor: Colors.red,
//                             child: Container(
//                                 margin: EdgeInsets.only(right: 10.w),
//                                 child: Icon(
//                                   FontAwesomeIcons.bell,
//                                   size: 24.sp,
//                                 )),
//                           ),
//                         ],
//                         bottom: PreferredSize(
//                           //if shift mode or link chair mode then increase the height of preferred size
//                           //so one heading also come
//                           preferredSize: (ctrl.chairShiftMode || ctrl.linkChairMode) ? Size.fromHeight(110.h) : Size.fromHeight(60.h),
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 SizedBox(
//                                   height: 60.h,
//                                   child: ctrl.isLoadingRoom == true
//                                       ? const SizedBox()
//                                       : ListView.builder(
//                                     physics: const BouncingScrollPhysics(),
//                                           scrollDirection: Axis.horizontal,
//                                           itemCount: ctrl.room!.isEmpty ? 0 : ctrl.room!.length + 1,
//                                           itemBuilder: (BuildContext ctx, index) {
//                                             //category's
//                                             if (index < ctrl.room!.length) {
//                                               return CategoryCard(
//                                                 onTap: () {
//                                                   ctrl.setCategoryTappedIndex(index);
//                                                 },
//                                                 color: ctrl.tappedIndex == index ? AppColors.mainColor_2 : Colors.white,
//                                                 text: ctrl.room![index].roomName.toUpperCase(),
//                                                 onLongTap: (){},
//                                               );
//                                             }
//
//                                             //add category card
//                                             else {
//                                               return AnimatedCrossFade(
//                                                 firstChild: AddCategoryCard(
//                                                   onTap: () {
//                                                     ctrl.setAddcategoryToggle(true);
//                                                     stateCategory = ctrl.addCategoryToggle == false
//                                                         ? CrossFadeState.showFirst
//                                                         : CrossFadeState.showSecond;
//                                                   },
//                                                 ),
//                                                 secondChild: ctrl.addCategoryLoading
//                                                     ? const MyLoading()
//                                                     : AddCategoryCardTextField(
//                                                         onTapAdd: () async {
//                                                           await ctrl.insertRoom();
//                                                           stateCategory = ctrl.addCategoryToggle == false
//                                                               ? CrossFadeState.showFirst
//                                                               : CrossFadeState.showSecond;
//                                                         },
//                                                         onTapBack: () {
//                                                           ctrl.setAddcategoryToggle(false);
//                                                           stateCategory = ctrl.addCategoryToggle == false
//                                                               ? CrossFadeState.showFirst
//                                                               : CrossFadeState.showSecond;
//                                                         },
//                                                         nameController: ctrl.roomNameTD,
//                                                       ),
//                                                 duration: const Duration(seconds: 1),
//                                                 crossFadeState: stateCategory,
//                                                 firstCurve: Curves.fastLinearToSlowEaseIn,
//                                                 secondCurve: Curves.linear,
//                                               );
//                                             }
//                                           },
//                                         ),
//                                 ),
//                                 // check its in shifted mode
//                                 // if in shifted mode show heading
//                                 (ctrl.chairShiftMode || ctrl.linkChairMode)
//                                     ? SizedBox(
//                                         child: Card(
//                                             elevation: 10.sp,
//                                             child: Padding(
//                                               padding: EdgeInsets.all(5.sp),
//                                               child: BigText(
//                                                 text: 'PLEASE SELECT A CHAIR',
//                                                 size: 15.sp,
//                                               ),
//                                             )),
//                                       )
//                                     : const SizedBox()
//                               ],
//                             ),
//                           ),
//                         ),
//                         backgroundColor: const Color(0xfffafafa),
//                       ),
//                       SliverToBoxAdapter(
//                         child: Wrap(
//                           runSpacing: 20.sp,
//                           // mainAxisSize: MainAxisSize.max,
//                           crossAxisAlignment: WrapCrossAlignment.start,
//                           alignment: WrapAlignment.spaceEvenly,
//                           children: [
//                             ...ctrl.selecedTableSetLIst
//                                 .asMap()
//                                 .map((i, element) {
//                                   return MapEntry(
//                                     i,
//                                     //.toString() do to in flutter table shape is String and in DB its number
//                                     element.tableShape.toString() == '1'
//                                         ? ListTileRectangleTableChairWidget(
//                                             tableIndex: i + 1,
//                                             leftChairCount: element.leftChairCount,
//                                             rightChairCount: element.rightChairCount,
//                                             topChairCount: element.topChairCount,
//                                             bottomChairCount: element.bottomChairCount,
//                                             ctrl: ctrl,
//                                             tbChr: element,
//                                             onChairTap: (String position, int chrIndex, int kotId, int tbChrIndexInDb) async {
//                                               await ctrl.getClickedTableChairId(
//                                                 context: context,
//                                                 tableIndex: i,
//                                                 tbChrIndexInDb: tbChrIndexInDb,
//                                                 tableId: element.tableId,
//                                                 position: position,
//                                                 chrIndex: chrIndex,
//                                                 kotId: kotId,
//                                               );
//                                             },
//                                           )
//                                         : element.tableShape.toString() == '2'
//                                             ? ListTileSquareTableChairWidget(
//                                                 tableIndex: i + 1,
//                                                 leftChairCount: element.leftChairCount,
//                                                 rightChairCount: element.rightChairCount,
//                                                 topChairCount: element.topChairCount,
//                                                 bottomChairCount: element.bottomChairCount,
//                                                 ctrl: ctrl,
//                                                 tbChr: element,
//                                                 onChairTap: (String position, int chrIndex, int kotId,int tbChrIndexInDb) async {
//                                                   await ctrl.getClickedTableChairId(
//                                                     context: context,
//                                                     tableIndex: i,
//                                                     tbChrIndexInDb:tbChrIndexInDb,
//                                                     tableId: element.tableId,
//                                                     position: position,
//                                                     chrIndex: chrIndex,
//                                                     kotId: kotId,
//                                                   );
//                                                 },
//                                               )
//                                             : element.tableShape.toString() == '3'
//                                                 ? ListTileCircleTableChairWidget(
//                                                     tableIndex: i + 1,
//                                                     leftChairCount: element.leftChairCount,
//                                                     rightChairCount: element.rightChairCount,
//                                                     topChairCount: element.topChairCount,
//                                                     bottomChairCount: element.bottomChairCount,
//                                                     ctrl: ctrl,
//                                                     tbChr: element,
//                                                     onChairTap: (String position, int chrIndex, int kotId,int tbChrIndexInDb) async {
//                                                       await ctrl.getClickedTableChairId(
//                                                         context: context,
//                                                         tableIndex: i,
//                                                         tbChrIndexInDb: tbChrIndexInDb,
//                                                         tableId: element.tableId,
//                                                         position: position,
//                                                         chrIndex: chrIndex,
//                                                         kotId: kotId,
//                                                       );
//                                                     })
//                                                 : element.tableShape.toString() == '4'
//                                                     ? ListTileOvalTableChairWidget(
//                                                         tableIndex: i + 1,
//                                                         leftChairCount: element.leftChairCount,
//                                                         rightChairCount: element.rightChairCount,
//                                                         topChairCount: element.topChairCount,
//                                                         bottomChairCount: element.bottomChairCount,
//                                                         ctrl: ctrl,
//                                                         tbChr: element,
//                                                         onChairTap: (String position, int chrIndex, int kotId,int tbChrIndexInDb) async {
//                                                           await ctrl.getClickedTableChairId(
//                                                             context: context,
//                                                             tableIndex: i,
//                                                             tbChrIndexInDb: tbChrIndexInDb,
//                                                             tableId: element.tableId,
//                                                             position: position,
//                                                             chrIndex: chrIndex,
//                                                             kotId: kotId,
//                                                           );
//                                                         })
//                                                     : ListTileRectangleTableChairWidget(
//                                                         tableIndex: i + 1,
//                                                         leftChairCount: element.leftChairCount,
//                                                         rightChairCount: element.rightChairCount,
//                                                         topChairCount: element.topChairCount,
//                                                         bottomChairCount: element.bottomChairCount,
//                                                         ctrl: ctrl,
//                                                         tbChr: element,
//                                                         onChairTap: (String position, int chrIndex, int kotId,int tbChrIndexInDb) async {
//                                                           await ctrl.getClickedTableChairId(
//                                                             context: context,
//                                                             tableIndex: i,
//                                                             tbChrIndexInDb: tbChrIndexInDb,
//                                                             tableId: element.tableId,
//                                                             position: position,
//                                                             chrIndex: chrIndex,
//                                                             kotId: kotId,
//                                                           );
//                                                         },
//                                                       ),
//                                   );
//                                 })
//                                 .values
//                                 .toList()
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//         }),
//         floatingActionButton: GetBuilder<TableManageController>(builder: (ctrl2) {
//           return FloatingActionBtn(
//             color: ctrl2.chairShiftMode || ctrl2.linkChairMode ? Colors.red : AppColors.mainColor_2,
//             onTap: () {
//               if (ctrl2.chairShiftMode) {
//                 Get.find<TableManageController>().updateShiftedMode(false);
//               } else if (ctrl2.linkChairMode) {
//                 Get.find<TableManageController>().updateLinkChairMode(false);
//               } else {
//                 int roomId = ctrl2.roomId;
//                 Get.offNamed(RouteHelper.getCreateTableScreen(), arguments: {"roomId": roomId});
//               }
//             },
//             icon: ctrl2.chairShiftMode || ctrl2.linkChairMode ? Icons.close : Icons.chair,
//           );
//         }),
//       ),
//     );
//   }
// }
