import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/full_analytics_screen/full_analytics_screen.dart';

class QuarterlyStatsPanel extends StatelessWidget {
  final bool isOpen;
  const QuarterlyStatsPanel({super.key, required this.isOpen});

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
          ? const SizedBox.shrink(key: ValueKey('quarterly-off'))
          : Column(
              key: const ValueKey('quarterly-on'),
              children: const [
                _QuarterlySpacingTop(),
                _QuarterlyChart(),
                _QuarterlySpacingBetween(),
                _FullAnalyticsButton(),
              ],
            ),
    );
  }
}

class _QuarterlySpacingTop extends StatelessWidget {
  const _QuarterlySpacingTop();
  @override
  Widget build(BuildContext context) => SizedBox(height: 28.h);
}

class _QuarterlySpacingBetween extends StatelessWidget {
  const _QuarterlySpacingBetween();
  @override
  Widget build(BuildContext context) => SizedBox(height: 16.h);
}

class _QuarterlyChart extends ConsumerStatefulWidget {
  const _QuarterlyChart();

  @override
  ConsumerState<_QuarterlyChart> createState() => _QuarterlyChartState();
}

class _QuarterlyChartState extends ConsumerState<_QuarterlyChart> {
  int _quarterOffset = 0; // 0 = current quarter, -1 = previous quarter, etc.
  int? _selectedMonthIndex;

  List<Map<String, dynamic>> _getQuarterData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Calculate current quarter (Q1: Jan-Mar, Q2: Apr-Jun, Q3: Jul-Sep, Q4: Oct-Dec)
    final currentQuarter = ((now.month - 1) ~/ 3) + 1;
    final targetQuarter = currentQuarter + _quarterOffset;

    // Calculate year and adjusted quarter
    final yearOffset = (targetQuarter - 1) < 0
        ? ((targetQuarter - 1) ~/ 4) - 1
        : (targetQuarter - 1) ~/ 4;
    final adjustedQuarter = ((targetQuarter - 1) % 4) + 1;
    final targetYear = now.year + yearOffset;

    // Get months in quarter
    final firstMonthOfQuarter = (adjustedQuarter - 1) * 3 + 1;
    final monthsData = <Map<String, dynamic>>[];

    for (int i = 0; i < 3; i++) {
      final month = firstMonthOfQuarter + i;
      final monthDate = DateTime(targetYear, month, 1);
      final isFuture = monthDate.isAfter(DateTime(today.year, today.month, 1));

      // Mock data: Calculate completed prayers for this month
      int totalCompleted = 0;
      if (!isFuture) {
        final lastDayOfMonth = DateTime(targetYear, month + 1, 0).day;
        final daysToCount =
            monthDate.month == today.month ? today.day : lastDayOfMonth;

        for (int day = 1; day <= daysToCount; day++) {
          totalCompleted += (3 + (day % 3)); // Mock: 3-5 prayers per day
        }
      }

      monthsData.add({
        'month': month,
        'monthName': [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ][month - 1],
        'totalCompleted': totalCompleted,
        'isFuture': isFuture,
        'quarterName': 'Q$adjustedQuarter $targetYear',
      });
    }

    return monthsData;
  }

  bool _canGoNext() {
    return _quarterOffset < 0;
  }

  bool _canGoPrev() {
    return true; // Can always go to previous quarters
  }

  void _nextQuarter() {
    if (_canGoNext()) {
      setState(() {
        _quarterOffset++;
        _selectedMonthIndex = null;
      });
    }
  }

  void _prevQuarter() {
    if (_canGoPrev()) {
      setState(() {
        _quarterOffset--;
        _selectedMonthIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quarterData = _getQuarterData();

    // Get first and last day of the quarter for date range
    final now = DateTime.now();
    final currentQuarter = ((now.month - 1) ~/ 3) + 1;
    final targetQuarter = currentQuarter + _quarterOffset;
    final yearOffset = (targetQuarter - 1) < 0
        ? ((targetQuarter - 1) ~/ 4) - 1
        : (targetQuarter - 1) ~/ 4;
    final adjustedQuarter = ((targetQuarter - 1) % 4) + 1;
    final targetYear = now.year + yearOffset;

    final firstMonthOfQuarter = (adjustedQuarter - 1) * 3 + 1;
    final lastMonthOfQuarter = firstMonthOfQuarter + 2;
    final firstDay = DateTime(targetYear, firstMonthOfQuarter, 1);
    final lastDay = DateTime(targetYear, lastMonthOfQuarter + 1, 0);
    final dateRange =
        '${firstDay.day}/${firstDay.month} - ${lastDay.day}/${lastDay.month}';

    return Container(
      height: 202.h, // Same height as Qibla compass
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          // Quarter navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _prevQuarter,
                child: Icon(
                  Icons.chevron_left,
                  color: appTheme.gray_700,
                  size: 24.h,
                ),
              ),
              Text(
                dateRange,
                style: TextStyleHelper.instance.body12SemiBoldPoppins
                    .copyWith(color: appTheme.white_A700),
              ),
              GestureDetector(
                onTap: _canGoNext() ? _nextQuarter : null,
                child: Icon(
                  Icons.chevron_right,
                  color: _canGoNext()
                      ? appTheme.gray_700
                      : appTheme.gray_700.withOpacity(0.3),
                  size: 24.h,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Bar chart (3 months)
          Expanded(
            child: CustomPaint(
              painter: _QuarterlyBarChartPainter(
                monthsData: quarterData,
                selectedIndex: _selectedMonthIndex,
                theme: appTheme,
              ),
              child: GestureDetector(
                onTapDown: (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localPosition =
                      box.globalToLocal(details.globalPosition);
                  final chartWidth = box.size.width;
                  final barWidth = chartWidth / 3;
                  final tappedIndex =
                      (localPosition.dx / barWidth).floor().clamp(0, 2);

                  setState(() {
                    _selectedMonthIndex =
                        tappedIndex == _selectedMonthIndex ? null : tappedIndex;
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

class _QuarterlyBarChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> monthsData;
  final int? selectedIndex;
  final LightCodeColors theme;

  _QuarterlyBarChartPainter({
    required this.monthsData,
    required this.selectedIndex,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (monthsData.isEmpty) return;

    final maxValue = monthsData
        .map((m) => m['totalCompleted'] as int)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final adjustedMax =
        (maxValue * 1.2).clamp(100.0, 500.0); // Scale for better visualization

    final chartHeight = size.height - 30; // Leave space for labels
    final yAxisWidth =
        35.0; // Space for Y-axis labels (larger for bigger numbers)
    final chartStartX = yAxisWidth;
    final chartWidth = size.width - yAxisWidth;
    final adjustedBarWidth = chartWidth / 3;

    // Draw horizontal grid lines (dotted) and Y-axis values
    final gridPaint = Paint()
      ..color = theme.gray_700.withOpacity(0.2)
      ..strokeWidth = 1;

    for (int i = 0; i <= 5; i++) {
      final y = chartHeight - (i / 5 * chartHeight);
      _drawDottedLine(
          canvas, Offset(chartStartX, y), Offset(size.width, y), gridPaint);

      // Draw Y-axis value
      final value = (i / 5 * adjustedMax).round();
      final yValuePainter = TextPainter(
        text: TextSpan(
          text: '$value',
          style: TextStyle(
            color: theme.white_A700.withOpacity(0.4),
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
    for (int i = 0; i < monthsData.length; i++) {
      final data = monthsData[i];
      final completed = data['totalCompleted'] as int;
      final isFuture = data['isFuture'] as bool;
      final isSelected = i == selectedIndex;

      if (isFuture) continue; // Don't show future months

      final barHeight = (completed / adjustedMax) * chartHeight;
      final x = chartStartX + i * adjustedBarWidth + adjustedBarWidth * 0.2;
      final width = adjustedBarWidth * 0.6;

      // Bar color with gradient
      Color barColor = isSelected ? theme.orange_200 : theme.gray_700;

      // Draw bar with gradient effect
      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, chartHeight - barHeight, width, barHeight),
        Radius.circular(6),
      );

      final gradient = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          barColor,
          barColor.withOpacity(0.6),
        ],
      );

      canvas.drawRRect(
        barRect,
        Paint()..shader = gradient.createShader(barRect.outerRect),
      );

      // Draw month label
      final monthName = data['monthName'] as String;
      final textPainter = TextPainter(
        text: TextSpan(
          text: monthName,
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
  bool shouldRepaint(_QuarterlyBarChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.monthsData != monthsData;
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
            builder: (context) =>
                FullAnalyticsScreen(analyticsType: 'quarterly'),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
        decoration: BoxDecoration(
          color: appTheme.gray_700.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8.h),
          border: Border.all(
            color: appTheme.gray_700.withOpacity(0.5),
            width: 1.h,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Full Analytics',
              style: TextStyleHelper.instance.label10LightPoppins
                  .copyWith(color: appTheme.white_A700),
            ),
            SizedBox(width: 6.h),
            Icon(
              Icons.arrow_forward,
              color: appTheme.white_A700,
              size: 12.h,
            ),
          ],
        ),
      ),
    );
  }
}
