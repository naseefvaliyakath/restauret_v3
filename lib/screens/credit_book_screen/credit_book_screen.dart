import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';

import '../../alerts/change_password_prompt_alert/change_password_prompt_to_cashier_body.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/text_field_widget.dart';
import 'controller/credit_book_ctrl.dart';
import 'credit_book_user_screen.dart';

class CreditBookScreen extends StatelessWidget {
  CreditBookScreen({Key? key}) : super(key: key);

  static String routeName = '/CreditBookScreen';

  final CreditBookCTRL c = CreditBookCTRL();

  //user name,colour,

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Obx(() => c.showSearchBar.value
              ? TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 10),
                    hintText: " Search",
                    hintStyle: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 18,
                    ),
                    filled: true,
                    isDense: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white, width: 1)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white, width: 1)),
                  ),
                )
              : const Text(
                  'Credit Debit Book',
                  style: TextStyle(color: Colors.white),
                )),
          actions: [
            IconButton(onPressed: () => c.showSearchBar.value = !c.showSearchBar.value, icon: Icon(Icons.search, color: Colors.white)),
            SizedBox(
              width: 10,
            )
          ],
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          insetPadding: const EdgeInsets.all(0),
                          titlePadding: EdgeInsets.only(top: 10, bottom: 1),
                          contentPadding: EdgeInsets.all(10),
                          actionsPadding: EdgeInsets.only(bottom: 15),
                          actionsAlignment: MainAxisAlignment.center,
                          title: const Center(child: BigText(text: 'Add New User')),
                          actions: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.add, color: Colors.white),
                              label: Text(
                                'Add User',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                          content: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 250),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFieldWidget(
                                  hintText: 'Name',
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
                    'Add New User',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Get.toNamed(CreditBookUserScreen.routeName);
                      },
                      dense: true,
                      leading: CircleAvatar(
                        child: Text('Wx$index'.length > 2 ? 'W$index'.substring(0, 2) : 'W$index'),
                      ),
                      title: Text("Adam John $index"),
                      // subtitle: Text('Date: 12-12-2022'),
                      trailing:
                          Text(index < 5 ? "-150" : "+250", style: TextStyle(fontWeight: FontWeight.bold, color: (index < 5) ? Colors.red : Colors.green)),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: 25),
            ),
          ],
        ));
  }
}
