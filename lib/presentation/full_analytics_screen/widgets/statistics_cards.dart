import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';

class StatisticsCards extends StatelessWidget {
  const StatisticsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'This Week',
                value: '28/35',
                subtitle: '80% Complete',
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
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
              child: StatCard(
                title: 'Best Streak',
                value: '12 Days',
                subtitle: 'All prayers',
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: StatCard(
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

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(
            title,
            style: TextStyleHelper.instance.label10LightPoppins.copyWith(
                color: appTheme.whiteA700.withAlpha((0.6 * 255).round())),
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
            style: TextStyleHelper.instance.label10LightPoppins.copyWith(
                color: appTheme.whiteA700.withAlpha((0.4 * 255).round())),
          ),
        ],
      ),
    );
  }
}
