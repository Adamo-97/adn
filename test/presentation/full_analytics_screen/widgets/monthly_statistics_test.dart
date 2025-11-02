import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/full_analytics_screen/widgets/monthly_statistics.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:intl/intl.dart';

void main() {
  // Initialize SizeUtils for responsive sizing
  setUpAll(() {
    SizeUtils.width = 375;
    SizeUtils.height = 812;
  });

  group('MonthlyStatistics Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget({int monthOffset = 0}) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: MonthlyStatistics(monthOffset: monthOffset),
          ),
        ),
      );
    }

    group('Current Month (offset = 0)', () {
      testWidgets('shows current month data correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(monthOffset: 0));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentMonth = analyticsNotifier.getMonthData(0);

        // Verify month completion is shown
        expect(
          find.text(
              '${currentMonth.totalCompleted}/${currentMonth.totalPossible}'),
          findsOneWidget,
        );
      });

      testWidgets('shows "In Progress" for incomplete current month',
          (tester) async {
        await tester.pumpWidget(createTestWidget(monthOffset: 0));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentMonth = analyticsNotifier.getMonthData(0);

        final now = DateTime.now();
        final monthEnd = DateTime(
          currentMonth.monthStart.year,
          currentMonth.monthStart.month + 1,
          0,
        );
        final isMonthComplete =
            monthEnd.isBefore(now) || monthEnd.day == now.day;

        if (!isMonthComplete) {
          expect(find.text('In Progress'), findsAtLeastNWidgets(1));
        } else {
          final percent = '${(currentMonth.completionRate * 100).round()}%';
          expect(find.textContaining(percent), findsOneWidget);
        }
      });

      testWidgets('compares with previous month correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(monthOffset: 0));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentMonth = analyticsNotifier.getMonthData(0);
        final previousMonth = analyticsNotifier.getMonthData(-1);

        final improvement =
            currentMonth.completionRate - previousMonth.completionRate;

        final now = DateTime.now();
        final monthEnd = DateTime(
          currentMonth.monthStart.year,
          currentMonth.monthStart.month + 1,
          0,
        );
        final isMonthComplete =
            monthEnd.isBefore(now) || monthEnd.day == now.day;

        if (!isMonthComplete) {
          expect(find.text('In Progress'), findsAtLeastNWidgets(2));
        } else {
          final expectedText = improvement >= 0
              ? '+${(improvement * 100).round()}%'
              : '${(improvement * 100).round()}%';
          expect(find.text(expectedText), findsOneWidget);
        }

        // Verify label shows previous month name
        final previousMonthName =
            DateFormat('MMM yyyy').format(previousMonth.monthStart);
        expect(find.text('vs $previousMonthName'), findsOneWidget);
      });

      testWidgets('calculates 3-month average correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(monthOffset: 0));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentMonth = analyticsNotifier.getMonthData(0);
        final previousMonth = analyticsNotifier.getMonthData(-1);
        final twoMonthsAgo = analyticsNotifier.getMonthData(-2);
        final threeMonthsAgo = analyticsNotifier.getMonthData(-3);

        final threeMonthAvg = (previousMonth.completionRate +
                twoMonthsAgo.completionRate +
                threeMonthsAgo.completionRate) /
            3;
        final vsThreeMonthAvg = currentMonth.completionRate - threeMonthAvg;

        final now = DateTime.now();
        final monthEnd = DateTime(
          currentMonth.monthStart.year,
          currentMonth.monthStart.month + 1,
          0,
        );
        final isMonthComplete =
            monthEnd.isBefore(now) || monthEnd.day == now.day;

        if (!isMonthComplete) {
          expect(find.text('In Progress'), findsAtLeastNWidgets(2));
        } else {
          final expectedText = vsThreeMonthAvg >= 0
              ? '+${(vsThreeMonthAvg * 100).round()}%'
              : '${(vsThreeMonthAvg * 100).round()}%';
          expect(find.text(expectedText), findsOneWidget);
        }
      });
    });

    group('Previous Month (offset = -1)', () {
      testWidgets('shows previous month data correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(monthOffset: -1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final previousMonth = analyticsNotifier.getMonthData(-1);
        // Verify month completion is shown
        expect(
          find.text(
              '${previousMonth.totalCompleted}/${previousMonth.totalPossible}'),
          findsOneWidget,
        );

        // Previous month should always be complete
        final now = DateTime.now();
        final monthEnd = DateTime(
          previousMonth.monthStart.year,
          previousMonth.monthStart.month + 1,
          0,
        );
        final isMonthComplete = monthEnd.isBefore(now);

        expect(isMonthComplete, true,
            reason: 'Previous month should always be complete');

        // Should show actual percentage, not "In Progress"
        final percent =
            '${(previousMonth.completionRate * 100).round()}% Complete';
        expect(find.text(percent), findsOneWidget);
      });

      testWidgets(
          'CRITICAL: Compares previous month (-1) with two months ago (-2), NOT current (0) with previous (-1)',
          (tester) async {
        await tester.pumpWidget(createTestWidget(monthOffset: -1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final previousMonth = analyticsNotifier.getMonthData(-1);
        final twoMonthsAgo = analyticsNotifier.getMonthData(-2);

        // CRITICAL BUG: The code should compare:
        // previousMonth (-1) to twoMonthsAgo (-2)
        // But it might be comparing currentMonth (0) to previousMonth (-1)
        final correctImprovement =
            previousMonth.completionRate - twoMonthsAgo.completionRate;

        final expectedText = correctImprovement >= 0
            ? '+${(correctImprovement * 100).round()}%'
            : '${(correctImprovement * 100).round()}%';

        // This test will reveal the bug
        final comparisonText = find.text(expectedText);

        if (comparisonText.evaluate().isEmpty) {

          // Try to find what text IS being shown
          await tester.pumpAndSettle();
        }

        expect(comparisonText, findsOneWidget,
            reason:
                'When viewing previous month (offset -1), must compare it to two months ago (offset -2)');
      });

      testWidgets('label shows two months ago, not previous month',
          (tester) async {
        await tester.pumpWidget(createTestWidget(monthOffset: -1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final twoMonthsAgo = analyticsNotifier.getMonthData(-2);

        final twoMonthsAgoName =
            DateFormat('MMM yyyy').format(twoMonthsAgo.monthStart);

        expect(find.text('vs $twoMonthsAgoName'), findsOneWidget,
            reason:
                'Label should reference two months ago, not previous month');
      });

      testWidgets('3-month average uses correct months (offsets -2, -3, -4)',
          (tester) async {
        await tester.pumpWidget(createTestWidget(monthOffset: -1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final previousMonth = analyticsNotifier.getMonthData(-1);
        final twoMonthsAgo = analyticsNotifier.getMonthData(-2);
        final threeMonthsAgo = analyticsNotifier.getMonthData(-3);
        final fourMonthsAgo = analyticsNotifier.getMonthData(-4);

        // When viewing offset -1, 3-month average should use offsets -2, -3, -4
        final correctThreeMonthAvg = (twoMonthsAgo.completionRate +
                threeMonthsAgo.completionRate +
                fourMonthsAgo.completionRate) /
            3;
        final correctVsAvg =
            previousMonth.completionRate - correctThreeMonthAvg;

        final expectedText = correctVsAvg >= 0
            ? '+${(correctVsAvg * 100).round()}%'
            : '${(correctVsAvg * 100).round()}%';

        expect(find.text(expectedText), findsOneWidget,
            reason:
                '3-month average should use months at offsets -2, -3, -4 when viewing offset -1');
      });
    });

    group('Two Months Ago (offset = -2)', () {
      testWidgets('compares with three months ago correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(monthOffset: -2));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final twoMonthsAgo = analyticsNotifier.getMonthData(-2);
        final threeMonthsAgo = analyticsNotifier.getMonthData(-3);

        final improvement =
            twoMonthsAgo.completionRate - threeMonthsAgo.completionRate;
        final expectedText = improvement >= 0
            ? '+${(improvement * 100).round()}%'
            : '${(improvement * 100).round()}%';

        expect(find.text(expectedText), findsOneWidget);
      });
    });

    group('Active Days Calculation', () {
      testWidgets('counts days with at least 1 prayer', (tester) async {
        await tester.pumpWidget(createTestWidget(monthOffset: 0));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentMonth = analyticsNotifier.getMonthData(0);

        final activeDays = currentMonth.activeDays;
        final totalDays = currentMonth.dailyData.length;

        expect(find.text('$activeDays/$totalDays'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles month with very low completion', (tester) async {
        await tester.pumpWidget(createTestWidget(monthOffset: -10));
        expect(find.byType(MonthlyStatistics), findsOneWidget);
      });

      testWidgets('handles far past month offset', (tester) async {
        await tester.pumpWidget(createTestWidget(monthOffset: -50));
        expect(find.byType(MonthlyStatistics), findsOneWidget);
      });
    });

    group('Month End Date Calculation', () {
      testWidgets('correctly calculates last day of month', (tester) async {
        await tester.pumpWidget(createTestWidget(monthOffset: 0));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentMonth = analyticsNotifier.getMonthData(0);

        final monthEnd = DateTime(
          currentMonth.monthStart.year,
          currentMonth.monthStart.month + 1,
          0,
        );

        // Verify month end calculation is correct
        expect(monthEnd.day, currentMonth.dailyData.length,
            reason: 'Month end day should equal number of days in month');
      });
    });
  });
}


