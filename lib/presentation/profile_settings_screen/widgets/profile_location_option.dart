import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

/// Widget for displaying a location option in the dropdown
class ProfileLocationOption extends StatelessWidget {
  final String location;
  final bool isSelected;
  final VoidCallback? onTap;

  const ProfileLocationOption({
    super.key,
    required this.location,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.h),
          decoration: isSelected
              ? BoxDecoration(
                  color: appTheme.gray_900,
                  borderRadius: BorderRadius.circular(4.h),
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                location,
                style: TextStyleHelper.instance.body12RegularPoppins,
              ),
              if (isSelected)
                CustomImageView(
                  imagePath: ImageConstant.imgCheckMark,
                  height: 24.h,
                  width: 24.h,
                  fit: BoxFit.cover,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
