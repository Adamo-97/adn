import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';

/// Widget for displaying an action row (e.g., Rate App, About App)
class ProfileActionRow extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileActionRow({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CustomIconButton(
            height: 24.h,
            width: 24.h,
            padding: EdgeInsets.all(4.h),
            iconPath: icon,
            backgroundColor: appTheme.white_A700,
            borderRadius: 12.h,
            variant: CustomIconButtonVariant.small,
          ),
          SizedBox(width: 10.h),
          Text(
            title,
            style: TextStyleHelper.instance.body15RegularPoppins
                .copyWith(color: appTheme.white_A700),
          ),
        ],
      ),
    );
  }
}
