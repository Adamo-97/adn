import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'weekly_statistics.dart'; // Import StatCard

class QuarterlyStatistics extends StatelessWidget {
  const QuarterlyStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with actual data from notifier later
    final quarterlyData = _getQuarterlyStats();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Quarter Completion',
                value: quarterlyData['completion']!,
                subtitle: quarterlyData['completionSubtitle']!,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
                title: 'vs Last Quarter',
                value: quarterlyData['comparison']!,
                subtitle: quarterlyData['comparisonSubtitle']!,
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
                value: quarterlyData['bestMonth']!,
                subtitle: quarterlyData['bestMonthSubtitle']!,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
                title: 'Year Progress',
                value: quarterlyData['yearProgress']!,
                subtitle: quarterlyData['yearProgressSubtitle']!,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<String, String> _getQuarterlyStats() {
    // Mock data - this will come from your notifier
    return {
      'completion': '412/465',
      'completionSubtitle': '89% Complete',
      'comparison': '+15%',
      'comparisonSubtitle': 'vs Q3 2025',
      'bestMonth': 'October',
      'bestMonthSubtitle': '142/155 (92%)',
      'yearProgress': '75%',
      'yearProgressSubtitle': 'Year to date',
    };
  }
}
