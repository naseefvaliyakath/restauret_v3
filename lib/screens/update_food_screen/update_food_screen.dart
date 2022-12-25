import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_colors/app_colors.dart';
import '../../constants/strings/my_strings.dart';
import '../../routes/route_helper.dart';
import '../../widget/common_widget/buttons/round_border_button.dart';
import '../../widget/common_widget/catogory_card.dart';
import '../../widget/common_widget/chose_image.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/common_text/heading_rich_text.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/common_widget/my_toggle_switch.dart';
import '../../widget/common_widget/notification_icon.dart';
import '../../widget/common_widget/shimming_effect.dart';
import '../../widget/common_widget/show_picked_img_card.dart';
import '../../widget/common_widget/text_field_widget.dart';
import '../../widget/common_widget/two_button-bottom_sheet.dart';
import '../../widget/update_food_screen/network_img_show_card.dart';
import 'controller/update_food_controller.dart';

class UpdateFoodScreen extends StatefulWidget {
  const UpdateFoodScreen({Key? key}) : super(key: key);

  @override
  State<UpdateFoodScreen> createState() => _UpdateFoodScreenState();
}

class _UpdateFoodScreenState extends State<UpdateFoodScreen> {
  File? imageFile;
  int tappedIndex = 0;
  CrossFadeState state = CrossFadeState.showFirst;
  CrossFadeState statePic = CrossFadeState.showFirst;



  @override
  Widget build(BuildContext context) {
    //? setting price toggle initially
    state = Get.find<UpdateFoodController>().priceToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;

    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(RouteHelper.getAllFoodScreen());
        return true;
      },
      child: Scaffold(
        body: GetBuilder<UpdateFoodController>(builder: (ctrl) {
          return ctrl.isLoading
              ? const MyLoading()
              : RefreshIndicator(
                onRefresh: () async {
                 await ctrl.refreshCategory();
                },
                child: GestureDetector(
                  onTap: (){
                    //? close keyboard on outside click in ios
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: SafeArea(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //? heading and notification icon back arrow
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //? back arrow
                                    Flexible(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.arrow_back,
                                              size: 24.sp,
                                            ),
                                            onPressed: () {
                                              Get.offNamed(RouteHelper.getAllFoodScreen());
                                            },
                                            splashRadius: 24.sp,
                                          ),
                                          15.horizontalSpace,
                                          const HeadingRichText(name: 'Update Your Food'),
                                        ],
                                      ),
                                    ),

                                    //? notification icon
                                    NotificationIcon(onTap: () {}),
                                  ],
                                ),
                                15.verticalSpace,
                                //? select category heading
                                BigText(
                                  text: 'Select Category :',
                                  size: 17.sp,
                                ),
                                10.verticalSpace,
                                //? category scrolling
                                SizedBox(
                                  height: 60.h,
                                  child: ctrl.isLoadingCategory
                                      ? const  ShimmingEffect()
                                      : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: ctrl.myCategory.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return CategoryCard(
                                        onTap: () {
                                          //? to change the color of tapped category
                                          ctrl.setCategoryTappedIndex(index);
                                          //? saving tapped category to fdCategory variable
                                          ctrl.initialFdCategory = ctrl.myCategory[index].catName ?? COMMON_CATEGORY;
                                        },
                                        color: ctrl.tappedIndex == index ? AppColors.mainColor_2 : Colors.white,
                                        text: ctrl.myCategory[index].catName ?? COMMON_CATEGORY, onLongTap: (){},
                                      );
                                    },
                                  ),
                                ),
                                20.verticalSpace,
                                //?  upload image card
                                AnimatedCrossFade(
                                  firstChild: NetworkImgShowCard(
                                    img: ctrl.initialFdImg,
                                  ),
                                  secondChild: Container(
                                    child: imageFile != null
                                        ? ShowPickedImgCard(
                                            file: imageFile,
                                            cancelEvent: () {
                                              setState(() {
                                                imageFile = null;
                                              });
                                            },
                                            choseFileEvent: () {
                                              TwoBtnBottomSheet.bottomSheet(
                                                b1Name: 'From Gallery',
                                                b2Name: 'From Camara',
                                                b1Function: _getFromGallery,
                                                b2Function: _getFromCamara,
                                              );
                                            },
                                          )
                                        : InkWell(
                                            onTap: () {
                                              TwoBtnBottomSheet.bottomSheet(b1Name: 'From Gallery', b2Name: 'From Camara', b1Function: _getFromGallery, b2Function: _getFromCamara);
                                            },
                                            child: const ChooseImage()),
                                  ),
                                  duration: const Duration(seconds: 1),
                                  crossFadeState: statePic,
                                  firstCurve: Curves.fastLinearToSlowEaseIn,
                                  secondCurve: Curves.linear,
                                ),

                                //? edit img toggle
                                5.verticalSpace,

                                MyToggleSwitch(
                                  value: ctrl.imageToggle,
                                  forImg: true,
                                  onToggle: (val) {
                                    ctrl.setImageToggle(val);
                                    statePic = ctrl.imageToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;
                                  },
                                ),

                                20.verticalSpace,

                                //?food  name text-field
                                BigText(
                                  text: 'Food Name ',
                                  size: 14.sp,
                                ),
                                5.verticalSpace,
                                TextFieldWidget(
                                  hintText: 'Enter Your Food Name ....',
                                  textEditingController: ctrl.fdNameTD,
                                  borderRadius: 15.r,
                                  txtLength: 35,
                                  onChange: (_) {},
                                ),

                                20.verticalSpace,
                                //? price text-field
                                Row(
                                  children: [
                                    BigText(
                                      text: 'Food Price ',
                                      size: 14.sp,
                                    ),
                                    MyToggleSwitch(
                                      onToggle: (val) {
                                        ctrl.setPriceToggle(val);
                                        state = ctrl.priceToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;
                                      },
                                      value: ctrl.priceToggle,
                                    ),
                                  ],
                                ),
                                5.verticalSpace,
                                AnimatedCrossFade(
                                  firstChild: TextFieldWidget(
                                    keyBordType: TextInputType.number,
                                    hintText: 'Enter Your Food Price ....',
                                    textEditingController: ctrl.fdPriceTD,
                                    borderRadius: 15.r,
                                    onChange: (_) {},
                                  ),
                                  secondChild: Row(
                                    children: [
                                      Expanded(
                                        child: TextFieldWidget(
                                          keyBordType: TextInputType.number,
                                          hintText: 'Full',
                                          textEditingController: ctrl.fdFullPriceTD,
                                          borderRadius: 15.r,
                                          onChange: (_) {},
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFieldWidget(
                                          keyBordType: TextInputType.number,
                                          hintText: '3/4',
                                          textEditingController: ctrl.fdThreeBiTwoPrsTD,
                                          borderRadius: 15.r,
                                          onChange: (_) {},
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFieldWidget(
                                          keyBordType: TextInputType.number,
                                          hintText: 'Half',
                                          textEditingController: ctrl.fdHalfPriceTD,
                                          borderRadius: 15.r,
                                          onChange: (_) {},
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFieldWidget(
                                          keyBordType: TextInputType.number,
                                          hintText: 'Quarter',
                                          textEditingController: ctrl.fdQtrPriceTD,
                                          borderRadius: 15.r,
                                          onChange: (_) {},
                                        ),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 1),
                                  crossFadeState: state,
                                  firstCurve: Curves.fastLinearToSlowEaseIn,
                                  secondCurve: Curves.linear,
                                ),
                                20.verticalSpace,
                                //add food button
                                Center(
                                    child: RoundBorderButton(
                                  text: 'Update Food',
                                  textColor: Colors.white,
                                  width: 0.9.sw,
                                  borderRadius: 20.r,
                                  onTap: () async {
                                    ctrl.file = imageFile;
                                    await ctrl.validateFoodDetails();
                                    Get.offNamed(RouteHelper.getAllFoodScreen());
                                  },
                                ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                ),
              );
        }), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  void _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1080);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromCamara() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1080, maxHeight: 1080,imageQuality: 30);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  _cropImage(filepath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filepath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper', toolbarColor: Colors.white, toolbarWidgetColor: Colors.black54, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path);
      });
    }
  }
}
