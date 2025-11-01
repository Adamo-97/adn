import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

/// Modern share app action
class ShareApp extends StatelessWidget {
  const ShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Handle share app
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 40.h,
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                color: appColors.gray_700,
                borderRadius: BorderRadius.circular(10.h),
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgSearchGray900,
                height: 20.h,
                width: 20.h,
                color: appColors.whiteA700,
              ),
            ),
            SizedBox(width: 10.h),
            Text(
              'Share App',
              style: TextStyleHelper.instance.body15RegularPoppins
                  .copyWith(fontSize: 15.fSize, color: appColors.whiteA700),
            ),
          ],
        ),
      ),
    );
  }
}
