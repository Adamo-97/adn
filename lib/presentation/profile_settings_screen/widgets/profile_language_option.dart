import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

/// Widget for displaying a language option with selection state
class ProfileLanguageOption extends StatelessWidget {
  final String language;
  final bool isSelected;
  final bool isArabic;
  final VoidCallback? onTap;

  const ProfileLanguageOption({
    super.key,
    required this.language,
    required this.isSelected,
    this.isArabic = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CustomImageView(
            imagePath: isSelected
                ? ImageConstant.imgSelected
                : ImageConstant.imgUnselected,
            height: 24.h,
            width: 24.h,
            fit: BoxFit.cover,
          ),
          SizedBox(width: isArabic ? 12.h : 8.h),
          Container(
            margin: isArabic ? EdgeInsets.only(right: 30.h) : EdgeInsets.zero,
            child: Text(
              language,
              style: isArabic
                  ? TextStyleHelper.instance.body15MediumNotoKufiArabic
                  : TextStyleHelper.instance.body15RegularPoppins
                      .copyWith(color: appColors.whiteA700),
            ),
          ),
        ],
      ),
    );
  }
}
