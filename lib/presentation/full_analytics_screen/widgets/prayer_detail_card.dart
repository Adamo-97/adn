import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/models/prayer_analytics_data.dart';
import 'package:intl/intl.dart';

/// Widget that displays detailed prayer status for a specific day
/// Shows which prayers were completed (green box) and missed (empty state)
/// If no day is selected, shows a placeholder message
class PrayerDetailCard extends StatelessWidget {
  final DailyPrayerData? dayData;

  const PrayerDetailCard({
    super.key,
    this.dayData,
  });

  @override
  Widget build(BuildContext context) {
    final prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    return Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appColors.gray_700.withValues(alpha: 0.3),
          width: 1.h,
        ),
      ),
      child: dayData == null ? _buildPlaceholder() : _buildDayDetails(prayers),
    );
  }

  /// Placeholder shown when no day is selected
  Widget _buildPlaceholder() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Text(
          'Click on a day to see full preview',
          style: TextStyleHelper.instance.body14SemiBoldPoppins.copyWith(
            color: appColors.gray_500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Day details with prayer breakdown
  Widget _buildDayDetails(List<String> prayers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with date
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE, MMM d').format(dayData!.date),
              style: TextStyleHelper.instance.body14SemiBoldPoppins
                  .copyWith(color: appColors.whiteA700),
            ),
            SizedBox(height: 4.h),
            Text(
              '${dayData!.completedPrayers}/5 Prayers Completed',
              style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
                color: appColors.gray_500,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // Prayer grid (5 columns)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: prayers.map((prayer) {
            final isCompleted = dayData!.prayerStatuses[prayer] ?? false;
            return _buildPrayerColumn(prayer, isCompleted);
          }).toList(),
        ),
      ],
    );
  }

  /// Builds a single prayer column with name and status indicator
  Widget _buildPrayerColumn(String prayerName, bool isCompleted) {
    return Column(
      children: [
        // Prayer status box
        Container(
          height: 44.h,
          width: 44.h,
          decoration: BoxDecoration(
            color: isCompleted
                ? appColors.success.withValues(alpha: 0.2)
                : Colors.transparent,
            border: Border.all(
              color: isCompleted ? appColors.success : appColors.gray_600,
              width: 2.h,
            ),
            borderRadius: BorderRadius.circular(8.h),
          ),
          child: isCompleted
              ? Icon(
                  Icons.check,
                  color: appColors.success,
                  size: 24.h,
                )
              : null,
        ),
        SizedBox(height: 8.h),
        // Prayer name
        Text(
          prayerName,
          style: TextStyleHelper.instance.label10LightPoppins.copyWith(
            color: isCompleted ? appColors.whiteA700 : appColors.gray_500,
            fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
