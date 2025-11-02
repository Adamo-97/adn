import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/models/prayer_analytics_data.dart';
import 'package:intl/intl.dart';

/// Calendar grid showing 90 days with clickable day cells
/// Shows prayer completion rate for each day with color coding
/// Displays month dividers and labels for better organization
class QuarterlyCalendarGrid extends ConsumerStatefulWidget {
  final bool showNavigation;
  final Function(int)?
      onQuarterOffsetChanged; // Callback for quarter offset changes
  final Function(DailyPrayerData?)? onDaySelected; // Callback for day selection

  const QuarterlyCalendarGrid({
    super.key,
    this.showNavigation = true,
    this.onQuarterOffsetChanged,
    this.onDaySelected,
  });

  @override
  ConsumerState<QuarterlyCalendarGrid> createState() =>
      _QuarterlyCalendarGridState();
}

class _QuarterlyCalendarGridState extends ConsumerState<QuarterlyCalendarGrid> {
  int _quarterOffset = 0; // 0 = current quarter, -1 = previous quarter, etc.
  DailyPrayerData? _selectedDay;

  bool _canGoNext() => _quarterOffset < 0;
  bool _canGoPrev() => true;

  void _nextQuarter() {
    if (_canGoNext()) {
      setState(() {
        _quarterOffset++;
        _selectedDay = null;
      });
      widget.onQuarterOffsetChanged?.call(_quarterOffset);
      widget.onDaySelected
          ?.call(null); // Notify parent that selection was cleared
    }
  }

  void _prevQuarter() {
    if (_canGoPrev()) {
      setState(() {
        _quarterOffset--;
        _selectedDay = null;
      });
      widget.onQuarterOffsetChanged?.call(_quarterOffset);
      widget.onDaySelected
          ?.call(null); // Notify parent that selection was cleared
    }
  }

  void _onDayTapped(DailyPrayerData dayData) {
    setState(() {
      // Toggle selection: if same day tapped again, deselect
      _selectedDay = _selectedDay?.date == dayData.date ? null : dayData;
    });
    // Notify parent about selection change
    widget.onDaySelected?.call(_selectedDay);
  }

  String _getQuarterLabel() {
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final quarterStats = analyticsNotifier.getQuarterData(_quarterOffset);
    return quarterStats.quarterLabel;
  }

  /// Get color based on completion rate
  Color _getCompletionColor(double rate) {
    if (rate >= 0.9) {
      return appColors.salahEssentials; // Excellent: 90-100% (Teal)
    } else if (rate >= 0.7) {
      return appColors.salahPurification; // Good: 70-89% (Green)
    } else if (rate >= 0.5) {
      return appColors.orange_200; // Fair: 50-69% (Gold)
    } else if (rate > 0) {
      return appColors.salahSpecialSituations; // Poor: 1-49% (Coral)
    } else {
      return appColors.gray_700.withValues(alpha: 0.3); // None: 0%
    }
  }

  @override
  Widget build(BuildContext context) {
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final quarterStats = analyticsNotifier.getQuarterData(_quarterOffset);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appColors.gray_700.withValues(alpha: 0.3),
          width: 1.h,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quarter navigation header
          if (widget.showNavigation)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left,
                      color: _canGoPrev()
                          ? appColors.whiteA700
                          : appColors.gray_700.withValues(alpha: 0.3)),
                  onPressed: _canGoPrev() ? _prevQuarter : null,
                  iconSize: 24.h,
                ),
                Text(
                  _getQuarterLabel(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.fSize,
                    color: appColors.whiteA700,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right,
                      color: _canGoNext()
                          ? appColors.whiteA700
                          : appColors.gray_700.withValues(alpha: 0.3)),
                  onPressed: _canGoNext() ? _nextQuarter : null,
                  iconSize: 24.h,
                ),
              ],
            ),

          SizedBox(height: 12.h),

          // Legend - wrapped to prevent overflow
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.h,
            runSpacing: 8.h,
            children: [
              _buildLegendItem('90%+', appColors.salahEssentials),
              _buildLegendItem('70%+', appColors.salahPurification),
              _buildLegendItem('50%+', appColors.orange_200),
              _buildLegendItem('<50%', appColors.salahSpecialSituations),
            ],
          ),

          SizedBox(height: 16.h),

          // Calendar with month sections
          ...quarterStats.monthlyData.map((monthData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month header
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h, top: 8.h),
                  child: Text(
                    DateFormat('MMMM yyyy').format(monthData.monthStart),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.w600,
                      color: appColors.orange_200,
                    ),
                  ),
                ),

                // Month grid (10 days per row)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10, // 10 days per row
                    crossAxisSpacing: 6.h,
                    mainAxisSpacing: 6.h,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: monthData.dailyData.length,
                  itemBuilder: (context, index) {
                    final dayData = monthData.dailyData[index];
                    final isFuture = dayData.date.isAfter(today);
                    final isToday = dayData.date.isAtSameMomentAs(today);
                    final isSelected = _selectedDay?.date == dayData.date;

                    return GestureDetector(
                      onTap: () => _onDayTapped(dayData),
                      child: _buildDayCell(
                        dayData: dayData,
                        isFuture: isFuture,
                        isToday: isToday,
                        isSelected: isSelected,
                      ),
                    );
                  },
                ),

                // Month divider (except for last month)
                if (monthData != quarterStats.monthlyData.last)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Divider(
                      color: appColors.gray_700.withValues(alpha: 0.3),
                      height: 1.h,
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14.h,
          height: 14.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.h),
          ),
        ),
        SizedBox(width: 6.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 12.fSize,
            color: appColors.gray_500,
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell({
    required DailyPrayerData dayData,
    required bool isFuture,
    required bool isToday,
    required bool isSelected,
  }) {
    final completionRate = dayData.completedPrayers / 5.0;
    final cellColor = isFuture
        ? appColors.gray_900 // Future days: dark gray
        : _getCompletionColor(completionRate);

    return Container(
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(6.h),
        border: Border.all(
          color: isSelected
              ? appColors.whiteA700 // Selected: white border
              : isToday
                  ? appColors.orange_200 // Today: orange border
                  : Colors.transparent,
          width: isSelected || isToday ? 2.5.h : 0,
        ),
      ),
      child: Center(
        child: Text(
          '${dayData.date.day}',
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 13.fSize, // Bigger font
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
            color: isFuture
                ? appColors.gray_600
                : completionRate >= 0.5
                    ? appColors.gray_900 // Dark text on light backgrounds
                    : appColors.whiteA700, // Light text on dark backgrounds
          ),
        ),
      ),
    );
  }
}
