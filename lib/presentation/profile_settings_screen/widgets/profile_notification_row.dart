import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

/// Widget for displaying a notification toggle row
class ProfileNotificationRow extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final VoidCallback? onTap;

  const ProfileNotificationRow({
    super.key,
    required this.title,
    required this.isEnabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyleHelper.instance.body15RegularPoppins
                  .copyWith(color: appColors.gray_100),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 24.h),
            child: CustomImageView(
              imagePath: isEnabled
                  ? ImageConstant.imgStatusChecked
                  : ImageConstant.imgStatusUnchecked,
              height: 22.h,
              width: 36.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
