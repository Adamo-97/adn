import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';
import 'package:intl/intl.dart';
import 'weekly_statistics.dart'; // Import StatCard

class MonthlyStatistics extends ConsumerWidget {
  final int monthOffset; // 0 = current month, -1 = previous month, etc.

  const MonthlyStatistics({
    super.key,
    this.monthOffset = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final currentMonth = analyticsNotifier.getMonthData(monthOffset);
    final previousMonth = analyticsNotifier.getMonthData(monthOffset - 1);
    final twoMonthsAgo = analyticsNotifier.getMonthData(monthOffset - 2);
    final threeMonthsAgo = analyticsNotifier.getMonthData(monthOffset - 3);

    // Check if month is complete (all days are in the past)
    final now = DateTime.now();
    final monthEnd = DateTime(
      currentMonth.monthStart.year,
      currentMonth.monthStart.month + 1,
      0,
    );
    final isMonthComplete = monthEnd.isBefore(now) ||
        (monthEnd.year == now.year &&
            monthEnd.month == now.month &&
            monthEnd.day == now.day);

    // Calculate statistics from single source of truth
    final monthCompletion =
        '${currentMonth.totalCompleted}/${currentMonth.totalPossible}';
    final completionPercent = isMonthComplete
        ? '${(currentMonth.completionRate * 100).round()}% Complete'
        : 'In Progress';

    // Calculate comparison with previous month (only if current month is complete)
    final improvement =
        currentMonth.completionRate - previousMonth.completionRate;
    final improvementPercent = !isMonthComplete
        ? 'In Progress'
        : (improvement >= 0
            ? '+${(improvement * 100).round()}%'
            : '${(improvement * 100).round()}%');
    final previousMonthName =
        DateFormat('MMM yyyy').format(previousMonth.monthStart);

    // Active days (days with at least 1 prayer)
    final activeDaysCount = currentMonth.activeDays;
    final totalDays = currentMonth.dailyData.length;
    final activeDaysText = '$activeDaysCount/$totalDays';
    final activeDaysPercent =
        '${((activeDaysCount / totalDays) * 100).round()}% Days active';

    // 3-month average comparison (only if current month is complete)
    final threeMonthAvg = (previousMonth.completionRate +
            twoMonthsAgo.completionRate +
            threeMonthsAgo.completionRate) /
        3;
    final vsThreeMonthAvg = currentMonth.completionRate - threeMonthAvg;
    final threeMonthComparisonPercent = !isMonthComplete
        ? 'In Progress'
        : (vsThreeMonthAvg >= 0
            ? '+${(vsThreeMonthAvg * 100).round()}%'
            : '${(vsThreeMonthAvg * 100).round()}%');
    final threeMonthText =
        vsThreeMonthAvg >= 0 ? 'Above average' : 'Below average';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Month Completion',
                value: monthCompletion,
                subtitle: completionPercent,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
                title: 'vs Last Month',
                value: improvementPercent,
                subtitle: 'vs $previousMonthName',
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
                title: 'Active Days',
                value: activeDaysText,
                subtitle: activeDaysPercent,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
                title: 'vs 3-Month Avg',
                value: threeMonthComparisonPercent,
                subtitle: threeMonthText,
                isComparison: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
