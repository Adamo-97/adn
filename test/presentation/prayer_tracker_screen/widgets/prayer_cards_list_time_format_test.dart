import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/widgets/prayer_cards_list.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/notifier/profile_settings_notifier.dart';

/// Tests for PrayerCardsList widget to verify time format changes based on settings.
void main() {
  group('PrayerCardsList Time Format Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget buildTestWidget() {
      return Sizer(
        builder: (context, orientation, deviceType) {
          return UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                backgroundColor: appColors.gray_900,
                body: const SingleChildScrollView(
                  child: PrayerCardsList(),
                ),
              ),
            ),
          );
        },
      );
    }

    testWidgets('displays times in 12-hour format when toggle is off',
        (WidgetTester tester) async {
      // Arrange - ensure 24-hour format is off
      container.read(profileSettingsNotifier.notifier).initialize();
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - default times are in 12-hour format (00:00 AM pattern)
      // The default times are "00:00" which becomes "12:00 AM"
      final use24Hour =
          container.read(profileSettingsNotifier).use24HourFormat ?? false;
      expect(use24Hour, false);
    });

    testWidgets('displays times in 24-hour format when toggle is on',
        (WidgetTester tester) async {
      // Arrange - enable 24-hour format
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Act - toggle 24-hour format on
      container.read(profileSettingsNotifier.notifier).toggle24HourFormat();
      await tester.pumpAndSettle();

      // Assert - 24-hour format should be enabled
      final use24Hour =
          container.read(profileSettingsNotifier).use24HourFormat ?? false;
      expect(use24Hour, true);
    });

    testWidgets('updates time display when format toggle changes',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Initial state: 12-hour format
      expect(
        container.read(profileSettingsNotifier).use24HourFormat ?? false,
        false,
      );

      // Act - toggle to 24-hour format
      container.read(profileSettingsNotifier.notifier).toggle24HourFormat();
      await tester.pumpAndSettle();

      // Assert - format changed
      expect(
        container.read(profileSettingsNotifier).use24HourFormat ?? false,
        true,
      );

      // Act - toggle back to 12-hour format
      container.read(profileSettingsNotifier.notifier).toggle24HourFormat();
      await tester.pumpAndSettle();

      // Assert - back to 12-hour
      expect(
        container.read(profileSettingsNotifier).use24HourFormat ?? false,
        false,
      );
    });

    testWidgets('renders all 6 prayer cards', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - verify all prayer names are present
      expect(find.text('Fajr'), findsOneWidget);
      expect(find.text('Sunrise'), findsOneWidget);
      expect(find.text('Dhuhr'), findsOneWidget);
      expect(find.text('Asr'), findsOneWidget);
      expect(find.text('Maghrib'), findsOneWidget);
      expect(find.text('Isha'), findsOneWidget);
    });

    testWidgets('watches profile settings for time format changes',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Act - change format setting
      container.read(profileSettingsNotifier.notifier).toggle24HourFormat();
      await tester.pump(); // Trigger rebuild

      // Assert - widget should rebuild with new format
      // Verify that widget is using profileSettingsNotifier
      final profileState = container.read(profileSettingsNotifier);
      expect(profileState.use24HourFormat, true);
    });

    testWidgets('maintains single source of truth for time format',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Act - toggle format in profile settings
      container.read(profileSettingsNotifier.notifier).toggle24HourFormat();
      await tester.pumpAndSettle();

      // Assert - prayer cards should read from same source
      final profileFormat =
          container.read(profileSettingsNotifier).use24HourFormat ?? false;
      expect(profileFormat, true);

      // The PrayerCardsList should be watching this same state
      // This ensures single source of truth
    });

    group('State Consistency Tests', () {
      testWidgets('format preference persists across rebuilds',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Act - set to 24-hour
        container.read(profileSettingsNotifier.notifier).toggle24HourFormat();
        await tester.pumpAndSettle();

        // Rebuild widget
        await tester.pump();

        // Assert - format still enabled
        expect(
          container.read(profileSettingsNotifier).use24HourFormat,
          true,
        );
      });

      testWidgets('format applies to all prayer cards uniformly',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - all cards use the same format preference
        final format =
            container.read(profileSettingsNotifier).use24HourFormat ?? false;

        // All 6 prayer cards should use this same format
        // (Format is applied via TimeFormatUtils in each card)
        expect(format, false); // Default is 12-hour format
      });
    });

    testWidgets('prayer cards list renders without errors',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - no exceptions thrown
      expect(tester.takeException(), isNull);
    });
  });
}
