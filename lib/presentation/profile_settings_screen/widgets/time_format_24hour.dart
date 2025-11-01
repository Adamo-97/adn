import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../notifier/profile_settings_notifier.dart';

/// Toggle setting for 24-hour time format.
/// When enabled, all times in the app (next prayer card, prayer times list)
/// display in 24-hour format (e.g., "14:30"). When disabled, times display
/// in 12-hour format with AM/PM (e.g., "2:30 PM").
class TimeFormat24Hour extends ConsumerWidget {
  const TimeFormat24Hour({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSettingsNotifier);
    final notifier = ref.read(profileSettingsNotifier.notifier);

    return Padding(
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
              imagePath: ImageConstant.imgTimeFormatIcon,
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
                  '24-Hour Format',
                  style: TextStyleHelper.instance.title18SemiBoldPoppins
                      .copyWith(fontSize: 16.fSize),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Display times in 24-hour format',
                  style: TextStyleHelper.instance.label10LightPoppins
                      .copyWith(fontSize: 11.fSize, color: appColors.gray_100),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: notifier.toggle24HourFormat,
            child: CustomImageView(
              imagePath: (state.use24HourFormat ?? false)
                  ? ImageConstant.imgStatusChecked
                  : ImageConstant.imgStatusUnchecked,
              height: 44.h,
              width: 36.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
