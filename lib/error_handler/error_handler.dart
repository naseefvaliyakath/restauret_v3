import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rest_verision_3/repository/flutter_log_repository.dart';

class ErrorHandler extends GetxService {
  FlutterLogRepo flutterLogRepo = Get.find<FlutterLogRepo>();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();


   myResponseHandler({
    required String error,
    bool sendToServer = false,
    String pageName = 'no_data',
    String methodName = 'no_data',
  }) async {
    try {

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String platform = Platform.operatingSystem;
        String osVersionNumber = 'no_data';
        String deviceModel = 'no_data';
        String appVersion = packageInfo.version;
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          osVersionNumber = androidInfo.version.sdkInt.toString();
          deviceModel = '${androidInfo.brand} - ${androidInfo.model}';
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          osVersionNumber = iosInfo.systemVersion ?? 'no_data';
          deviceModel = iosInfo.model ?? 'no_data';
        } else if (Platform.isWindows) {
          WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
          osVersionNumber = windowsInfo.majorVersion.toString();
          deviceModel = 'windows';
        }

        flutterLogRepo.insertLog(
          error: error,
          pageName: pageName,
          methodName: methodName,
          platform: platform,
          osVersionNumber: osVersionNumber,
          deviceModel: deviceModel,
          appVersion: appVersion,
        );


    } catch (e) {
      return;
    }
  }
}
