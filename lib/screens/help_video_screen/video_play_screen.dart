import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/help_video_screen/controller/help_video_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../constants/app_colors/app_colors.dart';
import '../../routes/route_helper.dart';

class VideoPlayScreen extends StatelessWidget {
  const VideoPlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HelpVideoController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: RichText(
            softWrap: false,
            text: TextSpan(children: [
              TextSpan(
                  text: ctrl.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.sp, color: AppColors.textColor)),
            ]),
            maxLines: 1,
          ),
          actions: [
            Container(
                margin: EdgeInsets.only(right: 10.w),
                child: IconButton(
                    onPressed: () {
                      Get.toNamed(RouteHelper.getNotificationScreen());
                    },
                    icon: Icon(
                      FontAwesomeIcons.bell,
                      size: 24.sp,
                    ))),
            10.horizontalSpace
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              YoutubePlayer(
                controller: ctrl.controller,
                liveUIColor: Colors.amber,
                bottomActions: [
                  CurrentPosition(),
                  Visibility(
                      visible: false,
                      child: FullScreenButton(
                        color: Colors.white,
                      )),
                  ProgressBar(isExpanded: true),
                ],
              ),
              20.verticalSpace,
              GestureDetector(
                onTap: (){
                  ctrl.urlLaunchSingleVideo(ctrl.videoLink);
                },
                child: Container(
                  height: 50.sp,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/image/youtube.png'),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
