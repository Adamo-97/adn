import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'ninety_day_trend_chart.dart';
import 'statistics_cards.dart';
import 'section_header.dart';

class QuarterlyAnalytics extends StatelessWidget {
  const QuarterlyAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NinetyDayTrendChart(),
        SizedBox(height: 32.h),
        const SectionHeader(title: 'Statistics'),
        SizedBox(height: 16.h),
        const StatisticsCards(),
      ],
    );
  }
}
