import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

class FixedSalahHeader extends StatelessWidget {
  const FixedSalahHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onBack,
              child: CustomImageView(
                imagePath: ImageConstant.imgBackButton,
                height: 30.h,
                width: 30.h,
              ),
            ),
            SizedBox(width: 70.h),
            Text(
              title,
              style: TextStyleHelper.instance.title20BoldPoppins,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          height: 1.h,
          width: double.maxFinite,
          color: appTheme.orange_200,
        ),
      ],
    );
  }
}
