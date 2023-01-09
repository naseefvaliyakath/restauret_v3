import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_verision_3/screens/home_screen/home_screen.dart';
import 'package:rest_verision_3/screens/home_screen/pc_home_screen_a.dart';

class HomeScreenFrame extends StatefulWidget {
  const HomeScreenFrame({Key? key}) : super(key: key);

  @override
  State<HomeScreenFrame> createState() => _HomeScreenFrameState();
}

class _HomeScreenFrameState extends State<HomeScreenFrame> {
  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return horizontal ? const PcHomeScreen() : const HomeScreen();
  }
}
