import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/full_analytics_screen/widgets/weekly_statistics.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';
import 'package:adam_s_application/core/app_export.dart';

void main() {
  // Initialize SizeUtils for responsive sizing
  setUpAll(() {
    SizeUtils.width = 375;
    SizeUtils.height = 812;
  });

  group('WeeklyStatistics Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget({int weekOffset = 0}) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: WeeklyStatistics(weekOffset: weekOffset),
          ),
        ),
      );
    }

    group('Current Week (offset = 0)', () {
      testWidgets('shows current week data correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(weekOffset: 0));
        await tester.pump(
            const Duration(milliseconds: 600)); // Wait for 500ms timer + buffer
        await tester.pumpAndSettle();

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentWeek = analyticsNotifier.getWeekData(0);

        // Verify week completion is shown
        expect(
          find.text(
              '${currentWeek.totalCompleted}/${currentWeek.totalPossible}'),
          findsOneWidget,
        );
      });

      testWidgets('shows "In Progress" for incomplete current week',
          (tester) async {
        await tester.pumpWidget(createTestWidget(weekOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentWeek = analyticsNotifier.getWeekData(0);

        final now = DateTime.now();
        final weekEnd = currentWeek.weekEnd;
        final isWeekComplete = weekEnd.isBefore(now) ||
            (weekEnd.year == now.year &&
                weekEnd.month == now.month &&
                weekEnd.day == now.day);

        if (!isWeekComplete) {
          // Should show "In Progress" for completion percentage
          expect(find.text('In Progress'), findsAtLeastNWidgets(1));
        } else {
          // Should show actual percentage
          final percent = '${(currentWeek.completionRate * 100).round()}%';
          expect(find.textContaining(percent), findsOneWidget);
        }
      });

      testWidgets('compares with previous week correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(weekOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentWeek = analyticsNotifier.getWeekData(0);
        final previousWeek = analyticsNotifier.getWeekData(-1);

        final improvement =
            currentWeek.completionRate - previousWeek.completionRate;

        final now = DateTime.now();
        final weekEnd = currentWeek.weekEnd;
        final isWeekComplete = weekEnd.isBefore(now) ||
            (weekEnd.year == now.year &&
                weekEnd.month == now.month &&
                weekEnd.day == now.day);

        if (!isWeekComplete) {
          expect(find.text('In Progress'), findsAtLeastNWidgets(2));
        } else {
          final expectedText = improvement >= 0
              ? '+${(improvement * 100).round()}%'
              : '${(improvement * 100).round()}%';
          expect(find.text(expectedText), findsOneWidget);
        }
      });
    });

    group('Previous Week (offset = -1)', () {
      testWidgets('shows previous week data correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(weekOffset: -1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final previousWeek = analyticsNotifier.getWeekData(-1);

        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(
          find.text(
              '${previousWeek.totalCompleted}/${previousWeek.totalPossible}'),
          findsOneWidget,
        );

        // Previous week should always be complete
        final now = DateTime.now();
        final weekEnd = previousWeek.weekEnd;
        final isWeekComplete = weekEnd.isBefore(now);

        expect(isWeekComplete, true,
            reason: 'Previous week should always be complete');

        // Should show actual percentage, not "In Progress"
        final percent =
            '${(previousWeek.completionRate * 100).round()}% Complete';
        expect(find.text(percent), findsOneWidget);
      });

      testWidgets(
          'compares previous week with two weeks ago (NOT current with previous)',
          (tester) async {
        await tester.pumpWidget(createTestWidget(weekOffset: -1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final previousWeek = analyticsNotifier.getWeekData(-1);
        final twoWeeksAgo = analyticsNotifier.getWeekData(-2);

        // CRITICAL: When viewing previous week (offset = -1),
        // it should compare previousWeek (-1) to twoWeeksAgo (-2)
        // NOT currentWeek (0) to previousWeek (-1)
        final improvement =
            previousWeek.completionRate - twoWeeksAgo.completionRate;

        final expectedText = improvement >= 0
            ? '+${(improvement * 100).round()}%'
            : '${(improvement * 100).round()}%';

        // This test will FAIL if the code compares currentWeek to previousWeek
        // instead of previousWeek to twoWeeksAgo
        expect(find.text(expectedText), findsOneWidget,
            reason:
                'When viewing previous week, should compare it to two weeks ago');
      });
    });

    group('Two Weeks Ago (offset = -2)', () {
      testWidgets('compares with three weeks ago correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(weekOffset: -2));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final twoWeeksAgo = analyticsNotifier.getWeekData(-2);
        final threeWeeksAgo = analyticsNotifier.getWeekData(-3);

        final improvement =
            twoWeeksAgo.completionRate - threeWeeksAgo.completionRate;

        final expectedText = improvement >= 0
            ? '+${(improvement * 100).round()}%'
            : '${(improvement * 100).round()}%';

        expect(find.text(expectedText), findsOneWidget);
      });
    });

    group('Best Day Calculation', () {
      testWidgets('shows correct best day', (tester) async {
        await tester.pumpWidget(createTestWidget(weekOffset: 0));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentWeek = analyticsNotifier.getWeekData(0);

        var bestDay = currentWeek.dailyData.first;
        for (final day in currentWeek.dailyData) {
          if (day.completedPrayers > bestDay.completedPrayers) {
            bestDay = day;
          }
        }

        // Should find the best day text
        expect(
            find.textContaining('${bestDay.completedPrayers}/5'), findsWidgets);
      });
    });

    group('Streak Calculation', () {
      testWidgets('calculates consecutive perfect days from end',
          (tester) async {
        await tester.pumpWidget(createTestWidget(weekOffset: 0));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentWeek = analyticsNotifier.getWeekData(0);

        int streak = 0;
        for (int i = currentWeek.dailyData.length - 1; i >= 0; i--) {
          if (currentWeek.dailyData[i].completedPrayers == 5 &&
              !currentWeek.dailyData[i].isFuture) {
            streak++;
          } else if (!currentWeek.dailyData[i].isFuture) {
            break;
          }
        }

        if (streak > 0) {
          expect(find.text('$streak ${streak == 1 ? 'Day' : 'Days'}'),
              findsOneWidget);
        } else {
          expect(find.text('None'), findsOneWidget);
        }
      });
    });

    group('Edge Cases', () {
      testWidgets('handles week with no completed prayers', (tester) async {
        // This would need mock data, but we can verify the widget doesn't crash
        await tester.pumpWidget(createTestWidget(weekOffset: -10));
        expect(find.byType(WeeklyStatistics), findsOneWidget);
      });

      testWidgets('handles far future week offset', (tester) async {
        // Can't go to future, but test doesn't crash
        await tester.pumpWidget(createTestWidget(weekOffset: 1));
        expect(find.byType(WeeklyStatistics), findsOneWidget);
      });
    });
  });
}
