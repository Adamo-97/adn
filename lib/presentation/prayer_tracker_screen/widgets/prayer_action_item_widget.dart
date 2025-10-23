import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/prayer_tracker_model.dart';

class PrayerActionItemWidget extends StatelessWidget {
  final PrayerActionModel action;
  final VoidCallback? onTap;
  final bool isSelected;

  const PrayerActionItemWidget({
    Key? key,
    required this.action,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if this is Qibla button by checking the label
    final isQiblaButton = action.label.toLowerCase().contains('qibla');

    // For Qibla button, use different SVG based on selected state
    String iconPath = action.icon;

    if (isQiblaButton) {
      if (isSelected) {
        iconPath = ImageConstant.imgQiblaButtonSelected;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CustomImageView(
            imagePath: iconPath,
            height: 50.h,
            width: 50.h,
            // Don't apply color filter - SVG already has correct colors
          ),
          SizedBox(height: 6.h),
          Text(
            action.label,
            style: TextStyleHelper.instance.label10LightPoppins
                .copyWith(color: appTheme.colorCCFFFF),
          ),
        ],
      ),
    );
  }
}
