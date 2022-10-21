import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryDropDown extends StatelessWidget {
  const CategoryDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? selected;
    String selectedCatName = 'All';

    final List<Map> myJson = [
      {"id": '1', "image": "assets/image/GrilledFish.jpg", "name": "Affin Bank"},
      {"id": '2', "image": "assets/image/GrilledFish.jpg", "name": "Ambank"},
      {"id": '3', "image": "assets/image/GrilledFish.jpg", "name": "Bank Isalm"},
      {"id": '4', "image": "assets/image/GrilledFish.jpg", "name": "Bank Raky fggggggg"},
    ];
    return Center(
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(10.r),
                  isDense: true,
                  hint: Text(
                    selectedCatName,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.grey,
                    ),
                  ),
                  value: selected,
                  onChanged: (String? newValue) {
                    print(newValue);
                    selectedCatName = newValue ?? '';
                  },
                  items: myJson.map((Map map) {
                    return DropdownMenuItem<String>(
                      value: map["id"].toString(),
                      // value: _mySelection,
                      child: SizedBox(
                        width: 0.3*1.sw,
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.asset(
                                map["image"],
                                width: 25.sp,
                                height: 25.sp,
                                fit: BoxFit.cover,
                              ),
                            ),
                            3.horizontalSpace,
                            Flexible(

                              child: Text(map["name"],
                                style: TextStyle(
                                    fontSize: 12.sp
                                ),
                                softWrap: false,
                                overflow: TextOverflow.fade,),
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
