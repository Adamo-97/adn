import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/models/prayer_analytics_data.dart';
import 'quarterly_calendar_grid.dart';
import 'quarterly_statistics.dart';
import 'section_header.dart';
import 'prayer_detail_card.dart';

class QuarterlyAnalytics extends ConsumerStatefulWidget {
  const QuarterlyAnalytics({super.key});

  @override
  ConsumerState<QuarterlyAnalytics> createState() => _QuarterlyAnalyticsState();
}

class _QuarterlyAnalyticsState extends ConsumerState<QuarterlyAnalytics> {
  int _quarterOffset = 0; // Track current quarter offset
  DailyPrayerData? _selectedDayData; // Track selected day

  void _onQuarterOffsetChanged(int newOffset) {
    setState(() {
      _quarterOffset = newOffset;
      _selectedDayData = null; // Clear selection when quarter changes
    });
  }

  void _onDaySelected(DailyPrayerData? dayData) {
    setState(() {
      _selectedDayData = dayData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Statistics Cards (top)
        const SectionHeader(title: 'Quarterly Statistics'),
        SizedBox(height: 16.h),
        QuarterlyStatistics(quarterOffset: _quarterOffset),
        SizedBox(height: 32.h),

        // 2. Interactive Calendar Grid (middle) - NEW!
        const SectionHeader(title: 'Quarter Overview'),
        SizedBox(height: 16.h),
        QuarterlyCalendarGrid(
          onQuarterOffsetChanged: _onQuarterOffsetChanged,
          onDaySelected: _onDaySelected,
        ),
        SizedBox(height: 16.h),

        // 3. Day Detail Card (always shown at bottom)
        const SectionHeader(title: 'Day Details'),
        PrayerDetailCard(dayData: _selectedDayData),
      ],
    );
  }
}
