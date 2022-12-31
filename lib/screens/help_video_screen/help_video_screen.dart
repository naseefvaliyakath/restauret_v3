import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/routes/route_helper.dart';
import 'package:rest_verision_3/screens/help_video_screen/controller/help_video_controller.dart';
import 'package:rest_verision_3/screens/help_video_screen/video_play_screen.dart';
import 'package:rest_verision_3/widget/common_widget/common_text/small_text.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../models/tutorial_model/tutorial.dart';
import '../../widget/common_widget/common_text/heading_rich_text.dart';
import '../../widget/settings_page_screen/profile_menu.dart';

class HelpVideoScreen extends StatelessWidget {
  const HelpVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> videoWidgets(List<Tutorial> item)
    {
      List<Widget> list = <Widget>[];
      for(var i = 0; i < item.length; i++){
        list.add(ProfileMenu(
          text: item[i].title ?? 'Error',
          icon: Icons.ondemand_video_rounded,
          press: () {
            Get.toNamed(RouteHelper.getVideoPlayScreen(),
                arguments: {'link': item[i].link, 'name': item[i].title ?? 'error'});
          },
        ));
      }
      return list;
    }
    return GetBuilder<HelpVideoController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: RichText(
            softWrap: false,
            text: TextSpan(children: [
              TextSpan(
                  text: 'Tutorials video',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.sp, color: AppColors.textColor)),
            ]),
            maxLines: 1,
          ),
          actions: [
            Container(
                margin: EdgeInsets.only(right: 10.w),
                child: Column(
                  children: [
                    IconButton(
                        onPressed: () {
                            ctrl.urlLaunchUrl();
                        },
                        icon: Icon(
                          FontAwesomeIcons.youtube,
                          color: Colors.red,
                          size: 24.sp,
                        )),
                  ],
                )),
            10.horizontalSpace
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              children: [
                20.verticalSpace,
                ...videoWidgets(ctrl.allTutorial),

              ],
            ),
          ),),
      );
    });
  }
}
