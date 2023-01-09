import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors/app_colors.dart';

class AddCategoryCardTextField extends StatelessWidget {
  final Function onTapAdd;
  final Function onTapBack;
  final double height;
  final TextEditingController nameController;

  const AddCategoryCardTextField({
    Key? key,
    required this.onTapAdd,
    required this.onTapBack,
    required this.nameController,
    required this.height,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: SizedBox(
        height: height,
        width: horizontal ? 0.15.sw : 0.4.sw,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => onTapBack(),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        color: Colors.white,
                        width: 30.h,
                        height: 30.h,
                        child: const Center(
                          child: Icon(Icons.arrow_back_outlined),
                        ),
                      )),
                ),
                Flexible(
                  child: TextField(
                    controller: nameController,
                    maxLines: 1,
                    autofocus: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(13),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: horizontal ? 20.sp :  14.sp,
                      ),
                      filled: true,
                      isDense: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),

                //onTap for add category
                InkWell(
                  onTap: () => onTapAdd(),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        color: Colors.white,
                        width: 30.h,
                        height: 30.h,
                        child: const Center(
                          child: Icon(Icons.add),
                        ),
                      )),
                ),

                6.horizontalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
