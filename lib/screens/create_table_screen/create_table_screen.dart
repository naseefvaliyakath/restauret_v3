import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../routes/route_helper.dart';
import '../../widget/common_widget/buttons/progress_button.dart';
import '../../widget/common_widget/common_text/heading_rich_text.dart';
import '../../widget/common_widget/notification_icon.dart';
import '../../widget/common_widget/text_field_widget.dart';
import '../../widget/create_table_screen/table_widget.dart';
import '../../widget/create_table_screen/table_shape_drop_down.dart';
import 'controller/create_table_controller.dart';


class CreateTableScreen extends StatelessWidget {
  const CreateTableScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{
        Get.offNamed(RouteHelper.getTableManageScreen());
        return true;
      },
      child: Scaffold(
        body: GetBuilder<CreateTableController>(builder: (ctrl) {
          bool horizontal = 1.sh < 1.sw ? true : false;
          return SafeArea(
            child: Center(
              child: SizedBox(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Column(
                    children: [
                      // heading
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //back arrow
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 24.sp,
                              ),
                              onPressed: () {
                                Get.offNamed(RouteHelper.getTableManageScreen());
                              },
                              splashRadius: 24.sp,
                            ),
                            // heading my restaurant
                            const HeadingRichText(name: 'Create your table'),
                            //notification
                            NotificationIcon(onTap: (){},),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: horizontal ?  100.w : 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              10.verticalSpace,
                              SizedBox(
                                child: TableWidget(showOrder: false,shapeId: ctrl.tableShape, onTap: (){}, tableId: -1,tableNumber: -1,)
                              ),
                              SizedBox(
                                height: 1.sh * 0.03,
                              ),
                              5.verticalSpace,
                              const TableShapeDropDown(),
                              5.verticalSpace,
                              SizedBox(
                                width: 280.sp,
                                height: 50.sp,
                                child: TextFieldWidget(
                                  hintText: 'Enter table number',
                                  hintSize:20.sp,
                                  isNumberOnly: true,
                                  isDens: true,
                                  textEditingController: ctrl.tableNumberController,
                                  borderRadius: 15.r,
                                  txtLength: 3,
                                  onChange: (_) {},
                                ),
                              ),
                              5.verticalSpace,
                              SizedBox(
                                width: horizontal ? 0.2.sw :  1.sw * 0.4,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ProgressButton(
                                        btnCtrlName: 'createTable',
                                        text: 'Create Table',
                                        ctrl: ctrl,
                                        color: const Color(0xfff25f27),
                                        onTap: () async {
                                          await ctrl.insertTable();
                                        },
                                      ),),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )

              ),
            ),
          );
        }),
      ),
    );
  }
}