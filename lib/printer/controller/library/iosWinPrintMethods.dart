import 'package:esc_pos_utils/esc_pos_utils.dart';

class IosWinPrintMethods{

  static Future<Generator> getGenerator() async {
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    return Generator(PaperSize.mm58, profile);
  }

  static List<int> printRows({required List<List<String>> columns, required List<int> width, required Generator generator, bool bold = false}) {
    List<int> bytes = [];
    List<List<String>> newColumn = [];
    for (List<String> singleRow in columns) {

      void recFunc(str){
        if (str.length > 14){
          newColumn.add([str, ' ', ' ', ' ']);
          recFunc(str.substring(15));
        }else{
          newColumn.add([str, ' ', ' ', ' ']);
        }
      }

      newColumn.add(singleRow);
      if (singleRow[0].length > 14){
        recFunc(singleRow[0].substring(15));
      }
    }

    for (List<String> singleRow in newColumn) {
      bytes += generator.row(List.generate(singleRow.length, (index) {
        return PosColumn(
            text: singleRow[index],
            width: width[index],
            styles: PosStyles(
              bold: bold,
              align: index == 0
                  ? PosAlign.left
                  : (index == singleRow.length - 1)
                  ? PosAlign.right
                  : PosAlign.center,
            ));
      }));
    }
    return bytes;
  }

}