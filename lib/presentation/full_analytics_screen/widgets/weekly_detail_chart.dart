import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/models/prayer_analytics_data.dart';

class WeeklyDetailChart extends ConsumerStatefulWidget {
  final Function(DailyPrayerData?)? onDaySelected;
  final Function(int)?
      onWeekOffsetChanged; // New callback for week offset changes

  const WeeklyDetailChart({
    super.key,
    this.onDaySelected,
    this.onWeekOffsetChanged,
  });

  @override
  ConsumerState<WeeklyDetailChart> createState() => _WeeklyDetailChartState();
}

class _WeeklyDetailChartState extends ConsumerState<WeeklyDetailChart> {
  int _weekOffset = 0;
  int? _selectedDayIndex;

  List<DailyPrayerData> _getWeekData() {
    // Get data from analytics provider
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final weekStats = analyticsNotifier.getWeekData(_weekOffset);
    return weekStats.dailyData;
  }

  List<Map<String, dynamic>> _getWeekDataForDisplay() {
    final dailyData = _getWeekData();

    return dailyData.asMap().entries.map((entry) {
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

  @override
  Widget build(BuildContext context) {
    final weekData = _getWeekData();
    final weekDataForDisplay = _getWeekDataForDisplay();
    final firstDay = weekData.first.date;
    final lastDay = weekData.last.date;
    final dateRange =
        '${firstDay.day}/${firstDay.month} - ${lastDay.day}/${lastDay.month}';

    return Container(
      height: 280.h,
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: appColors.gray_700),
                onPressed: () => setState(() {
                  _weekOffset--;
                  _selectedDayIndex = null;
                  widget.onWeekOffsetChanged?.call(_weekOffset);
                }),
              ),
              Text(
                dateRange,
                style: TextStyleHelper.instance.body12SemiBoldPoppins
                    .copyWith(color: appColors.whiteA700),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: _weekOffset < 0
                      ? appColors.gray_700
                      : appColors.gray_700.withAlpha((0.3 * 255).round()),
                ),
                onPressed: _weekOffset < 0
                    ? () => setState(() {
                          _weekOffset++;
                          _selectedDayIndex = null;
                          widget.onWeekOffsetChanged?.call(_weekOffset);
                        })
                    : null,
              ),
            ],
          ),
          Expanded(
            child: CustomPaint(
              painter: WeeklyDetailPainter(
                weekData: weekDataForDisplay,
                selectedIndex: _selectedDayIndex,
                theme: appColors,
              ),
              child: GestureDetector(
                onTapDown: (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localPosition =
                      box.globalToLocal(details.globalPosition);
                  final yAxisWidth = 20.0;
                  final chartWidth = box.size.width - yAxisWidth;
                  final barWidth = chartWidth / 7;
                  final tappedIndex =
                      ((localPosition.dx - yAxisWidth) / barWidth)
                          .floor()
                          .clamp(0, 6);

                  setState(() {
                    if (tappedIndex == _selectedDayIndex) {
                      _selectedDayIndex = null;
                      widget.onDaySelected?.call(null);
                    } else {
                      _selectedDayIndex = tappedIndex;
                      widget.onDaySelected?.call(weekData[tappedIndex]);
                    }
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

class WeeklyDetailPainter extends CustomPainter {
  final List<Map<String, dynamic>> weekData;
  final int? selectedIndex;
  final DarkCodeColors theme;

  WeeklyDetailPainter({
    required this.weekData,
    required this.selectedIndex,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const maxValue = 5;
    final chartHeight = size.height - 30;
    final yAxisWidth = 20.0;
    final chartStartX = yAxisWidth;
    final chartWidth = size.width - yAxisWidth;
    final adjustedBarWidth = chartWidth / 7;

    // Draw grid and Y-axis
    final gridPaint = Paint()
      ..color = theme.gray_700.withAlpha((0.2 * 255).round())
      ..strokeWidth = 1;

    for (int i = 0; i <= maxValue; i++) {
      final y = chartHeight - (i / maxValue * chartHeight);
      _drawDottedLine(
          canvas, Offset(chartStartX, y), Offset(size.width, y), gridPaint);

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
      yValuePainter.paint(canvas, Offset(0, y - yValuePainter.height / 2));
    }

    // Draw bars
    for (int i = 0; i < weekData.length; i++) {
      final data = weekData[i];
      final completed = data['completed'] as int;
      final isToday = data['isToday'] as bool;
      final isFuture = data['isFuture'] as bool;
      final isSelected = i == selectedIndex;

      if (isFuture) continue;

      final barHeight = (completed / maxValue) * chartHeight;
      final x = chartStartX + i * adjustedBarWidth + adjustedBarWidth * 0.2;
      final width = adjustedBarWidth * 0.6;

      Color barColor = isSelected
          ? theme.orange_200
          : isToday
              ? theme.orange_200.withAlpha((0.7 * 255).round())
              : theme.gray_700;

      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, chartHeight - barHeight, width, barHeight),
        Radius.circular(6),
      );

      canvas.drawRRect(barRect, Paint()..color = barColor);

      // Day label
      final dayName = data['dayName'] as String;
      final textPainter = TextPainter(
        text: TextSpan(
          text: dayName,
          style: TextStyle(
            color: theme.whiteA700.withAlpha((0.6 * 255).round()),
            fontSize: 10,
            fontWeight: FontWeight.w400,
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

      // Value label
      if (isSelected) {
        final valuePainter = TextPainter(
          text: TextSpan(
            text: '$completed/5',
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
  bool shouldRepaint(WeeklyDetailPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.weekData != weekData;
  }
}
