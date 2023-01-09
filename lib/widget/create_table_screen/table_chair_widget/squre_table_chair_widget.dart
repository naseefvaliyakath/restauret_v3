import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../screens/create_table_screen/controller/create_table_controller.dart';
import '../chair_widget.dart';
import '../table_rectangle.dart';



class SquareTableChairWidget extends StatelessWidget {
  const SquareTableChairWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 230.w,
      width: 230.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              offset: const Offset(4, 6),
              blurRadius: 4,
              color: Colors.black.withOpacity(0.3),
            )
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1.sp)),
      child: Container(
        padding: EdgeInsets.all(5.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Stack(
          children: <Widget>[
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GetBuilder<CreateTableController>(builder: (controller) {
                  return Stack(
                    children: [
                      //table
                      Center(
                        child: TableRectangle(
                          onLongTap: (){},
                          onTap: (){},
                          text: 'TABLE',
                          width: constraints.maxWidth - 100.w,
                          height: constraints.maxHeight - 100.w,
                        ),
                      ),

                      //left side
                      Positioned(
                        top: 50.h,
                        child: SizedBox(
                          width: 40.w,
                          height: constraints.maxHeight - 100.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List<Widget>.generate(
                                controller.leftChairCount, (index) {
                              return ChairWidget(text: 'C $index');
                            }).toList(growable: true),
                          ),
                        ),
                      ),
                      //right side
                      Positioned(
                        top: 50.h,
                        right: 0,
                        child: SizedBox(
                          width: 40.w,
                          height: constraints.maxHeight - 100.w,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List<Widget>.generate(
                                  controller.rightChairCount, (index) {
                                return ChairWidget(text: 'C $index');
                              }).toList(growable: true)),
                        ),
                      ),
                      //top side
                      Positioned(
                        top: 0,
                        left: 50.w,
                        child: SizedBox(
                          width: constraints.maxWidth - 100.w,
                          height: 40.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List<Widget>.generate(
                                  controller.topChairCount, (index) {
                                return ChairWidget(text: 'C $index');
                              }).toList(growable: true)
                          ),
                        ),
                      ),
                      //bottom side
                      Positioned(
                        bottom: 0,
                        left: 50.w,
                        child: SizedBox(
                          width: constraints.maxWidth - 100.w,
                          height: 40.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List<Widget>.generate(
                                  controller.bottomChairCount, (index) {
                                return ChairWidget(text: 'C $index');
                              }).toList(growable: true)
                          ),
                        ),
                      ),
                    ],
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
