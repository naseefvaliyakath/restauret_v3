import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/routes/route_helper.dart';
import 'package:rest_verision_3/screens/home_screen/binding/home_screen_binding.dart';
import 'package:rest_verision_3/screens/home_screen/home_screen.dart';
import 'package:rest_verision_3/screens/login_screen/binding/login_binding.dart';
import 'constants/app_colors/app_colors.dart';
import 'hive_database/hive_init.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await MyHiveInit.initMyHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return ScreenUtilInit(
      designSize: const Size(411, 843),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Restaurant POS',
          theme: ThemeData(
            primaryColor: AppColors.mainColor,
            primarySwatch: Colors.amber,
          ),
          initialRoute: RouteHelper.getInitial(),
          initialBinding: LoginBinding(),
          unknownRoute: GetPage(name: '/notFount', page: () => const HomeScreen()),
          defaultTransition: Transition.fade,
          getPages: RouteHelper.routes,
        );
      },
    );
  }
}


