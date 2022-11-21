import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../constants/app_colors/app_colors.dart';
import 'common_text/big_text.dart';


class FoodCard extends StatelessWidget {
  final String img;
  final String name;
  final double price;
  final double priceThreeByTwo;
  final double priceHalf;
  final double priceQuarter;
  final String fdIsLoos;
  final String today;
  final String quick;


  const FoodCard(
      {Key? key, required this.img, required this.name, required this.price,  this.today = 'no', required this.priceThreeByTwo, required this.priceHalf, required this.priceQuarter, required this.fdIsLoos, required this.quick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20.r), boxShadow: [
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
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: CachedNetworkImage(
                imageUrl: img,
                placeholder: (context, url) => Lottie.asset(
                  'assets/lottie/img_holder.json',
                  width: 50.sp,
                  height: 50.sp,
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
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          Positioned(
              left: 1.sw / 34.25,

              /// 12.0
              bottom: 1.sh / 45.54,

              /// 15.0
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 1.sh / 55.15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                  Text(fdIsLoos == 'yes' ? 'Full      : $price' : 'Rs : $price',
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 1.sh / 49,
                        color: AppColors.mainColor_2,
                        fontWeight: FontWeight.bold,
                      )),
                  Visibility(
                    visible: fdIsLoos == 'yes' ? true : false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('3 by 4       : $priceThreeByTwo',
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 1.sh / 69,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('Half           : $priceHalf',
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 1.sh / 69,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('Quarter    : $priceQuarter',
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 1.sh / 69,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ],
              )),
          Positioned(
              top: 1.sh / 68.3,
              right: 1.sw / 41.1,
              child: Column(
                children: [
                  Visibility(
                    visible: today == 'no'? false : true,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 2.sp),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: BigText(
                            text: 'Today',
                            color: Colors.white,
                            size: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  15.verticalSpace,
                  Visibility(
                    visible: quick == 'no'? false : true,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 2.sp),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: BigText(
                        text: 'Quick',
                        color: Colors.white,
                        size: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
          )
        ],
      ),
    );
  }
}
