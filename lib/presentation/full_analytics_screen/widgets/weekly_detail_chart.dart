import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';

class WeeklyDetailChart extends ConsumerStatefulWidget {
  const WeeklyDetailChart({super.key});

  @override
  ConsumerState<WeeklyDetailChart> createState() => _WeeklyDetailChartState();
}

class _WeeklyDetailChartState extends ConsumerState<WeeklyDetailChart> {
  int _weekOffset = 0;
  int? _selectedDayIndex;

  List<Map<String, dynamic>> _getWeekData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentWeekStart = today.subtract(Duration(days: today.weekday % 7));
    final weekStart = currentWeekStart.add(Duration(days: _weekOffset * 7));

    return List.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      final isFuture = date.isAfter(today);
      final completed = isFuture
          ? 0
          : (index % 5 + (index == today.weekday % 7 ? 1 : 0)).clamp(0, 5);

      return {
        'date': date,
        'dayName': ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'][index],
        'completed': completed,
        'isToday': date.day == today.day &&
            date.month == today.month &&
            date.year == today.year,
        'isFuture': isFuture,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekData = _getWeekData();
    final firstDay = weekData.first['date'] as DateTime;
    final lastDay = weekData.last['date'] as DateTime;
    final dateRange =
        '${firstDay.day}/${firstDay.month} - ${lastDay.day}/${lastDay.month}';

    return Container(
      height: 280.h,
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: appTheme.gray_700),
                onPressed: () => setState(() {
                  _weekOffset--;
                  _selectedDayIndex = null;
                }),
              ),
              Text(
                dateRange,
                style: TextStyleHelper.instance.body12SemiBoldPoppins
                    .copyWith(color: appTheme.white_A700),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: _weekOffset < 0
                      ? appTheme.gray_700
                      : appTheme.gray_700.withOpacity(0.3),
                ),
                onPressed: _weekOffset < 0
                    ? () => setState(() {
                          _weekOffset++;
                          _selectedDayIndex = null;
                        })
                    : null,
              ),
            ],
          ),
          Expanded(
            child: CustomPaint(
              painter: WeeklyDetailPainter(
                weekData: weekData,
                selectedIndex: _selectedDayIndex,
                theme: appTheme,
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

class WeeklyDetailPainter extends CustomPainter {
  final List<Map<String, dynamic>> weekData;
  final int? selectedIndex;
  final LightCodeColors theme;

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
      ..color = theme.gray_700.withOpacity(0.2)
      ..strokeWidth = 1;

    for (int i = 0; i <= maxValue; i++) {
      final y = chartHeight - (i / maxValue * chartHeight);
      _drawDottedLine(
          canvas, Offset(chartStartX, y), Offset(size.width, y), gridPaint);

      final yValuePainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(
            color: theme.white_A700.withOpacity(0.4),
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
              ? theme.orange_200.withOpacity(0.7)
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
            color: theme.white_A700.withOpacity(0.6),
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
