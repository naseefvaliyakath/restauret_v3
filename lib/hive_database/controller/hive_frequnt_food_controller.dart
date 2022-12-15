import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rest_verision_3/hive_database/hive_model/frequent_food/frequent_food.dart';

import '../box_repository.dart';
import '../hive_model/hold_item/hive_hold_item.dart';



class HiveFrequentFoodController extends GetxController {
  ///?FrequentFood
  final Box _frequentBox = BoxRepository.getFrequentFoodBox();
  Box get frequentBox => _frequentBox;




  //? FrequentFood create
  createFrequentFood({required FrequentFood frequentFood}) async {
   try {
     await  _frequentBox.add(frequentFood);
     update();
   } catch (e) {
     rethrow;
   }
  }

  updateFrequentFood({required int key, required FrequentFood frequentFood}) async {
    try {
      await _frequentBox.put(key, frequentFood);
      update();
    } catch (e) {
      rethrow;
    }
  }

  //? get all FrequentFood
  List<FrequentFood> getFrequentFood() {
    try {
      List<FrequentFood> frequentFoods = [];
     for (var i = 0; i < _frequentBox.values.length; i++) {
       frequentFoods.add(_frequentBox.getAt(i));
     }
      update();
      return frequentFoods;
    } catch (e) {
      rethrow;
    }
    finally{
      update();
    }
  }

  //? delete FrequentFood
  deleteFrequentFood({required int index}) async {
    try {
      await  _frequentBox.deleteAt(index);
      update();
    } catch (e) {
      rethrow;
    }
  }

  //? delete all FrequentFood
  clearFrequentFood({required int index}) async {
    try {
      await _frequentBox.clear();
      update();
    } catch (e) {
     rethrow;
    }
  }



}
