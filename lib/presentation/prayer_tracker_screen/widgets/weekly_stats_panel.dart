import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/full_analytics_screen/full_analytics_screen.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';

class WeeklyStatsPanel extends StatelessWidget {
  final bool isOpen;
  const WeeklyStatsPanel({super.key, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, anim) => SizeTransition(
        sizeFactor: anim,
        axisAlignment: -1.0,
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: !isOpen
          ? const SizedBox.shrink(key: ValueKey('weekly-off'))
          : Column(
              key: const ValueKey('weekly-on'),
              children: const [
                _WeeklySpacingTop(),
                _WeeklyChart(),
                _WeeklySpacingBetween(),
                _FullAnalyticsButton(),
              ],
            ),
    );
  }
}

class _WeeklySpacingTop extends StatelessWidget {
  const _WeeklySpacingTop();
  @override
  Widget build(BuildContext context) => SizedBox(height: 28.h);
}

class _WeeklySpacingBetween extends StatelessWidget {
  const _WeeklySpacingBetween();
  @override
  Widget build(BuildContext context) => SizedBox(height: 16.h);
}

class _WeeklyChart extends ConsumerStatefulWidget {
  const _WeeklyChart();

  @override
  ConsumerState<_WeeklyChart> createState() => _WeeklyChartState();
}

class _WeeklyChartState extends ConsumerState<_WeeklyChart> {
  int _weekOffset = 0; // 0 = current week, -1 = previous week, etc.
  int? _selectedDayIndex;

  List<Map<String, dynamic>> _getWeekData() {
    // Get data from analytics provider
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final weekStats = analyticsNotifier.getWeekData(_weekOffset);

    // Convert to format expected by the chart
    return weekStats.dailyData.asMap().entries.map((entry) {
      final index = entry.key;
      final dayData = entry.value;
      final dayNames = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

      return {
        'date': dayData.date,
        'dayName': dayNames[index],
        'completed': dayData.completedPrayers,
        'isToday': dayData.isToday,
        'isFuture': dayData.isFuture,
      };
    }).toList();
  }

  bool _canGoNext() {
    return _weekOffset < 0;
  }

  bool _canGoPrev() {
    return true; // Can always go to previous weeks
  }

  void _nextWeek() {
    if (_canGoNext()) {
      setState(() {
        _weekOffset++;
        _selectedDayIndex = null;
      });
    }
  }

  void _prevWeek() {
    if (_canGoPrev()) {
      setState(() {
        _weekOffset--;
        _selectedDayIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final weekData = _getWeekData();

    // Get first and last day of the week for date range
    final firstDay = weekData.first['date'] as DateTime;
    final lastDay = weekData.last['date'] as DateTime;
    final dateRange =
        '${firstDay.day}/${firstDay.month} - ${lastDay.day}/${lastDay.month}';

    return Container(
      height: 202.h, // Same height as Qibla compass
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          // Week navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _prevWeek,
                child: Icon(
                  Icons.chevron_left,
                  color: appColors.gray_700,
                  size: 24.h,
                ),
              ),
              Text(
                dateRange,
                style: TextStyleHelper.instance.body12SemiBoldPoppins
                    .copyWith(color: appColors.whiteA700),
              ),
              GestureDetector(
                onTap: _canGoNext() ? _nextWeek : null,
                child: Icon(
                  Icons.chevron_right,
                  color: _canGoNext()
                      ? appColors.gray_700
                      : appColors.gray_700.withAlpha((0.3 * 255).round()),
                  size: 24.h,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Bar chart
          Expanded(
            child: CustomPaint(
              painter: _WeeklyBarChartPainter(
                weekData: weekData,
                selectedIndex: _selectedDayIndex,
                theme: appColors,
              ),
              child: GestureDetector(
                onTapDown: (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localPosition =
                      box.globalToLocal(details.globalPosition);
                  final chartWidth = box.size.width;
                  final barWidth = chartWidth / 7;
                  final tappedIndex =
                      (localPosition.dx / barWidth).floor().clamp(0, 6);

                  setState(() {
                    _selectedDayIndex =
                        tappedIndex == _selectedDayIndex ? null : tappedIndex;
                  });
                },
                behavior: HitTestBehavior.opaque,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyBarChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> weekData;
  final int? selectedIndex;
  final DarkCodeColors theme;

  _WeeklyBarChartPainter({
    required this.weekData,
    required this.selectedIndex,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const maxValue = 5;
    final chartHeight = size.height - 30; // Leave space for labels
    final yAxisWidth = 20.0; // Space for Y-axis labels
    final chartStartX = yAxisWidth;
    final chartWidth = size.width - yAxisWidth;
    final adjustedBarWidth = chartWidth / 7;

    // Draw horizontal grid lines (dotted) and Y-axis values
    final gridPaint = Paint()
      ..color = theme.gray_700.withAlpha((0.2 * 255).round())
      ..strokeWidth = 1;

    for (int i = 0; i <= maxValue; i++) {
      final y = chartHeight - (i / maxValue * chartHeight);
      _drawDottedLine(
          canvas, Offset(chartStartX, y), Offset(size.width, y), gridPaint);

      // Draw Y-axis value
      final yValuePainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(
            color: theme.whiteA700.withAlpha((0.4 * 255).round()),
            fontSize: 9,
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      yValuePainter.layout();
      yValuePainter.paint(
        canvas,
        Offset(0, y - yValuePainter.height / 2),
      );
    }

    // Draw bars
    for (int i = 0; i < weekData.length; i++) {
      final data = weekData[i];
      final completed = data['completed'] as int;
      final isToday = data['isToday'] as bool;
      final isFuture = data['isFuture'] as bool;
      final isSelected = i == selectedIndex;

      if (isFuture) continue; // Don't show future days

      final barHeight = (completed / maxValue) * chartHeight;
      final x = chartStartX + i * adjustedBarWidth + adjustedBarWidth * 0.2;
      final width = adjustedBarWidth * 0.6;

      // Bar color
      Color barColor;
      if (isSelected) {
        barColor = theme.orange_200;
      } else if (isToday) {
        barColor = theme.orange_200.withAlpha((0.7 * 255).round());
      } else {
        barColor = theme.gray_700;
      }

      // Draw bar
      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, chartHeight - barHeight, width, barHeight),
        Radius.circular(4),
      );
      canvas.drawRRect(
        barRect,
        Paint()..color = barColor,
      );

      // Draw day label
      final dayName = data['dayName'] as String;
      final textPainter = TextPainter(
        text: TextSpan(
          text: dayName,
          style: TextStyle(
            color: isToday
                ? theme.orange_200
                : theme.whiteA700.withAlpha((0.6 * 255).round()),
            fontSize: 10,
            fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          chartStartX +
              i * adjustedBarWidth +
              (adjustedBarWidth - textPainter.width) / 2,
          chartHeight + 8,
        ),
      );

      // Draw value if selected
      if (isSelected) {
        final valuePainter = TextPainter(
          text: TextSpan(
            text: '$completed',
            style: TextStyle(
              color: theme.orange_200,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        valuePainter.layout();
        valuePainter.paint(
          canvas,
          Offset(
            chartStartX +
                i * adjustedBarWidth +
                (adjustedBarWidth - valuePainter.width) / 2,
            chartHeight - barHeight - 16,
          ),
        );
      }
    }
  }

  void _drawDottedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double distance = (end - start).distance;
    double normalizedDistance = distance / (dashWidth + dashSpace);

    for (int i = 0; i < normalizedDistance; i++) {
      final x1 = start.dx + (end.dx - start.dx) * i / normalizedDistance;
      final y1 = start.dy + (end.dy - start.dy) * i / normalizedDistance;
      final x2 =
          start.dx + (end.dx - start.dx) * (i + 0.5) / normalizedDistance;
      final y2 =
          start.dy + (end.dy - start.dy) * (i + 0.5) / normalizedDistance;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(_WeeklyBarChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.weekData != weekData;
  }
}

class _FullAnalyticsButton extends StatelessWidget {
  const _FullAnalyticsButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Use root navigator to escape the nested navigator in bottom bar
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => FullAnalyticsScreen(analyticsType: 'weekly'),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
        decoration: BoxDecoration(
          color: appColors.gray_700.withAlpha((0.3 * 255).round()),
          borderRadius: BorderRadius.circular(8.h),
          border: Border.all(
            color: appColors.gray_700.withAlpha((0.5 * 255).round()),
            width: 1.h,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Full Analytics',
              style: TextStyleHelper.instance.label10LightPoppins
                  .copyWith(color: appColors.whiteA700),
            ),
            SizedBox(width: 6.h),
            Icon(
              Icons.arrow_forward,
              color: appColors.whiteA700,
              size: 12.h,
            ),
          ],
        ),
      ),
    );
  }
}
