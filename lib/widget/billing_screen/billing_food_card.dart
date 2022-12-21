import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../constants/app_colors/app_colors.dart';


class BillingFoodCard extends StatelessWidget {
  final String img;
  final String name;
  final double price;
  final double priceThreeByTwo;
  final double priceHalf;
  final double priceQuarter;
  final String fdIsLoos;
  final Function onTap;
  final Function onLongTap;
  final Function onSwipeDown;

  const BillingFoodCard({Key? key, required this.img, required this.name, required this.price, required this.onTap, required this.onLongTap, required this.onSwipeDown, required this.priceThreeByTwo, required this.priceHalf, required this.priceQuarter, required this.fdIsLoos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (detals){
        int sensitivity = 8;
        if(detals.primaryVelocity! > 0){
          onSwipeDown();
          return;
        }
      },
      onLongPress: ()=>onLongTap(),
      onTap: ()=>onTap(),
      child: Container(
        margin: EdgeInsets.only(right: 6.sp),
        width: 0.23.sw,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), boxShadow: [
          BoxShadow(
            offset: const Offset(1, 2),
            blurRadius: 2.r,
            color: Colors.black.withOpacity(0.3),
          )
        ]),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
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
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            Positioned(
                left: 3.sp,

                /// 12.0
                bottom: 4.sp,

                /// 15.0
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.black54,
                  ),


                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                          name == '' ? 'error' : name,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      Text('Rs: $price',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 1.sh / 69,
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.bold,
                          )),
                      Visibility(
                        visible: fdIsLoos == 'yes' ? true : false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('3 by 4    : $priceThreeByTwo',
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 1.sh / 99,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text('Half        : $priceHalf',
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 1.sh / 99,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text('Quarter : $priceQuarter',
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 1.sh / 99,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
