import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/text_field_widget.dart';

class PurchaseBookScreen extends StatelessWidget {
  const PurchaseBookScreen({Key? key}) : super(key: key);

  static String routeName = '/PurchaseBookScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Purchase Book',
            style: TextStyle(color: Colors.white),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 8, spreadRadius: 4, offset: Offset(0, 10)),
            ],
          ),
          height: 56,
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showAnimatedDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape:  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          insetPadding: const EdgeInsets.all(0),
                          titlePadding: EdgeInsets.only(top: 10,bottom: 1),
                          contentPadding: EdgeInsets.all(10),
                          actionsPadding: EdgeInsets.only(bottom: 15),
                          actionsAlignment: MainAxisAlignment.center,
                          title: const Center(child: BigText(text: 'Add credit')),
                          actions: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.add, color: Colors.white),
                              label: Text(
                                'Add credit',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                          content: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 250
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFieldWidget(
                                  hintText: 'Amount',
                                  textEditingController: TextEditingController(),
                                  borderRadius: 15,
                                  onChange: (_) {},
                                ),
                                SizedBox(height: 10),
                                TextFieldWidget(
                                  hintText: 'Description',
                                  maxLIne: 3,
                                  textEditingController: TextEditingController(),
                                  borderRadius: 15,
                                  onChange: (_) {},
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      animationType: DialogTransitionType.scale,
                      // curve: Curves.fastOutSlowIn,
                      // duration: const Duration(milliseconds: 600),
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    'Credit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.remove, color: Colors.white),
                  label: Text(
                    'Debit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
            ],
          ),
        ),
        body: Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  leading: index < 5 ? const Icon(Icons.remove, color: Colors.red) : const Icon(Icons.add, color: Colors.green),
                  title: Text("Payemnt for vegatables from XXXX"),
                  subtitle: Text('Date: 12-12-2022'),
                  trailing: Text(index < 5 ? "-150" : "+250", style:  TextStyle(fontWeight: FontWeight.bold,color: (index < 5) ?Colors.red:Colors.green)),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: 25),
        ));
  }
}
