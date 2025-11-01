import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../notifier/profile_settings_notifier.dart';

/// Modern dark mode toggle setting
class DarkMode extends ConsumerWidget {
  const DarkMode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSettingsNotifier);
    final notifier = ref.read(profileSettingsNotifier.notifier);

    return GestureDetector(
      onTap: notifier.toggleDarkMode,
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
                imagePath: ImageConstant.imgVectorWhiteA700,
                height: 20.h,
                width: 20.h,
              ),
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dark Mode',
                    style: TextStyleHelper.instance.title18SemiBoldPoppins
                        .copyWith(fontSize: 16.fSize),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Switch between light and dark theme',
                    style: TextStyleHelper.instance.label10LightPoppins
                        .copyWith(
                            fontSize: 11.fSize, color: appColors.gray_100),
                  ),
                ],
              ),
            ),
            CustomImageView(
              imagePath: (state.darkMode ?? false)
                  ? ImageConstant.imgStatusChecked
                  : ImageConstant.imgStatusUnchecked,
              height: 44.h,
              width: 36.h,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
