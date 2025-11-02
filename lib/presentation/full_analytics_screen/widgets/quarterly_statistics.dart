import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';
import 'package:intl/intl.dart';
import 'weekly_statistics.dart'; // Import StatCard

class QuarterlyStatistics extends ConsumerWidget {
  final int quarterOffset; // 0 = current quarter, -1 = previous quarter, etc.

  const QuarterlyStatistics({
    super.key,
    this.quarterOffset = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final currentQuarter = analyticsNotifier.getQuarterData(quarterOffset);
    final previousQuarter = analyticsNotifier.getQuarterData(quarterOffset - 1);

    // Check if quarter is complete (all days are in the past)
    final now = DateTime.now();
    final quarterEnd = currentQuarter.quarterEnd;
    final isQuarterComplete = quarterEnd.isBefore(now) ||
        (quarterEnd.year == now.year &&
            quarterEnd.month == now.month &&
            quarterEnd.day == now.day);

    // Calculate statistics from single source of truth
    final quarterCompletion =
        '${currentQuarter.totalCompleted}/${currentQuarter.totalPossible}';
    final completionPercent = isQuarterComplete
        ? '${(currentQuarter.completionRate * 100).round()}% Complete'
        : 'In Progress';

    // Calculate comparison with previous quarter (only if current quarter is complete)
    final improvement =
        currentQuarter.completionRate - previousQuarter.completionRate;
    final improvementPercent = !isQuarterComplete
        ? 'In Progress'
        : (improvement >= 0
            ? '+${(improvement * 100).round()}%'
            : '${(improvement * 100).round()}%');
    final quarterLabel =
        'vs Q${previousQuarter.quarterNumber} ${previousQuarter.quarterStart.year}';

    // Find best month in quarter
    var bestMonth = currentQuarter.monthlyData.first;
    for (final month in currentQuarter.monthlyData) {
      if (month.completionRate > bestMonth.completionRate) {
        bestMonth = month;
      }
    }
    final bestMonthName = DateFormat('MMMM').format(bestMonth.monthStart);
    final bestMonthStats =
        '${bestMonth.totalCompleted}/${bestMonth.totalPossible} (${(bestMonth.completionRate * 100).round()}%)';

    // Calculate year-to-date progress (from the analytics data)
    final data = ref.watch(prayerAnalyticsProvider);
    final yearProgress =
        data != null ? '${(data.yearCompletionRate * 100).round()}%' : '0%';
    final yearStats = data != null
        ? '${data.yearTotalCompleted}/${data.yearTotalPossible}'
        : '0/0';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Quarter Completion',
                value: quarterCompletion,
                subtitle: completionPercent,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
                title: 'vs Last Quarter',
                value: improvementPercent,
                subtitle: quarterLabel,
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
                title: 'Best Month',
                value: bestMonthName,
                subtitle: bestMonthStats,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
                title: 'Year Progress',
                value: yearProgress,
                subtitle: yearStats,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
