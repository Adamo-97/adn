import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/models/prayer_analytics_data.dart';
import 'weekly_detail_chart.dart';
import 'weekly_statistics.dart';
import 'section_header.dart';
import 'prayer_detail_card.dart';

class WeeklyAnalytics extends ConsumerStatefulWidget {
  const WeeklyAnalytics({super.key});

  @override
  ConsumerState<WeeklyAnalytics> createState() => _WeeklyAnalyticsState();
}

class _WeeklyAnalyticsState extends ConsumerState<WeeklyAnalytics> {
  DailyPrayerData? _selectedDayData;
  int _weekOffset = 0; // Track current week offset

  void _onDaySelected(DailyPrayerData? dayData) {
    setState(() {
      _selectedDayData = dayData;
    });
  }

  void _onWeekOffsetChanged(int newOffset) {
    setState(() {
      _weekOffset = newOffset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Statistics Cards (moved to top)
        const SectionHeader(title: 'Weekly Statistics'),
        SizedBox(height: 16.h),
        WeeklyStatistics(weekOffset: _weekOffset),
        SizedBox(height: 32.h),

        // 2. Chart (moved to middle)
        const SectionHeader(title: 'Weekly Overview'),
        SizedBox(height: 16.h),
        WeeklyDetailChart(
          onDaySelected: _onDaySelected,
          onWeekOffsetChanged: _onWeekOffsetChanged,
        ),
        SizedBox(height: 16.h),

        // 3. Day Detail Card (always shown)
        const SectionHeader(title: 'Day Details'),
        PrayerDetailCard(dayData: _selectedDayData),
      ],
    );
  }
}
