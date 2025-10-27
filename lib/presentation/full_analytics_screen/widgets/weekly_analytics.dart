import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'weekly_detail_chart.dart';
import 'statistics_cards.dart';
import 'section_header.dart';

class WeeklyAnalytics extends StatelessWidget {
  const WeeklyAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WeeklyDetailChart(),
        SizedBox(height: 32.h),
        const SectionHeader(title: 'Statistics'),
        SizedBox(height: 16.h),
        const StatisticsCards(),
      ],
    );
  }
}
