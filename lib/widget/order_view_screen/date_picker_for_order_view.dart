import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DatePickerForOrderView extends StatelessWidget {
  final DateTimeRange dateTime;
  final Function onTap;
  final MainAxisAlignment maninAxisAlignment;
  const DatePickerForOrderView({Key? key, required this.onTap, required this.dateTime,  this.maninAxisAlignment = MainAxisAlignment.center}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return Flexible(
      child: InkWell(
        onTap: () async {
         await onTap();
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          child: SizedBox(
            width: horizontal ?  200.w : double.maxFinite,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: horizontal ? 16.h :  8.h),
                child: Row(
                  mainAxisAlignment: maninAxisAlignment,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                      size: 20.sp,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0.w),
                      child: FittedBox(
                        child: Text(
                          '${DateFormat('dd-MM-yyyy').format(dateTime.start)} - ${DateFormat('dd-MM-yyyy').format(dateTime.end)}',
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize:horizontal ? 20.sp :  13.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
