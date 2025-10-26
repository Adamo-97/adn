import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';

class FullAnalyticsScreen extends ConsumerStatefulWidget {
  final String? analyticsType; // 'weekly', 'monthly', or 'quarterly'

  const FullAnalyticsScreen({super.key, this.analyticsType});

  @override
  ConsumerState<FullAnalyticsScreen> createState() =>
      _FullAnalyticsScreenState();
}

class _FullAnalyticsScreenState extends ConsumerState<FullAnalyticsScreen> {
  String _getTitle() {
    switch (widget.analyticsType) {
      case 'weekly':
        return 'Weekly Analytics';
      case 'monthly':
        return 'Monthly Analytics';
      case 'quarterly':
        return 'Quarterly Analytics';
      default:
        return 'Prayer Analytics';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray_900,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appTheme.white_A700),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _getTitle(),
          style: TextStyleHelper.instance.body14SemiBoldPoppins
              .copyWith(color: appTheme.white_A700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),

                // Show content based on analytics type
                if (widget.analyticsType == 'weekly') ...[
                  const _WeeklyAnalytics(),
                ] else if (widget.analyticsType == 'monthly') ...[
                  const _MonthlyAnalytics(),
                ] else if (widget.analyticsType == 'quarterly') ...[
                  const _QuarterlyAnalytics(),
                ] else ...[
                  // Default: show all
                  _SectionHeader(title: 'Weekly Overview'),
                  SizedBox(height: 16.h),
                  const _WeeklyDetailChart(),

                  SizedBox(height: 32.h),

                  _SectionHeader(title: 'Monthly Heatmap'),
                  SizedBox(height: 16.h),
                  const _MonthlyHeatmapChart(),

                  SizedBox(height: 32.h),

                  _SectionHeader(title: '90-Day Trend'),
                  SizedBox(height: 16.h),
                  const _NinetyDayTrendChart(),

                  SizedBox(height: 32.h),

                  _SectionHeader(title: 'Statistics'),
                  SizedBox(height: 16.h),
                  const _StatisticsCards(),
                ],

                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyleHelper.instance.body14SemiBoldPoppins
          .copyWith(color: appTheme.white_A700),
    );
  }
}

class _WeeklyDetailChart extends ConsumerStatefulWidget {
  const _WeeklyDetailChart();

  @override
  ConsumerState<_WeeklyDetailChart> createState() => _WeeklyDetailChartState();
}

class _WeeklyDetailChartState extends ConsumerState<_WeeklyDetailChart> {
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
              painter: _WeeklyDetailPainter(
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

class _WeeklyDetailPainter extends CustomPainter {
  final List<Map<String, dynamic>> weekData;
  final int? selectedIndex;
  final LightCodeColors theme;

  _WeeklyDetailPainter({
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
  bool shouldRepaint(_WeeklyDetailPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.weekData != weekData;
  }
}

// Placeholder for Monthly Heatmap
class _MonthlyHeatmapChart extends StatefulWidget {
  const _MonthlyHeatmapChart();

  @override
  State<_MonthlyHeatmapChart> createState() => _MonthlyHeatmapChartState();
}

class _MonthlyHeatmapChartState extends State<_MonthlyHeatmapChart> {
  int? _selectedDayIndex;

  // Mock data: 31 days in October with prayer counts (0-5)
  final List<int> monthData = [
    4, 5, 3, 5, 4, 5, 5, // Week 1
    4, 3, 5, 4, 5, 4, 3, // Week 2
    5, 4, 5, 5, 3, 4, 5, // Week 3
    4, 5, 4, 3, 5, 4, 5, // Week 4
    5, 4, 3, // Week 5 (partial)
  ];

  @override
  Widget build(BuildContext context) {
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
          // Month navigation header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left,
                    color: appTheme.white_A700, size: 20.h),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                'October 2025',
                style: TextStyleHelper.instance.body14SemiBoldPoppins
                    .copyWith(color: appTheme.white_A700),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right,
                    color: appTheme.white_A700, size: 20.h),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
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
              painter: _MonthlyHeatmapPainter(
                monthData: monthData,
                selectedIndex: _selectedDayIndex,
                theme: appTheme,
                today: 26, // October 26, 2025
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

class _MonthlyHeatmapPainter extends CustomPainter {
  final List<int> monthData;
  final int? selectedIndex;
  final LightCodeColors theme;
  final int today;

  _MonthlyHeatmapPainter({
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
  bool shouldRepaint(_MonthlyHeatmapPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.monthData != monthData;
  }
}

// Placeholder for 90-Day Trend
class _NinetyDayTrendChart extends StatefulWidget {
  const _NinetyDayTrendChart();

  @override
  State<_NinetyDayTrendChart> createState() => _NinetyDayTrendChartState();
}

class _NinetyDayTrendChartState extends State<_NinetyDayTrendChart> {
  int? _selectedWeekIndex;

  // Mock data: 13 weeks (90 days) with average prayer completion per week
  final List<Map<String, dynamic>> quarterData = [
    {'week': 'W1', 'avg': 4.2},
    {'week': 'W2', 'avg': 4.5},
    {'week': 'W3', 'avg': 3.8},
    {'week': 'W4', 'avg': 4.7},
    {'week': 'W5', 'avg': 4.3},
    {'week': 'W6', 'avg': 4.9},
    {'week': 'W7', 'avg': 4.6},
    {'week': 'W8', 'avg': 4.1},
    {'week': 'W9', 'avg': 4.4},
    {'week': 'W10', 'avg': 4.8},
    {'week': 'W11', 'avg': 4.2},
    {'week': 'W12', 'avg': 4.5},
    {'week': 'W13', 'avg': 4.3},
  ];

  @override
  Widget build(BuildContext context) {
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
          // Quarter navigation header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left,
                    color: appTheme.white_A700, size: 20.h),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                'Q4 2025 (Oct - Dec)',
                style: TextStyleHelper.instance.body14SemiBoldPoppins
                    .copyWith(color: appTheme.white_A700),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right,
                    color: appTheme.white_A700, size: 20.h),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Trend description
          Text(
            'Weekly average prayer completion over 90 days',
            style: TextStyleHelper.instance.label10LightPoppins
                .copyWith(color: appTheme.white_A700.withOpacity(0.6)),
          ),
          SizedBox(height: 16.h),
          // Line chart
          SizedBox(
            height: 200.h,
            child: CustomPaint(
              painter: _NinetyDayTrendPainter(
                quarterData: quarterData,
                selectedIndex: _selectedWeekIndex,
                theme: appTheme,
              ),
              child: GestureDetector(
                onTapDown: (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localPosition =
                      box.globalToLocal(details.globalPosition);
                  final yAxisWidth = 25.0;
                  final chartWidth = box.size.width - yAxisWidth;
                  final segmentWidth = chartWidth / (quarterData.length - 1);
                  final tappedIndex =
                      ((localPosition.dx - yAxisWidth) / segmentWidth)
                          .round()
                          .clamp(0, quarterData.length - 1);

                  setState(() {
                    _selectedWeekIndex =
                        tappedIndex == _selectedWeekIndex ? null : tappedIndex;
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

class _NinetyDayTrendPainter extends CustomPainter {
  final List<Map<String, dynamic>> quarterData;
  final int? selectedIndex;
  final LightCodeColors theme;

  _NinetyDayTrendPainter({
    required this.quarterData,
    required this.selectedIndex,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const maxValue = 5.0;
    final chartHeight = size.height - 30;
    final yAxisWidth = 25.0;
    final chartStartX = yAxisWidth;
    final chartWidth = size.width - yAxisWidth;

    // Draw grid and Y-axis
    final gridPaint = Paint()
      ..color = theme.gray_700.withOpacity(0.2)
      ..strokeWidth = 1;

    for (int i = 0; i <= 5; i++) {
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

    // Draw line chart
    final linePaint = Paint()
      ..color = theme.orange_200
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < quarterData.length; i++) {
      final avg = quarterData[i]['avg'] as double;
      final x = chartStartX + (i / (quarterData.length - 1)) * chartWidth;
      final y = chartHeight - ((avg / maxValue) * chartHeight);
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw gradient fill under line
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.orange_200.withOpacity(0.3),
          theme.orange_200.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight));

    final fillPath = Path.from(path);
    fillPath.lineTo(chartStartX + chartWidth, chartHeight);
    fillPath.lineTo(chartStartX, chartHeight);
    fillPath.close();
    canvas.drawPath(fillPath, gradientPaint);

    // Draw line
    canvas.drawPath(path, linePaint);

    // Draw data points
    for (int i = 0; i < points.length; i++) {
      final isSelected = i == selectedIndex;
      final point = points[i];

      // Outer circle
      final outerCirclePaint = Paint()
        ..color = theme.gray_900
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, isSelected ? 8 : 5, outerCirclePaint);

      // Inner circle
      final innerCirclePaint = Paint()
        ..color =
            isSelected ? theme.orange_200 : theme.orange_200.withOpacity(0.8)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, isSelected ? 6 : 3, innerCirclePaint);

      // Week label (every other week to avoid crowding)
      if (i % 2 == 0 || i == quarterData.length - 1) {
        final week = quarterData[i]['week'] as String;
        final textPainter = TextPainter(
          text: TextSpan(
            text: week,
            style: TextStyle(
              color: theme.white_A700.withOpacity(0.5),
              fontSize: 9,
              fontWeight: FontWeight.w400,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            point.dx - textPainter.width / 2,
            chartHeight + 8,
          ),
        );
      }

      // Value label for selected point
      if (isSelected) {
        final avg = quarterData[i]['avg'] as double;
        final valuePainter = TextPainter(
          text: TextSpan(
            text: avg.toStringAsFixed(1),
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
            point.dx - valuePainter.width / 2,
            point.dy - 20,
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
  bool shouldRepaint(_NinetyDayTrendPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.quarterData != quarterData;
  }
}

// Statistics Cards
class _StatisticsCards extends StatelessWidget {
  const _StatisticsCards();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'This Week',
                value: '28/35',
                subtitle: '80% Complete',
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: _StatCard(
                title: 'This Month',
                value: '98/130',
                subtitle: '75% Complete',
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Best Streak',
                value: '12 Days',
                subtitle: 'All prayers',
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: _StatCard(
                title: 'Current Streak',
                value: '3 Days',
                subtitle: 'Keep going!',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(
            title,
            style: TextStyleHelper.instance.label10LightPoppins
                .copyWith(color: appTheme.white_A700.withOpacity(0.6)),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyleHelper.instance.body14SemiBoldPoppins
                .copyWith(color: appTheme.orange_200, fontSize: 18.fSize),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyleHelper.instance.label10LightPoppins
                .copyWith(color: appTheme.white_A700.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}

// Weekly Analytics Section
class _WeeklyAnalytics extends StatelessWidget {
  const _WeeklyAnalytics();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _WeeklyDetailChart(),
        SizedBox(height: 32.h),
        _SectionHeader(title: 'Statistics'),
        SizedBox(height: 16.h),
        const _StatisticsCards(),
      ],
    );
  }
}

// Monthly Analytics Section
class _MonthlyAnalytics extends StatelessWidget {
  const _MonthlyAnalytics();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MonthlyHeatmapChart(),
        SizedBox(height: 32.h),
        _SectionHeader(title: 'Statistics'),
        SizedBox(height: 16.h),
        const _StatisticsCards(),
      ],
    );
  }
}

// Quarterly Analytics Section
class _QuarterlyAnalytics extends StatelessWidget {
  const _QuarterlyAnalytics();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _NinetyDayTrendChart(),
        SizedBox(height: 32.h),
        _SectionHeader(title: 'Statistics'),
        SizedBox(height: 16.h),
        const _StatisticsCards(),
      ],
    );
  }
}
