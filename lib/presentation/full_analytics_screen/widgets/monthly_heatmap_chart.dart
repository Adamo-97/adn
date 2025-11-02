import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/models/prayer_analytics_data.dart';

class MonthlyHeatmapChart extends ConsumerStatefulWidget {
  final bool showNavigation;
  final Function(DailyPrayerData?)? onDaySelected;
  final Function(int)? onMonthOffsetChanged;

  const MonthlyHeatmapChart({
    super.key,
    this.showNavigation = true,
    this.onDaySelected,
    this.onMonthOffsetChanged,
  });

  @override
  ConsumerState<MonthlyHeatmapChart> createState() =>
      _MonthlyHeatmapChartState();
}

class _MonthlyHeatmapChartState extends ConsumerState<MonthlyHeatmapChart> {
  int? _selectedDayIndex;
  int _monthOffset = 0; // 0 = current month, -1 = previous month, etc.

  List<int> _getMonthData() {
    // Get data from analytics provider
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final monthStats = analyticsNotifier.getMonthData(_monthOffset);

    // Extract prayer counts from daily data
    return monthStats.dailyData
        .map((dayData) => dayData.completedPrayers)
        .toList();
  }

  String _getMonthLabel() {
    // Get data from analytics provider
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final monthStats = analyticsNotifier.getMonthData(_monthOffset);
    return monthStats.monthLabel;
  }

  int _getTodayIndex() {
    // Get today's day index in the month (0-indexed)
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final monthStats = analyticsNotifier.getMonthData(_monthOffset);

    for (int i = 0; i < monthStats.dailyData.length; i++) {
      if (monthStats.dailyData[i].isToday) {
        return i;
      }
    }
    return -1; // Today not in this month
  }

  int _getMonthStartDayOfWeek() {
    // Get which day of week the month starts on (0 = Sunday, 6 = Saturday)
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final monthStats = analyticsNotifier.getMonthData(_monthOffset);
    return monthStats.monthStart.weekday % 7; // Convert to 0-6 where 0=Sunday
  }

  bool _canGoNext() => _monthOffset < 0;
  bool _canGoPrev() => true;

  void _nextMonth() {
    if (_canGoNext()) {
      setState(() {
        _monthOffset++;
        _selectedDayIndex = null;
      });
      widget.onMonthOffsetChanged?.call(_monthOffset);
      widget.onDaySelected?.call(null); // Clear selection
    }
  }

  void _prevMonth() {
    if (_canGoPrev()) {
      setState(() {
        _monthOffset--;
        _selectedDayIndex = null;
      });
      widget.onMonthOffsetChanged?.call(_monthOffset);
      widget.onDaySelected?.call(null); // Clear selection
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthData = _getMonthData();

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
          // Month navigation header (conditional)
          if (widget.showNavigation)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left,
                      color: _canGoPrev()
                          ? appColors.whiteA700
                          : appColors.gray_700,
                      size: 20.h),
                  onPressed: _canGoPrev() ? _prevMonth : null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Text(
                  _getMonthLabel(),
                  style: TextStyleHelper.instance.body14SemiBoldPoppins
                      .copyWith(color: appColors.whiteA700),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right,
                      color: _canGoNext()
                          ? appColors.whiteA700
                          : appColors.gray_700,
                      size: 20.h),
                  onPressed: _canGoNext() ? _nextMonth : null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            )
          else
            // Just show the month label without navigation
            Center(
              child: Text(
                _getMonthLabel(),
                style: TextStyleHelper.instance.body14SemiBoldPoppins
                    .copyWith(color: appColors.whiteA700),
              ),
            ),
          SizedBox(height: 16.h),
          // Weekday labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                .map((day) => SizedBox(
                      width: 36.h,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.instance.label10LightPoppins
                            .copyWith(
                                color: appColors.whiteA700
                                    .withAlpha((0.5 * 255).round())),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 12.h),
          // Heatmap grid with dynamic height
          LayoutBuilder(
            builder: (context, constraints) {
              final monthStartOffset = _getMonthStartDayOfWeek();
              final totalCells = monthData.length + monthStartOffset;
              final rows = (totalCells / 7).ceil();
              final cellSize = (constraints.maxWidth / 7) - 4;
              final spacing = 4.0;
              final gridHeight = rows * (cellSize + spacing);

              return SizedBox(
                height: gridHeight,
                child: CustomPaint(
                  painter: MonthlyHeatmapPainter(
                    monthData: monthData,
                    selectedIndex: _selectedDayIndex,
                    theme: appColors,
                    today: _getTodayIndex(),
                    monthStartDayOfWeek: monthStartOffset,
                  ),
                  child: GestureDetector(
                    onTapDown: (details) {
                      final RenderBox box =
                          context.findRenderObject() as RenderBox;
                      final localPosition =
                          box.globalToLocal(details.globalPosition);

                      // Match painter calculation exactly
                      final cellSize = (box.size.width / 7) - 4;
                      final spacing = 4.0;
                      final cellWithSpacing = cellSize + spacing;

                      final col = (localPosition.dx / cellWithSpacing).floor();
                      final row = (localPosition.dy / cellWithSpacing).floor();
                      final gridIndex = (row * 7 + col);

                      // Account for offset from month start day
                      final dayIndex = gridIndex - monthStartOffset;

                      if (dayIndex >= 0 && dayIndex < monthData.length) {
                        final analyticsNotifier =
                            ref.read(prayerAnalyticsProvider.notifier);
                        final monthStats =
                            analyticsNotifier.getMonthData(_monthOffset);

                        setState(() {
                          if (dayIndex == _selectedDayIndex) {
                            _selectedDayIndex = null;
                            widget.onDaySelected?.call(null);
                          } else {
                            _selectedDayIndex = dayIndex;
                            widget.onDaySelected
                                ?.call(monthStats.dailyData[dayIndex]);
                          }
                        });
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 12.h),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Less',
                style: TextStyleHelper.instance.label10LightPoppins.copyWith(
                    color: appColors.whiteA700.withAlpha((0.5 * 255).round())),
              ),
              SizedBox(width: 8.h),
              ...List.generate(
                6,
                (i) => Container(
                  width: 16.h,
                  height: 16.h,
                  margin: EdgeInsets.symmetric(horizontal: 2.h),
                  decoration: BoxDecoration(
                    color: _getHeatmapColor(i, appColors),
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
              ),
              SizedBox(width: 8.h),
              Text(
                'More',
                style: TextStyleHelper.instance.label10LightPoppins.copyWith(
                    color: appColors.whiteA700.withAlpha((0.5 * 255).round())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHeatmapColor(int count, DarkCodeColors theme) {
    if (count == 0) return theme.gray_700.withAlpha((0.3 * 255).round());
    if (count == 1) return theme.orange_200.withAlpha((0.2 * 255).round());
    if (count == 2) return theme.orange_200.withAlpha((0.4 * 255).round());
    if (count == 3) return theme.orange_200.withAlpha((0.6 * 255).round());
    if (count == 4) return theme.orange_200.withAlpha((0.8 * 255).round());
    return theme.orange_200; // 5 prayers
  }
}

class MonthlyHeatmapPainter extends CustomPainter {
  final List<int> monthData;
  final int? selectedIndex;
  final DarkCodeColors theme;
  final int today;
  final int monthStartDayOfWeek; // 0=Sunday, 6=Saturday

  MonthlyHeatmapPainter({
    required this.monthData,
    required this.selectedIndex,
    required this.theme,
    required this.today,
    required this.monthStartDayOfWeek,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = (size.width / 7) - 4;
    final spacing = 4.0;

    for (int dayIndex = 0; dayIndex < monthData.length; dayIndex++) {
      // Add offset for which day of week the month starts on
      final gridIndex = dayIndex + monthStartDayOfWeek;
      final row = gridIndex ~/ 7;
      final col = gridIndex % 7;
      final x = col * (cellSize + spacing);
      final y = row * (cellSize + spacing);

      final count = monthData[dayIndex];
      final isSelected = dayIndex == selectedIndex;
      final isToday = dayIndex == today;

      // Cell background
      final cellPaint = Paint()
        ..color = _getHeatmapColor(count, theme)
        ..style = PaintingStyle.fill;

      final cellRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, cellSize, cellSize),
        Radius.circular(4),
      );
      canvas.drawRRect(cellRect, cellPaint);

      // Today indicator (white border)
      if (isToday) {
        final todayPaint = Paint()
          ..color = theme.whiteA700
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawRRect(cellRect, todayPaint);
      }

      // Selected state (orange border)
      if (isSelected) {
        final selectedPaint = Paint()
          ..color = theme.orange_200
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawRRect(cellRect, selectedPaint);

        // Show count label
        final textPainter = TextPainter(
          text: TextSpan(
            text: '$count',
            style: TextStyle(
              color: theme.whiteA700,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            x + (cellSize - textPainter.width) / 2,
            y + (cellSize - textPainter.height) / 2,
          ),
        );
      }
    }
  }

  Color _getHeatmapColor(int count, DarkCodeColors theme) {
    if (count == 0) return theme.gray_700.withAlpha((0.3 * 255).round());
    if (count == 1) return theme.orange_200.withAlpha((0.2 * 255).round());
    if (count == 2) return theme.orange_200.withAlpha((0.4 * 255).round());
    if (count == 3) return theme.orange_200.withAlpha((0.6 * 255).round());
    if (count == 4) return theme.orange_200.withAlpha((0.8 * 255).round());
    return theme.orange_200; // 5 prayers
  }

  @override
  bool shouldRepaint(MonthlyHeatmapPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.monthData != monthData;
  }
}
