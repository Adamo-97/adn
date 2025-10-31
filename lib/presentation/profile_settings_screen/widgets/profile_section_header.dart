import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

/// Widget for displaying a section header with icon, title, subtitle, and optional chevron
class ProfileSectionHeader extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool showChevron;
  final VoidCallback? onTap;

  const ProfileSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
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
            child: Container(
              margin: EdgeInsets.only(bottom: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyleHelper.instance.title18SemiBoldPoppins
                        .copyWith(color: appColors.gray_100),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyleHelper.instance.label10LightPoppins
                        .copyWith(color: appColors.gray_100),
                  ),
                ],
              ),
            ),
          ),
          if (showChevron)
            Container(
              margin: EdgeInsets.only(right: 24.h, left: 10.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgDropDownClick,
                height: 50.h,
                width: 36.h,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
