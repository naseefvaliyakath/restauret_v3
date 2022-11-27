import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditUserTile extends StatelessWidget {
  final Function onTap;
  final String avatarString;
  final String name;
  final String amount;
  final Color color;
  const CreditUserTile({Key? key, required this.onTap, required this.avatarString, required this.name, required this.amount, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        await onTap();
      },
      dense: true,
      leading: CircleAvatar(
        child: Text(avatarString,style: TextStyle(fontSize: 18.sp),),
      ),
      title: Text(name,style:TextStyle(fontSize: 14.sp)),
      trailing: Text(amount,
          style:
          TextStyle(
              fontSize: 15.sp,fontWeight: FontWeight.bold, color: color),
    ));
  }
}
