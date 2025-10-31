import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';

class WeeklyStatistics extends StatelessWidget {
  const WeeklyStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with actual data from notifier later
    final weeklyData = _getWeeklyStats();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Week Completion',
                value: weeklyData['completion']!,
                subtitle: weeklyData['completionSubtitle']!,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
                title: 'vs Last Week',
                value: weeklyData['comparison']!,
                subtitle: weeklyData['comparisonSubtitle']!,
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
                value: weeklyData['bestDay']!,
                subtitle: weeklyData['bestDaySubtitle']!,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
                title: 'Week Streak',
                value: weeklyData['streak']!,
                subtitle: weeklyData['streakSubtitle']!,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<String, String> _getWeeklyStats() {
    // Mock data - this will come from your notifier
    return {
      'completion': '28/35',
      'completionSubtitle': '80% Complete',
      'comparison': '+6%',
      'comparisonSubtitle': 'Improvement',
      'bestDay': 'Friday',
      'bestDaySubtitle': '5/5 Prayers',
      'streak': '4 Days',
      'streakSubtitle': 'Full prayers',
    };
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
        valueColor = const Color(0xFF4CAF50); // Green for positive
      } else if (value.startsWith('-')) {
        valueColor = const Color(0xFFF44336); // Red for negative
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
