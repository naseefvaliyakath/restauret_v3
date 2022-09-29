import 'package:get/get.dart';
import '../screens/home_screen/binding/home_screen_binding.dart';
import '../screens/home_screen/home_screen.dart';

class RouteHelper {
  static const String initial = '/';

  static String getInitial() => initial;

  static List<GetPage> routes = [
    GetPage(
      name: initial,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
