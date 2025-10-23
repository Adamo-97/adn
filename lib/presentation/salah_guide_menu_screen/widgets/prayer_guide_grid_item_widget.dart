import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/salah_guide_menu_model.dart';

class PrayerGuideGridItemWidget extends StatelessWidget {
  final PrayerGuideItemModel prayerGuideItem;
  final VoidCallback? onTapGuideItem;

  const PrayerGuideGridItemWidget({
    super.key,
    required this.prayerGuideItem,
    this.onTapGuideItem,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('[SalahGrid] Building tile: ${prayerGuideItem.title}');

    return GestureDetector(
      onTap: onTapGuideItem,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: appTheme.gray_500,
          border: Border.all(
            color: appTheme.gray_700,
            width: 3.h,
          ),
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              imagePath: prayerGuideItem.iconPath,
              height: 20.h,
              width: 20.h,
            ),
            SizedBox(height: 8.h),
            Text(
              prayerGuideItem.title,
              style: TextStyleHelper.instance.body15RegularPoppins
                  .copyWith(color: appTheme.orange_200),
            ),
            SizedBox(height: 4.h),
            Text(
              prayerGuideItem.subtitle,
              style: TextStyleHelper.instance.body15RegularPoppins
                  .copyWith(color: appTheme.white_A700),
            ),
          ],
        ),
      ),
    );
  }
}
