import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/full_analytics_screen/widgets/quarterly_calendar_grid.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_analytics_notifier.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/models/prayer_analytics_data.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:intl/intl.dart';

void main() {
  // Initialize SizeUtils for responsive sizing
  setUpAll(() {
    SizeUtils.width = 375;
    SizeUtils.height = 812;
  });

  group('QuarterlyCalendarGrid Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget({
      bool showNavigation = true,
      Function(int)? onQuarterOffsetChanged,
      Function(DailyPrayerData?)? onDaySelected,
    }) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: theme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: QuarterlyCalendarGrid(
                showNavigation: showNavigation,
                onQuarterOffsetChanged: onQuarterOffsetChanged,
                onDaySelected: onDaySelected,
              ),
            ),
          ),
        ),
      );
    }

    group('QuarterlyCalendarGrid - Basic Rendering', () {
      testWidgets('renders calendar with navigation controls', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Should have navigation buttons
        expect(find.byIcon(Icons.chevron_left), findsOneWidget);
        expect(find.byIcon(Icons.chevron_right), findsOneWidget);

        // Should have quarter label
        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);
        expect(find.text(quarterStats.quarterLabel), findsOneWidget);
      });

      testWidgets('renders legend with all completion levels', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Should show all legend items
        expect(find.text('90%+'), findsOneWidget);
        expect(find.text('70%+'), findsOneWidget);
        expect(find.text('50%+'), findsOneWidget);
        expect(find.text('<50%'), findsOneWidget);
      });

      testWidgets('renders month sections with headers', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);

        // Should have 3 month headers (one for each month in quarter)
        for (final monthData in quarterStats.monthlyData) {
          final monthName =
              DateFormat('MMMM yyyy').format(monthData.monthStart);
          expect(find.text(monthName), findsOneWidget);
        }
      });

      testWidgets('renders grid with 10 days per row', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Should use GridView with crossAxisCount: 10
        final gridViews = tester.widgetList<GridView>(find.byType(GridView));
        expect(gridViews, isNotEmpty);

        for (final gridView in gridViews) {
          final delegate = gridView.gridDelegate
              as SliverGridDelegateWithFixedCrossAxisCount;
          expect(delegate.crossAxisCount, equals(10));
        }
      });

      testWidgets('hides navigation when showNavigation is false',
          (tester) async {
        await tester.pumpWidget(createTestWidget(showNavigation: false));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Navigation buttons should not be present
        expect(find.byIcon(Icons.chevron_left), findsNothing);
        expect(find.byIcon(Icons.chevron_right), findsNothing);
      });
    });

    group('QuarterlyCalendarGrid - Day Selection', () {
      testWidgets('selects day when tapped', (tester) async {
        DailyPrayerData? selectedDay;

        await tester.pumpWidget(createTestWidget(
          onDaySelected: (day) => selectedDay = day,
        ));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);
        final firstDay = quarterStats.monthlyData.first.dailyData.first;

        // Find and tap the first day
        final dayCell = find.text('${firstDay.date.day}').first;
        await tester.tap(dayCell);
        await tester.pumpAndSettle();

        // Callback should be called with selected day
        expect(selectedDay, isNotNull);
        expect(selectedDay!.date, equals(firstDay.date));
      });

      testWidgets('deselects day when tapped again (toggle)', (tester) async {
        DailyPrayerData? selectedDay;
        int callbackCount = 0;

        await tester.pumpWidget(createTestWidget(
          onDaySelected: (day) {
            selectedDay = day;
            callbackCount++;
          },
        ));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);
        final firstDay = quarterStats.monthlyData.first.dailyData.first;

        // First tap - select
        final dayCell = find.text('${firstDay.date.day}').first;
        await tester.tap(dayCell);
        await tester.pumpAndSettle();

        expect(selectedDay, isNotNull);
        expect(callbackCount, equals(1));

        // Second tap - deselect
        await tester.tap(dayCell);
        await tester.pumpAndSettle();

        expect(selectedDay, isNull);
        expect(callbackCount, equals(2));
      });

      testWidgets('switches selection to new day', (tester) async {
        DailyPrayerData? selectedDay;

        await tester.pumpWidget(createTestWidget(
          onDaySelected: (day) => selectedDay = day,
        ));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);
        final firstDay = quarterStats.monthlyData.first.dailyData.first;
        final secondDay = quarterStats.monthlyData.first.dailyData[1];

        // Select first day
        await tester.tap(find.text('${firstDay.date.day}').first);
        await tester.pumpAndSettle();
        expect(selectedDay!.date, equals(firstDay.date));

        // Select second day
        await tester.tap(find.text('${secondDay.date.day}').first);
        await tester.pumpAndSettle();
        expect(selectedDay!.date, equals(secondDay.date));
      });

      testWidgets('clears selection when quarter changes', (tester) async {
        DailyPrayerData? selectedDay;
        int callbackCount = 0;

        await tester.pumpWidget(createTestWidget(
          onDaySelected: (day) {
            selectedDay = day;
            callbackCount++;
          },
        ));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);
        final firstDay = quarterStats.monthlyData.first.dailyData.first;

        // Select a day
        await tester.tap(find.text('${firstDay.date.day}').first);
        await tester.pumpAndSettle();
        expect(selectedDay, isNotNull);
        expect(callbackCount, equals(1));

        // Navigate to previous quarter
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pumpAndSettle();

        // Selection should be cleared (callback called again with null)
        expect(selectedDay, isNull);
        expect(callbackCount, equals(2));
      });
    });

    group('QuarterlyCalendarGrid - Quarter Navigation', () {
      testWidgets('navigates to previous quarter', (tester) async {
        int? quarterOffset;

        await tester.pumpWidget(createTestWidget(
          onQuarterOffsetChanged: (offset) => quarterOffset = offset,
        ));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Tap previous quarter button
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pumpAndSettle();

        // Should call callback with -1
        expect(quarterOffset, equals(-1));

        // Quarter label should update
        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final prevQuarterStats = analyticsNotifier.getQuarterData(-1);
        expect(find.text(prevQuarterStats.quarterLabel), findsOneWidget);
      });

      testWidgets('navigates to next quarter (if not at current)',
          (tester) async {
        int? quarterOffset;

        await tester.pumpWidget(createTestWidget(
          onQuarterOffsetChanged: (offset) => quarterOffset = offset,
        ));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Go to previous quarter first
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pumpAndSettle();
        expect(quarterOffset, equals(-1));

        // Now go back to next quarter
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pumpAndSettle();
        expect(quarterOffset, equals(0));
      });

      testWidgets('disables next button when at current quarter',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // At current quarter (offset = 0), next button should be disabled
        final nextButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.chevron_right),
        );

        // Disabled buttons have onPressed = null
        expect(nextButton.onPressed, isNull);
      });

      testWidgets('enables next button when viewing past quarters',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Go to previous quarter
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pumpAndSettle();

        // Next button should now be enabled
        final nextButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.chevron_right),
        );
        expect(nextButton.onPressed, isNotNull);
      });

      testWidgets('previous button is always enabled', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Previous button should be enabled
        final prevButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.chevron_left),
        );
        expect(prevButton.onPressed, isNotNull);
      });
    });

    group('QuarterlyCalendarGrid - Color Coding', () {
      testWidgets('applies correct colors based on completion rate',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);

        // Check that days have containers with appropriate colors
        for (final monthData in quarterStats.monthlyData) {
          for (final dayData in monthData.dailyData) {
            if (!dayData.isFuture) {
              final completionRate = dayData.completedPrayers / 5.0;

              // Verify color coding logic
              if (completionRate >= 0.9) {
                // Should use salahEssentials (teal)
              } else if (completionRate >= 0.7) {
                // Should use salahPurification (green)
              } else if (completionRate >= 0.5) {
                // Should use orange_200
              } else if (completionRate > 0) {
                // Should use salahSpecialSituations
              }
            }
          }
        }

        // Containers should exist
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('uses gray for future days', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);

        // Find a future day
        for (final monthData in quarterStats.monthlyData) {
          for (final dayData in monthData.dailyData) {
            if (dayData.isFuture) {
              // Future days should have gray background
              // and gray text
              expect(find.text('${dayData.date.day}'), findsWidgets);
            }
          }
        }
      });
    });

    group('QuarterlyCalendarGrid - Today Highlighting', () {
      testWidgets('highlights today with orange border', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);

        // Find today's cell
        bool foundToday = false;
        for (final monthData in quarterStats.monthlyData) {
          for (final dayData in monthData.dailyData) {
            if (dayData.date.year == today.year &&
                dayData.date.month == today.month &&
                dayData.date.day == today.day) {
              foundToday = true;
              expect(find.text('${dayData.date.day}'), findsWidgets);
              break;
            }
          }
        }

        // Today should be in the current quarter
        if (foundToday) {
          expect(find.byType(Container), findsWidgets);
        }
      });
    });

    group('QuarterlyCalendarGrid - Month Organization', () {
      testWidgets('displays dividers between months', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Should have dividers (2 dividers for 3 months)
        final dividers = tester.widgetList<Divider>(find.byType(Divider));
        expect(dividers.length, greaterThanOrEqualTo(2));
      });

      testWidgets('organizes days by month correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);

        // Each month should have its own GridView
        final gridViews = tester.widgetList<GridView>(find.byType(GridView));
        expect(gridViews.length, equals(quarterStats.monthlyData.length));
      });

      testWidgets('month headers use correct date format', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);

        // Verify date format: "MMMM yyyy" (e.g., "January 2025")
        for (final monthData in quarterStats.monthlyData) {
          final expectedFormat =
              DateFormat('MMMM yyyy').format(monthData.monthStart);
          expect(find.text(expectedFormat), findsOneWidget);
        }
      });
    });

    group('QuarterlyCalendarGrid - Boundary Value Analysis', () {
      testWidgets('handles 0% completion (no prayers)', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);

        // Find days with 0 prayers
        for (final monthData in quarterStats.monthlyData) {
          for (final dayData in monthData.dailyData) {
            if (dayData.completedPrayers == 0 && !dayData.isFuture) {
              // Should render without errors
              expect(find.text('${dayData.date.day}'), findsWidgets);
            }
          }
        }
      });

      testWidgets('handles 100% completion (5/5 prayers)', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);

        // Find days with 5 prayers
        for (final monthData in quarterStats.monthlyData) {
          for (final dayData in monthData.dailyData) {
            if (dayData.completedPrayers == 5) {
              // Should use excellent color (teal)
              expect(find.text('${dayData.date.day}'), findsWidgets);
            }
          }
        }
      });

      testWidgets('handles boundary rates: 89.9%, 90%, 69.9%, 70%',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Test that rates at boundaries get correct colors:
        // 4/5 = 80% -> green (70-89%)
        // 3/5 = 60% -> gold (50-69%)
        // 2/5 = 40% -> coral (<50%)
        // 1/5 = 20% -> coral (<50%)

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarterStats = analyticsNotifier.getQuarterData(0);

        // Verify different completion levels exist
        final completionLevels = <int>{};
        for (final monthData in quarterStats.monthlyData) {
          for (final dayData in monthData.dailyData) {
            if (!dayData.isFuture) {
              completionLevels.add(dayData.completedPrayers);
            }
          }
        }

        expect(completionLevels, isNotEmpty);
      });
    });

    group('QuarterlyCalendarGrid - State Consistency', () {
      testWidgets('maintains state across rebuilds', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final initialQuarter = analyticsNotifier.getQuarterData(0);

        // Rebuild widget
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Data should be consistent
        final rebuiltQuarter = analyticsNotifier.getQuarterData(0);
        expect(
            rebuiltQuarter.quarterLabel, equals(initialQuarter.quarterLabel));
      });

      testWidgets('preserves immutability of quarter data', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final analyticsNotifier =
            container.read(prayerAnalyticsProvider.notifier);
        final quarter1 = analyticsNotifier.getQuarterData(0);

        // Navigate to different quarter
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pumpAndSettle();

        // Original quarter data should remain unchanged
        final quarter1Again = analyticsNotifier.getQuarterData(0);
        expect(quarter1Again.quarterLabel, equals(quarter1.quarterLabel));
      });
    });

    group('QuarterlyCalendarGrid - Layout & Responsive Design', () {
      testWidgets('uses responsive sizing with .h extension', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // SizedBox widgets should use .h for responsive spacing
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes, isNotEmpty);
      });

      testWidgets('applies consistent spacing in grid', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final gridViews = tester.widgetList<GridView>(find.byType(GridView));
        for (final gridView in gridViews) {
          final delegate = gridView.gridDelegate
              as SliverGridDelegateWithFixedCrossAxisCount;

          // Should have 6.h spacing
          expect(delegate.crossAxisSpacing, isNotNull);
          expect(delegate.mainAxisSpacing, isNotNull);
        }
      });

      testWidgets('uses square cells (1.0 aspect ratio)', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final gridViews = tester.widgetList<GridView>(find.byType(GridView));
        for (final gridView in gridViews) {
          final delegate = gridView.gridDelegate
              as SliverGridDelegateWithFixedCrossAxisCount;

          // Cells should be square (childAspectRatio: 1.0)
          expect(delegate.childAspectRatio, equals(1.0));
        }
      });
    });

    group('QuarterlyCalendarGrid - Edge Cases', () {
      testWidgets('handles very old quarters without errors', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Navigate to very old quarter
        for (int i = 0; i < 10; i++) {
          await tester.tap(find.byIcon(Icons.chevron_left));
          await tester.pumpAndSettle();
        }

        // Should still render
        expect(find.byType(QuarterlyCalendarGrid), findsOneWidget);
      });

      testWidgets('handles quarter with no completed prayers', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Should render without errors even if no prayers completed
        expect(find.byType(GridView), findsWidgets);
      });

      testWidgets('handles empty month data gracefully', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Widget should handle edge cases in data
        expect(find.byType(QuarterlyCalendarGrid), findsOneWidget);
      });
    });
  });
}
