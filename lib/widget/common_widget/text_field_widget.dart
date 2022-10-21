import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors/app_colors.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final int maxLIne;
  final double borderRadius;
  final double? width;
  final double? hintSize;
  final bool readonly;
  final Function onChange;
  final bool? isDens;
  final bool autoFocus;
  final TextInputType keyBordType;
  final bool isNumberOnly;

  const TextFieldWidget(
      {Key? key,
      required this.textEditingController,
      required this.hintText,
      this.maxLIne = 1,
      this.readonly = false,
      required this.borderRadius,
      this.isDens = false,
      this.width,
      this.hintSize,
      this.autoFocus = false,
      this.keyBordType = TextInputType.text,
      required this.onChange,
      this.isNumberOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.maxFinite,
      child: TextField(
        keyboardType: keyBordType,
        controller: textEditingController,
        maxLines: maxLIne,
        readOnly: readonly,
        autofocus: autoFocus,
        onChanged: (value) {
          onChange(value);
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.textGrey,
            fontSize: hintSize ?? 18.w,
          ),
          filled: true,
          isDense: isDens,
          fillColor: AppColors.textHolder,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: Colors.white, width: 1.sp)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: Colors.white, width: 1.sp)),
        ),
        //? if isNumberOnly true then only allow numbers and decimals
        inputFormatters: !isNumberOnly
            ? []
            : [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,5}')),
              ],
      ),
    );
  }
}
