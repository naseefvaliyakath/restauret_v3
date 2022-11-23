import 'package:get/get.dart';

class CategoryData extends GetxController {

  //? billing list
  final List<dynamic> billingItems = [
    {
      'fdId': 10,
      'name': 'food 1',
      'qnt': 1,
      'price': 100,
      'ktNote': 'make spicy',
      'ordStatus': 'pending'
    },
    {
      'fdId': 11,
      'name': 'food 2',
      'qnt': 3,
      'price': 200,
      'ktNote': 'make spicy',
      'ordStatus': 'pending'
    },
    {
      'fdId': 10,
      'name': 'food 1',
      'qnt': 1,
      'price': 100,
      'ktNote': '',
      'ordStatus': 'pending'
    },

  ];

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  printKot({
    required List<dynamic> order,
    required String orderType,
    required String orderStatus
}){
    //? code for printing
  }


  printInVoice({
    required List<dynamic> order,
    required double grandTotel,
    required double balans
  }){
    //? code for printing
  }

}