import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';
import 'package:intl/intl.dart';

class WeeklyStatistics extends ConsumerWidget {
  final int weekOffset; // 0 = current week, -1 = previous week, etc.

  const WeeklyStatistics({
    super.key,
    this.weekOffset = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final currentWeek = analyticsNotifier.getWeekData(weekOffset);
    final previousWeek = analyticsNotifier.getWeekData(weekOffset - 1);

    // Check if week is complete (all days are in the past)
    final now = DateTime.now();
    final weekEnd = currentWeek.weekEnd;
    final isWeekComplete = weekEnd.isBefore(now) ||
        (weekEnd.year == now.year &&
            weekEnd.month == now.month &&
            weekEnd.day == now.day);

    // Calculate statistics from single source of truth
    final weekCompletion =
        '${currentWeek.totalCompleted}/${currentWeek.totalPossible}';
    final completionPercent = isWeekComplete
        ? '${(currentWeek.completionRate * 100).round()}% Complete'
        : 'In Progress';

    // Calculate comparison with previous week (only if current week is complete)
    final improvement =
        currentWeek.completionRate - previousWeek.completionRate;
    final improvementPercent = !isWeekComplete
        ? 'In Progress'
        : (improvement >= 0
            ? '+${(improvement * 100).round()}%'
            : '${(improvement * 100).round()}%');
    final improvementText = improvement >= 0 ? 'Improvement' : 'Decline';

    // Find best day
    var bestDayData = currentWeek.dailyData.first;
    for (final day in currentWeek.dailyData) {
      if (day.completedPrayers > bestDayData.completedPrayers) {
        bestDayData = day;
      }
    }
    final bestDayName = DateFormat('EEEE').format(bestDayData.date);
    final bestDayPrayers = '${bestDayData.completedPrayers}/5 Prayers';

    // Calculate streak (consecutive days with all 5 prayers)
    int streak = 0;
    for (int i = currentWeek.dailyData.length - 1; i >= 0; i--) {
      if (currentWeek.dailyData[i].completedPrayers == 5 &&
          !currentWeek.dailyData[i].isFuture) {
        streak++;
      } else if (!currentWeek.dailyData[i].isFuture) {
        break; // Stop counting if we hit a non-perfect day
      }
    }
    final streakText =
        streak > 0 ? '$streak ${streak == 1 ? 'Day' : 'Days'}' : 'None';
    final streakSubtext = streak > 0 ? 'Full prayers' : 'Keep going!';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Week Completion',
                value: weekCompletion,
                subtitle: completionPercent,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
                title: 'vs Last Week',
                value: improvementPercent,
                subtitle: improvementText,
                isComparison: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Best Day',
                value: bestDayName,
                subtitle: bestDayPrayers,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
                title: 'Week Streak',
                value: streakText,
                subtitle: streakSubtext,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final bool isComparison;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.isComparison = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine color based on comparison value
    Color valueColor = appColors.orange_200;
    if (isComparison) {
      if (value.startsWith('+')) {
        valueColor = appColors.success; // Green for positive
      } else if (value.startsWith('-')) {
        valueColor = appColors.error; // Red for negative
      }
    }

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appColors.gray_700.withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appColors.gray_700.withAlpha((0.3 * 255).round()),
          width: 1.h,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyleHelper.instance.label10LightPoppins.copyWith(
                color: appColors.whiteA700.withAlpha((0.6 * 255).round())),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyleHelper.instance.body14SemiBoldPoppins
                .copyWith(color: valueColor, fontSize: 18.fSize),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyleHelper.instance.label10LightPoppins.copyWith(
                color: appColors.whiteA700.withAlpha((0.4 * 255).round())),
          ),
        ],
      ),
    );
  }
}
