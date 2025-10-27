import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'widgets/weekly_analytics.dart';
import 'widgets/monthly_analytics.dart';
import 'widgets/quarterly_analytics.dart';
import 'widgets/section_header.dart';
import 'widgets/weekly_detail_chart.dart';
import 'widgets/monthly_heatmap_chart.dart';
import 'widgets/ninety_day_trend_chart.dart';
import 'widgets/statistics_cards.dart';

class FullAnalyticsScreen extends ConsumerStatefulWidget {
  final String? analyticsType;

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
                if (widget.analyticsType == 'weekly') ...[
                  const WeeklyAnalytics(),
                ] else if (widget.analyticsType == 'monthly') ...[
                  const MonthlyAnalytics(),
                ] else if (widget.analyticsType == 'quarterly') ...[
                  const QuarterlyAnalytics(),
                ] else ...[
                  const SectionHeader(title: 'Weekly Overview'),
                  SizedBox(height: 16.h),
                  const WeeklyDetailChart(),
                  SizedBox(height: 32.h),
                  const SectionHeader(title: 'Monthly Heatmap'),
                  SizedBox(height: 16.h),
                  const MonthlyHeatmapChart(),
                  SizedBox(height: 32.h),
                  const SectionHeader(title: '90-Day Trend'),
                  SizedBox(height: 16.h),
                  const NinetyDayTrendChart(),
                  SizedBox(height: 32.h),
                  const SectionHeader(title: 'Statistics'),
                  SizedBox(height: 16.h),
                  const StatisticsCards(),
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
