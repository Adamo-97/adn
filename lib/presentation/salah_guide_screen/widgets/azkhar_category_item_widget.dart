import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/azkhar_category_model.dart';

class AzkharCategoryItemWidget extends StatelessWidget {
  final AzkharCategoryModel category;
  final VoidCallback? onTapCategory;

  AzkharCategoryItemWidget({
    Key? key,
    required this.category,
    this.onTapCategory,
  }) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return GestureDetector(
       onTap: onTapCategory,
       child: Container(
         // tighter padding so the tile is shorter
         padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 6.h),
         constraints: BoxConstraints(minHeight: 44.h), // compact but tappable
         decoration: BoxDecoration(
           color: category.backgroundColor ?? Color(0xFF5C6248),
           border: Border.all(
             color: category.borderColor ?? Color(0xFF8F9B87),
             width: 2.h, // slimmer border reduces overall height feel
           ),
           borderRadius: BorderRadius.circular(12.h),
         ),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
              Expanded( // clamps text so it doesn't force extra height
                child: Text(
                  category.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.instance.body15RegularPoppins
                      .copyWith(color: appTheme.white_A700, height: 1.10),
                ),
              ),
             SizedBox(width: 6.h),
             CustomImageView(
               imagePath: category.iconPath ?? '',
               height: 18.h, // smaller icon
               width: 18.h,
             ),
           ],
         ),
       ),
     );
   }
 }
