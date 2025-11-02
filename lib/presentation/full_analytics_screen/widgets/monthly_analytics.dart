import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/models/prayer_analytics_data.dart';
import 'monthly_heatmap_chart.dart';
import 'monthly_statistics.dart';
import 'section_header.dart';
import 'prayer_detail_card.dart';

class MonthlyAnalytics extends ConsumerStatefulWidget {
  const MonthlyAnalytics({super.key});

  @override
  ConsumerState<MonthlyAnalytics> createState() => _MonthlyAnalyticsState();
}

class _MonthlyAnalyticsState extends ConsumerState<MonthlyAnalytics> {
  DailyPrayerData? _selectedDayData;
  int _monthOffset = 0; // Track current month offset

  void _onDaySelected(DailyPrayerData? dayData) {
    setState(() {
      _selectedDayData = dayData;
    });
  }

  void _onMonthOffsetChanged(int newOffset) {
    setState(() {
      _monthOffset = newOffset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Statistics Cards (moved to top)
        const SectionHeader(title: 'Monthly Statistics'),
        SizedBox(height: 16.h),
        MonthlyStatistics(monthOffset: _monthOffset),
        SizedBox(height: 32.h),

        // 2. Heatmap (moved to middle)
        const SectionHeader(title: 'Monthly Heatmap'),
        SizedBox(height: 16.h),
        MonthlyHeatmapChart(
          onDaySelected: _onDaySelected,
          onMonthOffsetChanged: _onMonthOffsetChanged,
        ),
        SizedBox(height: 16.h),

        // 3. Day Detail Card (always shown)
        const SectionHeader(title: 'Day Details'),
        PrayerDetailCard(dayData: _selectedDayData),
      ],
    );
  }
}
