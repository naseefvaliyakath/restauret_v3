import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../widget/common_widget/snack_bar.dart';

Future<void> checkInternetConnection() async {
  try {
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == false) {
        AppSnackBar.errorSnackBar('No internet', 'Pleas check your internet connection');
      }
  } catch (e) {
    return;
  }
}