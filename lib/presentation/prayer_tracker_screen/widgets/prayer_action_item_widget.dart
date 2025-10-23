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
    // Determine button type
    final id = action.id.toLowerCase();
    final label = action.label.toLowerCase();

    final isQiblaButton = id.contains('qibla') || label.contains('qibla');
    final isWeeklyStat = id.contains('weekly');
    final isMonthlyStat = id.contains('monthly');
    final isQuadStat = id.contains('quad');

    // Determine icon based on button type and selected state
    String iconPath = action.icon;

    if (isQiblaButton && isSelected) {
      iconPath = ImageConstant.imgQiblaButtonSelected;
    } else if (isWeeklyStat && isSelected) {
      iconPath = ImageConstant.imgWeeklyStatSelected;
    } else if (isMonthlyStat && isSelected) {
      iconPath = ImageConstant.imgMonthlyStatSelected;
    } else if (isQuadStat && isSelected) {
      iconPath = ImageConstant.imgQuadStatSelected;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CustomImageView(
            imagePath: iconPath,
            height: 50.h,
            width: 50.h,
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
