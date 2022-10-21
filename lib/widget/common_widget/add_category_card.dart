import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AddCategoryCard extends StatelessWidget {

final Function onTap;

  const AddCategoryCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>onTap(),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: SizedBox(
          height: 60.h,
          width: MediaQuery.of(context).size.width * 0.33,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        color: Colors.white,
                        width: 30.h,
                        height: 30.h,
                        child: const Center(
                          child: Icon(Icons.add),
                        ),
                      )),
                  6.horizontalSpace,
                  Flexible(
                    child: Text(
                      'Add New',
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color(0xFF333333),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
