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
        padding: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
          color: category.backgroundColor ?? Color(0xFF5C6248),
          border: Border.all(
            color: category.borderColor ?? Color(0xFF8F9B87),
            width: 3.h,
          ),
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                category.title ?? '',
                style: TextStyleHelper.instance.body15RegularPoppins
                    .copyWith(color: appTheme.white_A700, height: 1.33),
              ),
            ),
            CustomImageView(
              imagePath: category.iconPath ?? '',
              height: 30.h,
              width: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
