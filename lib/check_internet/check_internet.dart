import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../error_handler/error_handler.dart';
import '../widget/common_widget/snack_bar.dart';

Future<void> checkInternetConnection() async {
  final ErrorHandler errHandler = Get.find<ErrorHandler>();
  try {
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == false) {
        AppSnackBar.errorSnackBar('No internet', 'Pleas check your internet connection');
      }
  } catch (e) {
    errHandler.myResponseHandler(error: e.toString(),pageName: 'check_internet',methodName: 'checkInternetConnection()');
    return;
  }
}