import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';

class NinetyDayTrendChart extends ConsumerStatefulWidget {
  final bool showNavigation;

  const NinetyDayTrendChart({super.key, this.showNavigation = true});

  @override
  ConsumerState<NinetyDayTrendChart> createState() =>
      _NinetyDayTrendChartState();
}

class _NinetyDayTrendChartState extends ConsumerState<NinetyDayTrendChart> {
  int? _selectedWeekIndex;
  int _quarterOffset = 0; // 0 = current quarter, -1 = previous quarter, etc.

  List<Map<String, dynamic>> _getQuarterData() {
    // Get data from analytics provider
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final quarterStats = analyticsNotifier.getQuarterData(_quarterOffset);

    // Convert weekly data to format expected by the chart
    return quarterStats.weeklyData.asMap().entries.map((entry) {
      final weekIndex = entry.key + 1;
      final weekStats = entry.value;
      final avgPrayers = weekStats.totalCompleted / weekStats.dailyData.length;

      return {
        'week': 'W$weekIndex',
        'avg': avgPrayers,
      };
    }).toList();
  }

  String _getQuarterLabel() {
    // Get data from analytics provider
    final analyticsNotifier = ref.read(prayerAnalyticsProvider.notifier);
    final quarterStats = analyticsNotifier.getQuarterData(_quarterOffset);
    return quarterStats.quarterLabel;
  }

  bool _canGoNext() => _quarterOffset < 0;
  bool _canGoPrev() => true;

  void _nextQuarter() {
    if (_canGoNext()) {
      setState(() {
        _quarterOffset++;
        _selectedWeekIndex = null;
      });
    }
  }

  void _prevQuarter() {
    if (_canGoPrev()) {
      setState(() {
        _quarterOffset--;
        _selectedWeekIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quarterData = _getQuarterData();

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.gray_700.withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appTheme.gray_700.withAlpha((0.3 * 255).round()),
          width: 1.h,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quarter navigation header (conditional)
          if (widget.showNavigation)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left,
                      color:
                          _canGoPrev() ? appTheme.whiteA700 : appTheme.gray_700,
                      size: 20.h),
                  onPressed: _canGoPrev() ? _prevQuarter : null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Text(
                  _getQuarterLabel(),
                  style: TextStyleHelper.instance.body14SemiBoldPoppins
                      .copyWith(color: appTheme.whiteA700),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right,
                      color:
                          _canGoNext() ? appTheme.whiteA700 : appTheme.gray_700,
                      size: 20.h),
                  onPressed: _canGoNext() ? _nextQuarter : null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            )
          else
            // Just show the quarter label without navigation
            Center(
              child: Text(
                _getQuarterLabel(),
                style: TextStyleHelper.instance.body14SemiBoldPoppins
                    .copyWith(color: appTheme.whiteA700),
              ),
            ),
          SizedBox(height: 16.h),
          // Trend description
          Text(
            'Weekly average prayer completion over 90 days',
            style: TextStyleHelper.instance.label10LightPoppins.copyWith(
                color: appTheme.whiteA700.withAlpha((0.6 * 255).round())),
          ),
          SizedBox(height: 16.h),
          // Line chart
          SizedBox(
            height: 200.h,
            child: CustomPaint(
              painter: NinetyDayTrendPainter(
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

class NinetyDayTrendPainter extends CustomPainter {
  final List<Map<String, dynamic>> quarterData;
  final int? selectedIndex;
  final LightCodeColors theme;

  NinetyDayTrendPainter({
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
      ..color = theme.gray_700.withAlpha((0.2 * 255).round())
      ..strokeWidth = 1;

    for (int i = 0; i <= 5; i++) {
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
          theme.orange_200.withAlpha((0.3 * 255).round()),
          theme.orange_200.withAlpha((0.0 * 255).round()),
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
        ..color = isSelected
            ? theme.orange_200
            : theme.orange_200.withAlpha((0.8 * 255).round())
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, isSelected ? 6 : 3, innerCirclePaint);

      // Week label (every other week to avoid crowding)
      if (i % 2 == 0 || i == quarterData.length - 1) {
        final week = quarterData[i]['week'] as String;
        final textPainter = TextPainter(
          text: TextSpan(
            text: week,
            style: TextStyle(
              color: theme.whiteA700.withAlpha((0.5 * 255).round()),
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
  bool shouldRepaint(NinetyDayTrendPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.quarterData != quarterData;
  }
}
