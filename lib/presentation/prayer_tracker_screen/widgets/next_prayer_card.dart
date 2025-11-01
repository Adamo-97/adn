import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../core/utils/time_format_utils.dart';
import '../models/prayer_tracker_model.dart';
import '../notifier/prayer_tracker_notifier.dart';
import '../../profile_settings_screen/notifier/profile_settings_notifier.dart';

/// Modern card widget displaying the next prayer information with time and location.
/// Features a subtle gradient background, rounded corners, and elevation for
/// visual separation from the main content. Displays prayer icon on the right side.
/// Time format (12-hour or 24-hour) is controlled by the profile settings.
class NextPrayerCard extends ConsumerWidget {
  const NextPrayerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final m = state.prayerTrackerModel ?? PrayerTrackerModel();

    // Get time format preference from profile settings (single source of truth)
    final profileState = ref.watch(profileSettingsNotifier);
    final use24HourFormat = profileState.use24HourFormat ?? false;

    // Get the next prayer's time from dailyTimes instead of the hardcoded prayerTime field
    // Extract prayer name from the display string (e.g., "Next Prayer is Fajr" -> "Fajr")
    final nextPrayerName = m.nextPrayer.replaceAll('Next Prayer is ', '');
    final rawTime = state.dailyTimes[nextPrayerName] ?? '00:00';

    // Format the prayer time based on user preference
    final formattedTime = TimeFormatUtils.formatTime(rawTime, use24HourFormat);
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColors.gray_700,
            appColors.gray_700.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Next prayer info (prayer name, time, location)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Prayer name
                Text(
                  m.nextPrayer,
                  style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                    color: appColors.whiteA700,
                    fontSize: 18.fSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),

                // Time and location row
                Row(
                  children: [
                    // Time
                    Text(
                      formattedTime,
                      style: TextStyleHelper.instance.body12RegularPoppins
                          .copyWith(
                        color: appColors.orange_200,
                        fontSize: 13.fSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // Divider
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.h),
                      child: Container(
                        width: 1,
                        height: 12.h,
                        color: appColors.orange_200.withValues(alpha: 0.5),
                      ),
                    ),

                    // Location icon + text
                    CustomImageView(
                      imagePath: ImageConstant.imgLocationIcon,
                      height: 10.h,
                      width: 10.h,
                    ),
                    SizedBox(width: 4.h),
                    Flexible(
                      child: Text(
                        m.location,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleHelper.instance.body12RegularPoppins
                            .copyWith(
                          color: appColors.orange_200,
                          fontSize: 13.fSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 12.h),

          // Right: Prayer icon with background circle
          Container(
            width: 56.h,
            height: 56.h,
            decoration: BoxDecoration(
              color: appColors.gray_900.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomImageView(
                imagePath: ImageConstant.iconForPrayer(state.currentPrayer),
                height: 38.h,
                width: 38.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
