import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'weekly_statistics.dart'; // Import StatCard

class MonthlyStatistics extends StatelessWidget {
  const MonthlyStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with actual data from notifier later
    final monthlyData = _getMonthlyStats();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Month Completion',
                value: monthlyData['completion']!,
                subtitle: monthlyData['completionSubtitle']!,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
                title: 'vs Last Month',
                value: monthlyData['comparison']!,
                subtitle: monthlyData['comparisonSubtitle']!,
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
                value: monthlyData['activeDays']!,
                subtitle: monthlyData['activeDaysSubtitle']!,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
                title: 'vs 3-Month Avg',
                value: monthlyData['threeMonthComparison']!,
                subtitle: monthlyData['threeMonthSubtitle']!,
                isComparison: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<String, String> _getMonthlyStats() {
    // Mock data - this will come from your notifier
    return {
      'completion': '98/155',
      'completionSubtitle': '63% Complete',
      'comparison': '+12%',
      'comparisonSubtitle': 'vs Sept 2025',
      'activeDays': '23/31',
      'activeDaysSubtitle': '74% Days active',
      'threeMonthComparison': '+8%',
      'threeMonthSubtitle': 'Above average',
    };
  }
}
