import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/menu_book_screen/controller/menu_book_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rest_verision_3/widget/common_widget/buttons/app_min_button.dart';
import 'package:share_plus/share_plus.dart';

class ShowQrAlertBody extends StatelessWidget {
  const ShowQrAlertBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuBookController>(builder: (ctrl) {
      return SizedBox(
        width: 1.sw * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImage(
              data: ctrl.menuBookUrl,
              version: QrVersions.auto,
              size: 200.0,
            ),
            Row(
              children: [
                10.horizontalSpace,
                Flexible(
                    child: AppMiniButton(
                        text: 'Share',
                        color: Colors.green,
                        onTap: () async {
                          await Share.share('scan this qr code to view menus');
                          Navigator.pop(context);
                        })),
                10.horizontalSpace,
                Flexible(
                    child: AppMiniButton(
                        text: 'Close',
                        color: Colors.red,
                        onTap: () async {
                          Navigator.pop(context);
                        })),
                10.horizontalSpace,
              ],
            )
          ],
        ),
      );
    });
  }
}
