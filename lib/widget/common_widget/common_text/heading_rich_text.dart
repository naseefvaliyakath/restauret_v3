import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/app_colors/app_colors.dart';


class HeadingRichText extends StatelessWidget {
  final String name;
  const HeadingRichText({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FittedBox(
        child: RichText(
          softWrap: false,
          text: TextSpan(children: [
            TextSpan(
                text:name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                    color: AppColors.textColor)),
          ]),
          maxLines: 1,
        ),
      ),
    );
  }
}
