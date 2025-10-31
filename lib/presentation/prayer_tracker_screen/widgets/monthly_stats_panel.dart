import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/full_analytics_screen/full_analytics_screen.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';

class MonthlyStatsPanel extends StatelessWidget {
  final bool isOpen;
  const MonthlyStatsPanel({super.key, required this.isOpen});

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
          ? const SizedBox.shrink(key: ValueKey('monthly-off'))
          : Column(
              key: const ValueKey('monthly-on'),
              children: const [
                _MonthlySpacingTop(),
                _MonthlyChart(),
                _MonthlySpacingBetween(),
                _FullAnalyticsButton(),
              ],
            ),
    );
  }
}

class _MonthlySpacingTop extends StatelessWidget {
  const _MonthlySpacingTop();
  @override
  Widget build(BuildContext context) => SizedBox(height: 28.h);
}

class _MonthlySpacingBetween extends StatelessWidget {
  const _MonthlySpacingBetween();
  @override
  Widget build(BuildContext context) => SizedBox(height: 16.h);
}

class _MonthlyChart extends ConsumerStatefulWidget {
  const _MonthlyChart();

  @override
  ConsumerState<_MonthlyChart> createState() => _MonthlyChartState();
}

class _MonthlyChartState extends ConsumerState<_MonthlyChart> {
  int _monthOffset = 0; // 0 = current month, -1 = previous month, etc.
  int? _selectedWeekIndex;

  List<Map<String, dynamic>> _getMonthData() {
    // Get data from analytics provider
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final monthStats = analyticsNotifier.getMonthData(_monthOffset);

    // Convert weekly data to format expected by the chart
    return monthStats.weeklyData.asMap().entries.map((entry) {
      final weekIndex = entry.key;
      final weekStats = entry.value;

      return {
        'weekStart': weekStats.weekStart,
        'weekEnd': weekStats.weekEnd,
        'weekIndex': weekIndex,
        'totalCompleted': weekStats.totalCompleted,
        'isFuture': weekStats.dailyData.every((day) => day.isFuture),
      };
    }).toList();
  }

  bool _canGoNext() {
    return _monthOffset < 0;
  }

  bool _canGoPrev() {
    return true; // Can always go to previous months
  }

  void _nextMonth() {
    if (_canGoNext()) {
      setState(() {
        _monthOffset++;
        _selectedWeekIndex = null;
      });
    }
  }

  void _prevMonth() {
    if (_canGoPrev()) {
      setState(() {
        _monthOffset--;
        _selectedWeekIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthData = _getMonthData();

    // Get month stats for date range
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final monthStats = analyticsNotifier.getMonthData(_monthOffset);
    final dateRange =
        '${monthStats.monthStart.day}/${monthStats.monthStart.month} - ${monthStats.monthEnd.day}/${monthStats.monthEnd.month}';

    return Container(
      height: 202.h, // Same height as Qibla compass
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _prevMonth,
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
                onTap: _canGoNext() ? _nextMonth : null,
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

          // Bar chart (weeks)
          Expanded(
            child: CustomPaint(
              painter: _MonthlyBarChartPainter(
                weeksData: monthData,
                selectedIndex: _selectedWeekIndex,
                theme: appColors,
              ),
              child: GestureDetector(
                onTapDown: (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localPosition =
                      box.globalToLocal(details.globalPosition);
                  final chartWidth = box.size.width;
                  final yAxisWidth = 30.0;
                  final adjustedWidth = chartWidth - yAxisWidth;
                  final barWidth = adjustedWidth / monthData.length;
                  final tappedIndex =
                      ((localPosition.dx - yAxisWidth) / barWidth)
                          .floor()
                          .clamp(0, monthData.length - 1);

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

class _MonthlyBarChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> weeksData;
  final int? selectedIndex;
  final DarkCodeColors theme;

  _MonthlyBarChartPainter({
    required this.weeksData,
    required this.selectedIndex,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (weeksData.isEmpty) return;

    final maxValue = weeksData
        .map((w) => w['totalCompleted'] as int)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final adjustedMax =
        (maxValue * 1.2).clamp(30.0, 150.0); // Scale for better visualization

    final chartHeight = size.height - 30; // Leave space for labels
    final yAxisWidth = 30.0; // Space for Y-axis labels
    final chartStartX = yAxisWidth;
    final chartWidth = size.width - yAxisWidth;
    final adjustedBarWidth = chartWidth / weeksData.length;

    // Draw horizontal grid lines (dotted) and Y-axis values
    final gridPaint = Paint()
      ..color = theme.gray_700.withAlpha((0.2 * 255).round())
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
    for (int i = 0; i < weeksData.length; i++) {
      final data = weeksData[i];
      final completed = data['totalCompleted'] as int;
      final isFuture = data['isFuture'] as bool;
      final isSelected = i == selectedIndex;

      if (isFuture) continue; // Don't show future weeks

      final barHeight = (completed / adjustedMax) * chartHeight;
      final x = chartStartX + i * adjustedBarWidth + adjustedBarWidth * 0.25;
      final width = adjustedBarWidth * 0.5;

      // Bar color
      Color barColor = isSelected ? theme.orange_200 : theme.gray_700;

      // Draw bar with gradient effect
      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, chartHeight - barHeight, width, barHeight),
        Radius.circular(4),
      );

      final gradient = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          barColor,
          barColor.withAlpha((0.7 * 255).round()),
        ],
      );

      canvas.drawRRect(
        barRect,
        Paint()..shader = gradient.createShader(barRect.outerRect),
      );

      // Draw week label (W1, W2, etc.)
      final weekLabel = 'W${i + 1}';
      final textPainter = TextPainter(
        text: TextSpan(
          text: weekLabel,
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
  bool shouldRepaint(_MonthlyBarChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.weeksData != weeksData;
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
            builder: (context) => FullAnalyticsScreen(analyticsType: 'monthly'),
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
