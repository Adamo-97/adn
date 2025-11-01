import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../notifier/profile_settings_notifier.dart';

/// Modern prayer reminders toggle setting
class PrayerReminders extends ConsumerWidget {
  const PrayerReminders({super.key});

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
              imagePath: ImageConstant.imgAppmodeIconWhiteA70024x24,
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
                  'Prayer Reminders',
                  style: TextStyleHelper.instance.title18SemiBoldPoppins
                      .copyWith(fontSize: 16.fSize),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Remind me 30 mins before next prayer',
                  style: TextStyleHelper.instance.label10LightPoppins
                      .copyWith(fontSize: 11.fSize, color: appColors.gray_100),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: notifier.togglePrayerReminders,
            child: CustomImageView(
              imagePath: (state.prayerReminders ?? false)
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
