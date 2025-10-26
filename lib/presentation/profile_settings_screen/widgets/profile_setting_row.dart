import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

/// Reusable widget for displaying a setting row with icon, title, subtitle, and trailing widget
/// This widget includes all its own styling and spacing
class ProfileSettingRow extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isToggleable;
  final bool? toggleValue;
  final bool showChevron;
  final VoidCallback? onTap;

  const ProfileSettingRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isToggleable = false,
    this.toggleValue,
    this.showChevron = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(top: 4.h),
            child: CustomImageView(
              imagePath: icon,
              height: 24.h,
              width: 24.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyleHelper.instance.title18SemiBoldPoppins,
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyleHelper.instance.label10LightPoppins,
                ),
              ],
            ),
          ),
          if (isToggleable && toggleValue != null)
            CustomImageView(
              imagePath: toggleValue!
                  ? ImageConstant.imgStatusChecked
                  : ImageConstant.imgStatusUnchecked,
              height: 44.h,
              width: 36.h,
              fit: BoxFit.cover,
            ),
          if (showChevron)
            CustomImageView(
              imagePath: ImageConstant.imgDropDownClick,
              height: 50.h,
              width: 36.h,
              fit: BoxFit.cover,
            ),
        ],
      ),
    );
  }
}
