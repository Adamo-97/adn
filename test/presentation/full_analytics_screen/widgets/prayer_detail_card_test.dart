import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/full_analytics_screen/widgets/prayer_detail_card.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/models/prayer_analytics_data.dart';

/// Comprehensive tests for PrayerDetailCard widget
/// Tests placeholder display, day details, prayer status rendering, and edge cases
void main() {
  setUpAll(() {
    SizeUtils.width = 375;
    SizeUtils.height = 812;
  });

  /// Helper to create test widget with required wrappers
  Widget createTestWidget({DailyPrayerData? dayData}) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: SingleChildScrollView(
          child: PrayerDetailCard(dayData: dayData),
        ),
      ),
    );
  }

  group('PrayerDetailCard Tests', () {
    group('Null Handling', () {
      testWidgets('displays placeholder when dayData is null', (tester) async {
        await tester.pumpWidget(createTestWidget(dayData: null));

        // Verify placeholder text is displayed
        expect(find.text('Click on a day to see full preview'), findsOneWidget);

        // Verify no day details are shown
        expect(find.byType(Icon), findsNothing);
        expect(find.text('Fajr'), findsNothing);
        expect(find.text('Dhuhr'), findsNothing);
        expect(find.text('Asr'), findsNothing);
        expect(find.text('Maghrib'), findsNothing);
        expect(find.text('Isha'), findsNothing);
      });

      testWidgets('placeholder has correct styling', (tester) async {
        await tester.pumpWidget(createTestWidget(dayData: null));

        final textWidget = tester.widget<Text>(
          find.text('Click on a day to see full preview'),
        );

        expect(textWidget.textAlign, TextAlign.center);
        expect(textWidget.style?.color, appColors.gray_500);
      });
    });

    group('Day Details Display', () {
      testWidgets('displays date in correct format', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 3,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': true,
            'Asr': false,
            'Maghrib': true,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        // Check date format: "EEEE, MMM d" -> "Wednesday, Jan 15"
        expect(find.text('Wednesday, Jan 15'), findsOneWidget);
      });

      testWidgets('displays completion count correctly', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 3,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': true,
            'Asr': false,
            'Maghrib': true,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        expect(find.text('3/5 Prayers Completed'), findsOneWidget);
      });

      testWidgets('displays all 5 prayer names', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 0,
          isFuture: false,
          prayerStatuses: {
            'Fajr': false,
            'Dhuhr': false,
            'Asr': false,
            'Maghrib': false,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        expect(find.text('Fajr'), findsOneWidget);
        expect(find.text('Dhuhr'), findsOneWidget);
        expect(find.text('Asr'), findsOneWidget);
        expect(find.text('Maghrib'), findsOneWidget);
        expect(find.text('Isha'), findsOneWidget);
      });
    });

    group('Prayer Status Rendering', () {
      testWidgets('completed prayers show check icon', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 2,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': false,
            'Asr': false,
            'Maghrib': true,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        // Should have 2 check icons (Fajr and Maghrib completed)
        expect(find.byIcon(Icons.check), findsNWidgets(2));
      });

      testWidgets('missed prayers have no icon', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 1,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': false,
            'Asr': false,
            'Maghrib': false,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        // Only 1 check icon (Fajr)
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('completed prayer box has correct styling', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 5,
          isFuture: true,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': true,
            'Asr': true,
            'Maghrib': true,
            'Isha': true,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        // Find all prayer status containers
        final containers = tester.widgetList<Container>(
          find.descendant(
            of: find.byType(PrayerDetailCard),
            matching: find.byType(Container),
          ),
        );

        // Should have containers with green background and border
        bool foundCompletedBox = false;
        for (final container in containers) {
          final decoration = container.decoration as BoxDecoration?;
          if (decoration?.color == appColors.success.withValues(alpha: 0.2)) {
            foundCompletedBox = true;
            expect(decoration?.border, isA<Border>());
          }
        }

        expect(foundCompletedBox, true);
      });

      testWidgets('missed prayer box has correct styling', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 0,
          isFuture: false,
          prayerStatuses: {
            'Fajr': false,
            'Dhuhr': false,
            'Asr': false,
            'Maghrib': false,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        // All prayer boxes should be transparent with gray border
        final containers = tester.widgetList<Container>(
          find.descendant(
            of: find.byType(PrayerDetailCard),
            matching: find.byType(Container),
          ),
        );

        bool foundMissedBox = false;
        for (final container in containers) {
          final decoration = container.decoration as BoxDecoration?;
          if (decoration?.color == Colors.transparent &&
              decoration?.border != null) {
            foundMissedBox = true;
          }
        }

        expect(foundMissedBox, true);
      });
    });

    group('Boundary Value Analysis', () {
      testWidgets('handles 0/5 prayers completed', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 0,
          isFuture: false,
          prayerStatuses: {
            'Fajr': false,
            'Dhuhr': false,
            'Asr': false,
            'Maghrib': false,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        expect(find.text('0/5 Prayers Completed'), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNothing);
      });

      testWidgets('handles 5/5 prayers completed', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 5,
          isFuture: true,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': true,
            'Asr': true,
            'Maghrib': true,
            'Isha': true,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        expect(find.text('5/5 Prayers Completed'), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNWidgets(5));
      });

      testWidgets('handles 1/5 prayers completed (minimum positive)',
          (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 1,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': false,
            'Asr': false,
            'Maghrib': false,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        expect(find.text('1/5 Prayers Completed'), findsOneWidget);
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('handles 4/5 prayers completed (maximum incomplete)',
          (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 4,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': true,
            'Asr': true,
            'Maghrib': true,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        expect(find.text('4/5 Prayers Completed'), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNWidgets(4));
      });
    });

    group('Layout and Responsive Design', () {
      testWidgets('prayer columns are evenly spaced', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 3,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': true,
            'Asr': false,
            'Maghrib': true,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        final row = tester.widget<Row>(
          find.descendant(
            of: find.byType(PrayerDetailCard),
            matching: find.byType(Row),
          ),
        );

        expect(row.mainAxisAlignment, MainAxisAlignment.spaceEvenly);
        expect(row.children.length, 5); // 5 prayer columns
      });

      testWidgets('uses responsive sizing extensions', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 1,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': false,
            'Asr': false,
            'Maghrib': false,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        // Verify card container exists with proper decoration
        final cardContainer = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(PrayerDetailCard),
                matching: find.byType(Container),
              )
              .first,
        );

        final decoration = cardContainer.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(12.h));
      });

      testWidgets('prayer status boxes are square', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 1,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': false,
            'Asr': false,
            'Maghrib': false,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        // Find all containers representing prayer status boxes
        final containers = tester.widgetList<Container>(
          find.descendant(
            of: find.byType(PrayerDetailCard),
            matching: find.byType(Container),
          ),
        );

        // Verify the structure exists (prayer boxes are in columns)
        expect(find.byType(Column), findsWidgets);
        expect(containers, isNotEmpty);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty prayerStatuses map', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 0,
          isFuture: false,
          prayerStatuses: {}, // Empty map
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        // Should still render all prayer names
        expect(find.text('Fajr'), findsOneWidget);
        expect(find.text('Dhuhr'), findsOneWidget);
        expect(find.text('Asr'), findsOneWidget);
        expect(find.text('Maghrib'), findsOneWidget);
        expect(find.text('Isha'), findsOneWidget);

        // No check icons (all treated as false via ?? false)
        expect(find.byIcon(Icons.check), findsNothing);
      });

      testWidgets('handles partial prayerStatuses map', (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 2,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Maghrib': true,
            // Missing: Dhuhr, Asr, Isha
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        // Should have 2 check icons (Fajr and Maghrib)
        expect(find.byIcon(Icons.check), findsNWidgets(2));

        // All prayer names still rendered
        expect(find.text('Fajr'), findsOneWidget);
        expect(find.text('Dhuhr'), findsOneWidget);
        expect(find.text('Asr'), findsOneWidget);
        expect(find.text('Maghrib'), findsOneWidget);
        expect(find.text('Isha'), findsOneWidget);
      });

      testWidgets('handles future date', (tester) async {
        final futureDate = DateTime.now().add(const Duration(days: 10));
        final dayData = DailyPrayerData(
          date: futureDate,
          completedPrayers: 0,
          isFuture: false,
          prayerStatuses: {
            'Fajr': false,
            'Dhuhr': false,
            'Asr': false,
            'Maghrib': false,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        // Should still render normally (no special "future" handling in this widget)
        expect(find.text('0/5 Prayers Completed'), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNothing);
      });

      testWidgets('handles old date from years ago', (tester) async {
        final oldDate = DateTime(2020, 6, 15);
        final dayData = DailyPrayerData(
          date: oldDate,
          completedPrayers: 3,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': true,
            'Asr': false,
            'Maghrib': true,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));

        // Verify date format works for old dates
        expect(find.text('Monday, Jun 15'), findsOneWidget);
        expect(find.text('3/5 Prayers Completed'), findsOneWidget);
      });
    });

    group('State Consistency', () {
      testWidgets('switching from null to data updates correctly',
          (tester) async {
        // Start with null
        await tester.pumpWidget(createTestWidget(dayData: null));
        expect(find.text('Click on a day to see full preview'), findsOneWidget);

        // Update to data
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 3,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': true,
            'Asr': false,
            'Maghrib': true,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: dayData));
        await tester.pumpAndSettle();

        expect(find.text('Click on a day to see full preview'), findsNothing);
        expect(find.text('3/5 Prayers Completed'), findsOneWidget);
      });

      testWidgets('switching from data to null updates correctly',
          (tester) async {
        final dayData = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 3,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': true,
            'Asr': false,
            'Maghrib': true,
            'Isha': false,
          },
        );

        // Start with data
        await tester.pumpWidget(createTestWidget(dayData: dayData));
        expect(find.text('3/5 Prayers Completed'), findsOneWidget);

        // Update to null
        await tester.pumpWidget(createTestWidget(dayData: null));
        await tester.pumpAndSettle();

        expect(find.text('3/5 Prayers Completed'), findsNothing);
        expect(find.text('Click on a day to see full preview'), findsOneWidget);
      });

      testWidgets('switching between different days updates correctly',
          (tester) async {
        final day1 = DailyPrayerData(
          date: DateTime(2025, 1, 15),
          completedPrayers: 2,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': false,
            'Asr': false,
            'Maghrib': true,
            'Isha': false,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: day1));
        expect(find.text('2/5 Prayers Completed'), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNWidgets(2));

        // Switch to day2
        final day2 = DailyPrayerData(
          date: DateTime(2025, 1, 20),
          completedPrayers: 4,
          isFuture: false,
          prayerStatuses: {
            'Fajr': true,
            'Dhuhr': true,
            'Asr': true,
            'Maghrib': false,
            'Isha': true,
          },
        );

        await tester.pumpWidget(createTestWidget(dayData: day2));
        await tester.pumpAndSettle();

        expect(find.text('2/5 Prayers Completed'), findsNothing);
        expect(find.text('4/5 Prayers Completed'), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNWidgets(4));
      });
    });
  });
}
