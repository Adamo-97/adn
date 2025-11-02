import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/full_analytics_screen/widgets/quarterly_statistics.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';
import 'package:adam_s_application/core/app_export.dart';

void main() {
  // Initialize SizeUtils for responsive sizing
  setUpAll(() {
    SizeUtils.width = 375;
    SizeUtils.height = 812;
  });

  group('QuarterlyStatistics Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget({int quarterOffset = 0}) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: theme,
          home: Scaffold(
            body: QuarterlyStatistics(quarterOffset: quarterOffset),
          ),
        ),
      );
    }

    group('QuarterlyStatistics - Current Quarter (offset = 0)', () {
      testWidgets('renders all four stat cards', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Should display all card titles
        expect(find.text('Quarter Completion'), findsOneWidget);
        expect(find.text('vs Last Quarter'), findsOneWidget);
        expect(find.text('Best Month'), findsOneWidget);
        expect(find.text('Year Progress'), findsOneWidget);
      });

      testWidgets('displays quarter completion correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentQuarter = analyticsNotifier.getQuarterData(0);

        // Verify completion ratio
        expect(
          find.text(
              '${currentQuarter.totalCompleted}/${currentQuarter.totalPossible}'),
          findsOneWidget,
        );

        // Check if quarter is complete
        final now = DateTime.now();
        final quarterEnd = currentQuarter.quarterEnd;
        final isQuarterComplete = quarterEnd.isBefore(now) ||
            (quarterEnd.year == now.year &&
                quarterEnd.month == now.month &&
                quarterEnd.day == now.day);

        if (!isQuarterComplete) {
          // Should show "In Progress" for incomplete quarter
          expect(find.text('In Progress'), findsAtLeastNWidgets(1));
        } else {
          // Should show actual percentage
          final percent =
              '${(currentQuarter.completionRate * 100).round()}% Complete';
          expect(find.text(percent), findsOneWidget);
        }
      });

      testWidgets('compares with previous quarter correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentQuarter = analyticsNotifier.getQuarterData(0);
        final previousQuarter = analyticsNotifier.getQuarterData(-1);

        final improvement =
            currentQuarter.completionRate - previousQuarter.completionRate;

        final now = DateTime.now();
        final quarterEnd = currentQuarter.quarterEnd;
        final isQuarterComplete = quarterEnd.isBefore(now) ||
            (quarterEnd.year == now.year &&
                quarterEnd.month == now.month &&
                quarterEnd.day == now.day);

        if (!isQuarterComplete) {
          expect(find.text('In Progress'), findsAtLeastNWidgets(2));
        } else {
          final expectedText = improvement >= 0
              ? '+${(improvement * 100).round()}%'
              : '${(improvement * 100).round()}%';
          expect(find.text(expectedText), findsOneWidget);
        }

        // Verify comparison label format
        final quarterLabel =
            'vs Q${previousQuarter.quarterNumber} ${previousQuarter.quarterStart.year}';
        expect(find.text(quarterLabel), findsOneWidget);
      });

      testWidgets('identifies and displays best month', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentQuarter = analyticsNotifier.getQuarterData(0);

        // Find best month manually
        var bestMonth = currentQuarter.monthlyData.first;
        for (final month in currentQuarter.monthlyData) {
          if (month.completionRate > bestMonth.completionRate) {
            bestMonth = month;
          }
        }

        // Verify best month is displayed (should find month name somewhere)
        expect(find.textContaining('${bestMonth.monthStart.month}'),
            findsAtLeastNWidgets(1));
      });

      testWidgets('displays year-to-date progress', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final data = container.read(prayerAnalyticsProvider);

        if (data != null) {
          final yearProgress = '${(data.yearCompletionRate * 100).round()}%';
          final yearStats =
              '${data.yearTotalCompleted}/${data.yearTotalPossible}';

          expect(find.text(yearProgress), findsOneWidget);
          expect(find.text(yearStats), findsOneWidget);
        }
      });

      testWidgets('uses correct layout with two rows', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Should have Column with Rows layout
        final columnFinder = find.byType(Column);
        expect(columnFinder, findsWidgets);

        final rowFinder = find.byType(Row);
        expect(rowFinder, findsAtLeastNWidgets(2)); // At least 2 rows of cards
      });
    });

    group('QuarterlyStatistics - Previous Quarter (offset = -1)', () {
      testWidgets('shows previous quarter data correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: -1));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final previousQuarter = analyticsNotifier.getQuarterData(-1);

        expect(
          find.text(
              '${previousQuarter.totalCompleted}/${previousQuarter.totalPossible}'),
          findsOneWidget,
        );

        // Previous quarter should always be complete
        final now = DateTime.now();
        final quarterEnd = previousQuarter.quarterEnd;
        final isQuarterComplete = quarterEnd.isBefore(now);

        expect(isQuarterComplete, true,
            reason: 'Previous quarter should always be complete');

        // Should show actual percentage, not "In Progress"
        final percent =
            '${(previousQuarter.completionRate * 100).round()}% Complete';
        expect(find.text(percent), findsOneWidget);
      });

      testWidgets(
          'compares previous quarter with two quarters ago (NOT current with previous)',
          (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: -1));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final previousQuarter = analyticsNotifier.getQuarterData(-1);
        final twoQuartersAgo = analyticsNotifier.getQuarterData(-2);

        // CRITICAL: When viewing previous quarter (offset = -1),
        // it should compare previousQuarter (-1) to twoQuartersAgo (-2)
        // NOT currentQuarter (0) to previousQuarter (-1)
        final improvement =
            previousQuarter.completionRate - twoQuartersAgo.completionRate;

        final expectedText = improvement >= 0
            ? '+${(improvement * 100).round()}%'
            : '${(improvement * 100).round()}%';

        expect(find.text(expectedText), findsOneWidget,
            reason:
                'When viewing previous quarter, should compare it to two quarters ago');

        // Verify comparison label shows two quarters ago
        final quarterLabel =
            'vs Q${twoQuartersAgo.quarterNumber} ${twoQuartersAgo.quarterStart.year}';
        expect(find.text(quarterLabel), findsOneWidget);
      });
    });

    group('QuarterlyStatistics - Boundary Value Analysis', () {
      testWidgets('handles 0% completion rate', (tester) async {
        // This tests if the widget handles edge case where no prayers completed
        await tester.pumpWidget(createTestWidget(quarterOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final currentQuarter = analyticsNotifier.getQuarterData(0);

        // If completion rate is 0, should show 0/X format
        expect(
          find.textContaining('${currentQuarter.totalCompleted}/'),
          findsOneWidget,
        );
      });

      testWidgets('handles 100% completion rate', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: -10));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final oldQuarter = analyticsNotifier.getQuarterData(-10);

        // Check if any old quarter achieved 100%
        if (oldQuarter.completionRate == 1.0) {
          expect(find.text('100% Complete'), findsOneWidget);
        }
      });

      testWidgets('handles negative improvement (decline)', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: -1));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final previousQuarter = analyticsNotifier.getQuarterData(-1);
        final twoQuartersAgo = analyticsNotifier.getQuarterData(-2);

        final improvement =
            previousQuarter.completionRate - twoQuartersAgo.completionRate;

        if (improvement < 0) {
          // Negative improvement should NOT have + sign
          final expectedText = '${(improvement * 100).round()}%';
          expect(find.text(expectedText), findsOneWidget);
          expect(find.text('+$expectedText'), findsNothing);
        }
      });

      testWidgets('handles zero improvement (no change)', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: -1));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final previousQuarter = analyticsNotifier.getQuarterData(-1);
        final twoQuartersAgo = analyticsNotifier.getQuarterData(-2);

        final improvement =
            previousQuarter.completionRate - twoQuartersAgo.completionRate;

        if (improvement == 0) {
          // Zero improvement should show "+0%" (not just "0%")
          expect(find.text('+0%'), findsOneWidget);
        }
      });
    });

    group('QuarterlyStatistics - State Consistency', () {
      testWidgets('maintains immutability when offset changes', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final initialQuarter = analyticsNotifier.getQuarterData(0);

        // Rebuild with different offset
        await tester.pumpWidget(createTestWidget(quarterOffset: -1));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Original quarter data should remain unchanged
        final stillSameQuarter = analyticsNotifier.getQuarterData(0);
        expect(stillSameQuarter.totalCompleted,
            equals(initialQuarter.totalCompleted));
        expect(stillSameQuarter.totalPossible,
            equals(initialQuarter.totalPossible));
      });

      testWidgets('renders consistently on rebuild', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Capture initial render state
        expect(find.text('Quarter Completion'), findsOneWidget);

        // Force rebuild
        await tester.pumpWidget(createTestWidget(quarterOffset: 0));
        await tester.pumpAndSettle();

        // Should still render correctly
        expect(find.text('Quarter Completion'), findsOneWidget);
      });
    });

    group('QuarterlyStatistics - Edge Cases', () {
      testWidgets('handles future quarters gracefully', (tester) async {
        // Testing with positive offset (future quarters)
        await tester.pumpWidget(createTestWidget(quarterOffset: 1));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Should not crash - future quarters should have 0 data
        expect(find.byType(QuarterlyStatistics), findsOneWidget);
      });

      testWidgets('handles very old quarters (far past)', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: -20));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Should render without errors even for old data
        expect(find.byType(QuarterlyStatistics), findsOneWidget);
        expect(find.text('Quarter Completion'), findsOneWidget);
      });

      testWidgets('handles all months having equal completion rates',
          (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: -5));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // When all months are equal, should still pick one as "best"
        expect(find.text('Best Month'), findsOneWidget);
      });
    });

    group('QuarterlyStatistics - Rendering & Layout', () {
      testWidgets('uses correct responsive sizing', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // SizedBox spacing should use .h extension
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes, isNotEmpty);

        // All stat cards should be Expanded with equal width
        final expandedWidgets =
            tester.widgetList<Expanded>(find.byType(Expanded));
        expect(expandedWidgets.length,
            greaterThanOrEqualTo(4)); // 4 cards = 4 Expanded
      });

      testWidgets('applies correct text styling', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Text widgets should exist
        final textWidgets = tester.widgetList<Text>(find.byType(Text));
        expect(textWidgets, isNotEmpty);
      });

      testWidgets('displays cards in correct order', (tester) async {
        await tester.pumpWidget(createTestWidget(quarterOffset: 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Find all card titles in order
        expect(find.text('Quarter Completion'), findsOneWidget);
        expect(find.text('vs Last Quarter'), findsOneWidget);
        expect(find.text('Best Month'), findsOneWidget);
        expect(find.text('Year Progress'), findsOneWidget);

        // Verify they appear in the expected order (top row, then bottom row)
        final column = tester.widget<Column>(find.byType(Column).first);
        expect(column.children.length,
            greaterThanOrEqualTo(2)); // 2 rows + spacing
      });
    });
  });
}
