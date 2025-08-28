import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/prayer_tracker_model.dart';

class PrayerActionItemWidget extends StatelessWidget {
  final PrayerActionModel action;
  final VoidCallback? onTap;

  const PrayerActionItemWidget({
    Key? key,
    required this.action,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CustomImageView(
            imagePath: action.icon ?? '',
            height: 50.h,
            width: 50.h,
          ),
          SizedBox(height: 6.h),
          Text(
            action.label ?? '',
            style: TextStyleHelper.instance.label10LightPoppins
                .copyWith(color: appTheme.colorCCFFFF),
          ),
        ],
      ),
    );
  }
}
