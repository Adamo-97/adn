import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/salah_guide_menu_model.dart';

class PrayerListItemWidget extends StatelessWidget {
  final PrayerTypeModel prayerType;
  final VoidCallback? onTapPrayerType;

  const PrayerListItemWidget({
    Key? key,
    required this.prayerType,
    this.onTapPrayerType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapPrayerType,
      child: Container(
        padding: EdgeInsets.all(6.h),
        decoration: BoxDecoration(
          color: appTheme.gray_700,
          border: Border.all(
            color: appTheme.gray_500,
            width: 3.h,
          ),
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 4.h),
                child: Text(
                  prayerType.title ?? '',
                  style: TextStyleHelper.instance.body15RegularPoppins
                      .copyWith(color: appTheme.white_A700, height: 1.3),
                ),
              ),
            ),
            SizedBox(width: 6.h),
            CustomImageView(
              imagePath: prayerType.iconPath ?? '',
              height: 30.h,
              width: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
