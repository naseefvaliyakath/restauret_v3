import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../screens/create_table_screen/controller/create_table_controller.dart';

class TableShapeDropDown extends StatefulWidget {
  const TableShapeDropDown({Key? key}) : super(key: key);

  @override
  TableShapeDropDownState createState() => TableShapeDropDownState();
}

class TableShapeDropDownState extends State<TableShapeDropDown> {
  String _selected  = '1';

  final List<Map> _myJson = [
    {"id": '1', "image": "assets/image/rectangle.png", "name": "Rectangle"},
    {"id": '2', "image": "assets/image/square.png", "name": "Square"},
    {"id": '3', "image": "assets/image/circle.png", "name": "Circle"},
    {"id": '4', "image": "assets/image/oval.png", "name": "Over"},
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.h),
          height: 0.05.sh,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  focusColor:Colors.white,
                  isDense: true,
                  hint: Text(
                    "Table Shape",
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.grey,
                    ),
                  ),
                  value: _selected,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selected = newValue ?? '1';
                      Get.find<CreateTableController>().updateTableShape(newValue ?? '1');
                    });

                    print(_selected);
                  },
                  items: _myJson.map((Map map) {
                    return DropdownMenuItem<String>(
                      value: map["id"].toString(),
                      // value: _mySelection,
                      child: SizedBox(
                        width: 0.3 * 1.sw,
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.asset(
                                map["image"],
                                width: 35.sp,
                                height: 35.sp,
                                fit: BoxFit.contain,
                              ),
                            ),
                            17.horizontalSpace,
                            Flexible(
                              child: Text(
                                map["name"],
                                style: TextStyle(fontSize: 12.sp),
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
