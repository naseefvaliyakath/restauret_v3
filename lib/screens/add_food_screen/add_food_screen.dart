import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../alerts/common_alerts.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/strings/my_strings.dart';
import '../../routes/route_helper.dart';
import '../../widget/common_widget/add_category_card.dart';
import '../../widget/common_widget/add_catogory_card_text_field.dart';
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
import 'controller/add_food_controller.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({Key? key}) : super(key: key);

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  File? imageFile;
  var fdCategory = COMMON_CATEGORY;
  CrossFadeState state = CrossFadeState.showFirst;
  CrossFadeState stateCategory = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AddFoodController>(builder: (ctrl) {
        //? if no category clicked then make default first category
        fdCategory = ctrl.myCategory.isNotEmpty ? ctrl.myCategory.first.catName ?? COMMON_CATEGORY : COMMON_CATEGORY;
        state = ctrl.priceToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;
        return ctrl.isLoading == true
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
                      children: [
                        Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //? heading , notification icon and back btn
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //? back arrow and heading text
                                    Flexible(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          BackButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                          ),
                                          15.horizontalSpace,
                                          const HeadingRichText(name: 'Add Your Food'),
                                        ],
                                      ),
                                    ),
                                    //? notification icon
                                    NotificationIcon(onTap: () {
                                      Get.toNamed(RouteHelper.getNotificationScreen());
                                    }),
                                  ],
                                ),
                              ),
                              15.verticalSpace,
                              //? select category text
                              BigText(
                                text: 'Select Category :',
                                size: 17.sp,
                              ),
                              10.verticalSpace,
                              //category scrolling
                              SizedBox(
                                height: 60.h,
                                child: ctrl.isLoadingCategory == true
                                    ? const ShimmingEffect()
                                    : ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: ctrl.myCategory.length + 1,
                                        itemBuilder: (BuildContext ctx, index) {
                                          //category's
                                          if (index < ctrl.myCategory.length) {
                                            return CategoryCard(
                                              onTap: () {
                                                String fdCategorySelected = ctrl.myCategory[index].catName ?? COMMON_CATEGORY;
                                                ctrl.setCategoryTappedIndex(index, fdCategorySelected);
                                              },
                                              color: ctrl.tappedIndex == index ? AppColors.mainColor_2 : Colors.white,
                                              text: ctrl.myCategory[index].catName ?? 'error'.toUpperCase(),
                                              onLongTap: () async {
                                                twoFunctionAlert(
                                                  title: 'Delete this item ?',
                                                  subTitle: 'Do you want to delete this food ?',
                                                  okBtn: 'Delete',
                                                  cancelBtn: 'Cancel',
                                                  context: context,
                                                  onCancelTap: () {},
                                                  onTap: () {
                                                    ctrl.deleteCategory(
                                                      catId: ctrl.myCategory[index].CatId ?? -1,
                                                      catName: ctrl.myCategory[index].catName ?? '',
                                                    );
                                                  },

                                                );
                                              },
                                            );
                                          }

                                          //? add new category card
                                          else {
                                            return AnimatedCrossFade(
                                              firstChild: AddCategoryCard(
                                                onTap: () {
                                                  ctrl.setAddCategoryToggle(true);
                                                  stateCategory = ctrl.addCategoryToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;
                                                },
                                              ),
                                              secondChild: ctrl.addCategoryLoading
                                                  ? const MyLoading()
                                                  : AddCategoryCardTextField(
                                                      onTapAdd: () async {
                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                        await ctrl.insertCategory();
                                                        stateCategory = ctrl.addCategoryToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;
                                                      },
                                                      onTapBack: () {
                                                        ctrl.setAddCategoryToggle(false);
                                                        stateCategory = ctrl.addCategoryToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;
                                                      },
                                                      nameController: ctrl.categoryNameTD,
                                                height: 60.h,
                                                    ),
                                              duration: const Duration(seconds: 1),
                                              crossFadeState: stateCategory,
                                              firstCurve: Curves.fastLinearToSlowEaseIn,
                                              secondCurve: Curves.linear,
                                            );
                                          }
                                        },
                                      ),
                              ),
                              20.verticalSpace,
                              //? upload image
                              imageFile != null
                                  //? to select image from gallery or camera
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
                                      child: const ChooseImage(),
                                    ),
                              20.verticalSpace,
                              //? food name text-field
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
                              // price text-field
                              Row(
                                children: [
                                  BigText(
                                    text: 'Food Price ',
                                    size: 14.sp,
                                  ),
                                  MyToggleSwitch(
                                    value: ctrl.priceToggle,
                                    onToggle: (val) {
                                      ctrl.setPriceToggle(val);
                                      ctrl.clearLoosPrice();
                                      state = ctrl.priceToggle == false ? CrossFadeState.showFirst : CrossFadeState.showSecond;
                                    },
                                  ),
                                ],
                              ),
                              5.verticalSpace,
                              AnimatedCrossFade(
                                firstChild: TextFieldWidget(
                                  isNumberOnly: true,
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
                                        isNumberOnly: true,
                                        keyBordType: TextInputType.number,
                                        hintText: 'Full',
                                        textEditingController: ctrl.fdFullPriceTD,
                                        borderRadius: 15.r,
                                        onChange: (_) {},
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFieldWidget(
                                        isNumberOnly: true,
                                        keyBordType: TextInputType.number,
                                        hintText: '3/4',
                                        textEditingController: ctrl.fdThreeBiTwoPrsTD,
                                        borderRadius: 15.r,
                                        onChange: (_) {},
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFieldWidget(
                                        isNumberOnly: true,
                                        keyBordType: TextInputType.number,
                                        hintText: 'Half',
                                        textEditingController: ctrl.fdHalfPriceTD,
                                        borderRadius: 15.r,
                                        onChange: (_) {},
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFieldWidget(
                                        isNumberOnly: true,
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
                                text: 'Add Food',
                                textColor: Colors.white,
                                width: 0.9.sw,
                                borderRadius: 20.r,
                                onTap: () async {
                                  ctrl.file = imageFile;
                                  await ctrl.validateFoodDetails();
                                  imageFile = null;
                                },
                              )),
                              20.verticalSpace,
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
      }), // This trailing comma makes auto-formatting nicer for build methods.
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
