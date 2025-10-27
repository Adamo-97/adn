import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';

class MonthlyHeatmapChart extends ConsumerStatefulWidget {
  final bool showNavigation;

  const MonthlyHeatmapChart({super.key, this.showNavigation = true});

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

  bool _canGoNext() => _monthOffset < 0;
  bool _canGoPrev() => true;

  void _nextMonth() {
    if (_canGoNext()) {
      setState(() {
        _monthOffset++;
        _selectedDayIndex = null;
      });
    }
  }

  void _prevMonth() {
    if (_canGoPrev()) {
      setState(() {
        _monthOffset--;
        _selectedDayIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthData = _getMonthData();

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.gray_700.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appTheme.gray_700.withOpacity(0.3),
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
                          ? appTheme.white_A700
                          : appTheme.gray_700,
                      size: 20.h),
                  onPressed: _canGoPrev() ? _prevMonth : null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Text(
                  _getMonthLabel(),
                  style: TextStyleHelper.instance.body14SemiBoldPoppins
                      .copyWith(color: appTheme.white_A700),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right,
                      color: _canGoNext()
                          ? appTheme.white_A700
                          : appTheme.gray_700,
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
                    .copyWith(color: appTheme.white_A700),
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
                                color: appTheme.white_A700.withOpacity(0.5)),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 12.h),
          // Heatmap grid
          SizedBox(
            height: 200.h,
            child: CustomPaint(
              painter: MonthlyHeatmapPainter(
                monthData: monthData,
                selectedIndex: _selectedDayIndex,
                theme: appTheme,
                today: _getTodayIndex(),
              ),
              child: GestureDetector(
                onTapDown: (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localPosition =
                      box.globalToLocal(details.globalPosition);
                  final cellSize = (box.size.width / 7);
                  final row = (localPosition.dy / (cellSize + 4)).floor();
                  final col = (localPosition.dx / (cellSize + 4)).floor();
                  final tappedIndex = (row * 7 + col);

                  if (tappedIndex < monthData.length) {
                    setState(() {
                      _selectedDayIndex =
                          tappedIndex == _selectedDayIndex ? null : tappedIndex;
                    });
                  }
                },
                behavior: HitTestBehavior.opaque,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Less',
                style: TextStyleHelper.instance.label10LightPoppins
                    .copyWith(color: appTheme.white_A700.withOpacity(0.5)),
              ),
              SizedBox(width: 8.h),
              ...List.generate(
                6,
                (i) => Container(
                  width: 16.h,
                  height: 16.h,
                  margin: EdgeInsets.symmetric(horizontal: 2.h),
                  decoration: BoxDecoration(
                    color: _getHeatmapColor(i, appTheme),
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
              ),
              SizedBox(width: 8.h),
              Text(
                'More',
                style: TextStyleHelper.instance.label10LightPoppins
                    .copyWith(color: appTheme.white_A700.withOpacity(0.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHeatmapColor(int count, LightCodeColors theme) {
    if (count == 0) return theme.gray_700.withOpacity(0.3);
    if (count == 1) return theme.orange_200.withOpacity(0.2);
    if (count == 2) return theme.orange_200.withOpacity(0.4);
    if (count == 3) return theme.orange_200.withOpacity(0.6);
    if (count == 4) return theme.orange_200.withOpacity(0.8);
    return theme.orange_200; // 5 prayers
  }
}

class MonthlyHeatmapPainter extends CustomPainter {
  final List<int> monthData;
  final int? selectedIndex;
  final LightCodeColors theme;
  final int today;

  MonthlyHeatmapPainter({
    required this.monthData,
    required this.selectedIndex,
    required this.theme,
    required this.today,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = (size.width / 7) - 4;
    final spacing = 4.0;

    for (int i = 0; i < monthData.length; i++) {
      final row = i ~/ 7;
      final col = i % 7;
      final x = col * (cellSize + spacing);
      final y = row * (cellSize + spacing);

      final count = monthData[i];
      final isSelected = i == selectedIndex;
      final isToday = i == today - 1; // 0-indexed

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
          ..color = theme.white_A700
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
              color: theme.white_A700,
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

  Color _getHeatmapColor(int count, LightCodeColors theme) {
    if (count == 0) return theme.gray_700.withOpacity(0.3);
    if (count == 1) return theme.orange_200.withOpacity(0.2);
    if (count == 2) return theme.orange_200.withOpacity(0.4);
    if (count == 3) return theme.orange_200.withOpacity(0.6);
    if (count == 4) return theme.orange_200.withOpacity(0.8);
    return theme.orange_200; // 5 prayers
  }

  @override
  bool shouldRepaint(MonthlyHeatmapPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.monthData != monthData;
  }
}
