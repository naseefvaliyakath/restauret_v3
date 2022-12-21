import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../widget/common_widget/common_text/heading_rich_text.dart';
import '../../widget/settings_page_screen/profile_menu.dart';

class HelpVideoScreen extends StatelessWidget {
  const HelpVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    5.horizontalSpace,
                    BackButton(onPressed: () => Get.back()),
                    40.horizontalSpace,
                    const HeadingRichText(name: 'Tutorials videos'),
                  ],
                ),
                20.verticalSpace,
                ProfileMenu(
                  text: "Dash bord screen",
                  icon: Icons.ondemand_video_rounded,
                  press: () {
                  },
                ),
                ProfileMenu(
                  text: "Billing screen",
                  icon: Icons.ondemand_video_rounded,
                  press: () {

                  },
                ),
              ],
            ),
          ),),
    );
  }
}
