import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../constants/app_colors/app_colors.dart';
import '../common_widget/common_text/big_text.dart';

class MenuFoodCard extends StatelessWidget {
  final String img;
  final String name;
  final double price;
  final double priceThreeByTwo;
  final double priceHalf;
  final double priceQuarter;
  final String fdIsLoos;
  final String available;
  final String special;
  final bool showPrice;
  final bool showSpecial;

  const MenuFoodCard({
    Key? key,
    required this.img,
    required this.name,
    required this.price,
    this.available = 'no',
    required this.priceThreeByTwo,
    required this.priceHalf,
    required this.priceQuarter,
    required this.fdIsLoos,
    required this.special,
    this.showPrice = true,
    this.showSpecial = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r), boxShadow: [
        BoxShadow(
          offset: const Offset(4, 6),
          blurRadius: 4,
          color: Colors.black.withOpacity(0.3),
        )
      ]),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: CachedNetworkImage(
                imageUrl: img,
                placeholder: (context, url) => Lottie.asset(
                  'assets/lottie/img_holder.json',
                  width: 30.sp,
                  height: 30.sp,
                  fit: BoxFit.fill,
                ),
                errorWidget: (context, url, error) => Lottie.asset(
                  'assets/lottie/error.json',
                  width: 10.sp,
                  height: 10.sp,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          Positioned(
            top: 40.h,
            child: Padding(
              padding:  EdgeInsets.only(top: 10.h,left: 5.h),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: horizontal ? 17.sp : 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Visibility(
                    visible: showPrice,
                    child: Text(fdIsLoos == 'yes' ? 'Full      : $price' : 'Rs : $price',
                        softWrap: false,
                        style: TextStyle(
                          fontSize: horizontal ? 16.sp : 17.sp,
                          color: AppColors.mainColor_2,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Visibility(
                    visible: (fdIsLoos == 'yes' && showPrice) ? true : false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('3 by 4       : $priceThreeByTwo',
                            softWrap: false,
                            style: TextStyle(
                              fontSize: horizontal ? 12.sp : 13.sp,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('Half           : $priceHalf',
                            softWrap: false,
                            style: TextStyle(
                              fontSize: horizontal ?  12.sp :  13.sp,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('Quarter    : $priceQuarter',
                            softWrap: false,
                            style: TextStyle(
                              fontSize: horizontal ?  12.sp : 13.sp,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(top: 8.h, right: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: available == 'no' ? false : true,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 4.sp),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: BigText(
                            text: 'Available',
                            color: Colors.white,
                            size: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Visibility(
                    visible: (special == 'yes' && showSpecial) ? true : false,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 4.sp),
                          decoration: BoxDecoration(
                            color: Colors.pink.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: BigText(
                            text: 'Special',
                            color: Colors.white,
                            size: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
