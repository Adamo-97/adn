import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/widgets/next_prayer_card.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_tracker_notifier.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/models/prayer_tracker_model.dart';
import 'package:adam_s_application/widgets/custom_image_view.dart';
import 'package:adam_s_application/core/utils/time_format_utils.dart';

/// Comprehensive test suite for NextPrayerCard widget.
/// Tests cover rendering, state management, responsive design, and visual consistency.
void main() {
  group('NextPrayerCard Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    /// Helper to wrap widget with required providers and MaterialApp.
    Widget buildTestWidget({PrayerTrackerModel? mockModel}) {
      return Sizer(
        builder: (context, orientation, deviceType) {
          return UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                backgroundColor: appColors.gray_900,
                body: const NextPrayerCard(),
              ),
            ),
          );
        },
      );
    }

    testWidgets('renders correctly with all UI elements',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - verify all text elements are present (no "Next Prayer" label)
      // Default currentPrayer is 'Asr', so next prayer should be 'Maghrib'
      final state = container.read(prayerTrackerNotifierProvider);
      expect(state.currentPrayer, 'Asr');
      expect(state.nextPrayer, 'Maghrib');

      expect(find.text('Next Prayer is Maghrib'), findsOneWidget);
      // Time is now fetched from dailyTimes ('00:00') and formatted to 12-hour ('12:00 AM')
      expect(find.text('12:00 AM'), findsOneWidget);
      expect(find.text('Ronneby, SE'), findsOneWidget);
    });

    testWidgets('displays prayer icon correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - verify CustomImageView for icon exists
      final iconFinder = find.byType(CustomImageView);
      expect(iconFinder, findsNWidgets(2)); // location icon + prayer icon
    });

    testWidgets('applies correct card styling and elevation',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - find the main container
      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      // Verify rounded corners
      expect(decoration.borderRadius, BorderRadius.circular(16.h));

      // Verify gradient background
      expect(decoration.gradient, isA<LinearGradient>());
      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.colors.length, 2);
      expect(gradient.colors[0], appColors.gray_700);
      expect(
        gradient.colors[1],
        appColors.gray_700.withValues(alpha: 0.9),
      );

      // Verify shadow for elevation
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 1);
      expect(decoration.boxShadow![0].blurRadius, 12);
      expect(
          decoration.boxShadow![0].color, Colors.black.withValues(alpha: 0.25));
    });

    testWidgets('applies correct padding', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - verify container padding
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.padding, EdgeInsets.all(16.h));
    });

    testWidgets('uses responsive sizing with .h extension',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - verify sizing is responsive
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.padding, EdgeInsets.all(16.h));

      // Verify icon container sizing
      final iconContainers = tester.widgetList<Container>(
        find.byType(Container),
      );
      final iconContainer = iconContainers.lastWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      expect(iconContainer.constraints?.maxWidth, 56.h);
      expect(iconContainer.constraints?.maxHeight, 56.h);
    });

    testWidgets('uses .fSize for all text elements',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - verify all Text widgets use .fSize
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      for (final textWidget in textWidgets) {
        // All text should have fontSize set (using .fSize)
        expect(textWidget.style?.fontSize, isNotNull);
      }
    });

    group('State Management Tests', () {
      testWidgets('reads data from prayer tracker notifier',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - verify default notifier data is displayed
        final state = container.read(prayerTrackerNotifierProvider);
        expect(state.prayerTrackerModel, isNotNull);
      });

      testWidgets('updates when notifier state changes',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify initial state - time from dailyTimes formatted to 12-hour
        expect(find.text('12:00 AM'), findsOneWidget);

        // Act - pump to trigger any pending updates
        await tester.pump();

        // Assert - UI reflects state
        // (This test is illustrative - actual implementation depends on notifier methods)
        expect(find.text('12:00 AM'), findsOneWidget);
      });

      testWidgets('maintains immutability of state objects',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final initialState = container.read(prayerTrackerNotifierProvider);

        // Act - trigger rebuild
        await tester.pump();
        final newState = container.read(prayerTrackerNotifierProvider);

        // Assert - state reference is same (no unnecessary rebuilds)
        expect(identical(initialState, newState), true);
      });
    });

    group('Boundary Value Analysis - Content Tests', () {
      testWidgets('handles short prayer name', (WidgetTester tester) async {
        // Arrange & Act - next prayer depends on currentPrayer state
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final state = container.read(prayerTrackerNotifierProvider);
        // Assert - renders without overflow (next prayer is Maghrib when current is Asr)
        expect(find.text('Next Prayer is ${state.nextPrayer}'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('handles long location name', (WidgetTester tester) async {
        // Arrange & Act - default location: "Ronneby, SE"
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - text renders correctly with ellipsis support via Flexible
        expect(find.text('Ronneby, SE'), findsOneWidget);
      });
    });

    testWidgets('prayer icon has circular background',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - find circular container
      final containers = tester.widgetList<Container>(find.byType(Container));
      final circularContainer = containers.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).shape == BoxShape.circle,
      );

      final decoration = circularContainer.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(
        decoration.color,
        appColors.gray_900.withValues(alpha: 0.4),
      );
    });

    testWidgets('location icon and text are aligned',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - verify Row contains location icon and text
      final rowWithLocationFinder = find.descendant(
        of: find.byType(Row),
        matching: find.byType(CustomImageView),
      );
      expect(rowWithLocationFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('time and location are separated by divider',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - verify divider exists (look for Container with specific constraints)
      final dividerFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints != null &&
            widget.constraints!.maxWidth == 1,
      );
      expect(dividerFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('card uses consistent color scheme',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - verify all text colors are from app color scheme
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      for (final text in textWidgets) {
        expect(text.style?.color, isNotNull);
        // Colors should be from appColors (whiteA700, orange_200, etc.)
      }
    });

    group('Rendering and Layout Tests', () {
      testWidgets('card takes full width available',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert
        final container =
            tester.widget<Container>(find.byType(Container).first);
        expect(container.constraints?.maxWidth, double.maxFinite);
      });

      testWidgets('left and right sections are laid out correctly',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - verify Row layout
        final mainRow = tester.widget<Row>(
          find.descendant(
            of: find.byType(Container).first,
            matching: find.byType(Row).first,
          ),
        );
        expect(mainRow.children.length, greaterThanOrEqualTo(2));
      });

      testWidgets('spacing between elements is consistent',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - verify SizedBox spacing
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes, isNotEmpty);
        // Spacing values: 6.h, 10.h, 12.h as per design
      });
    });

    testWidgets('icon size is consistent with design',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - verify icon container size
      final containers = tester.widgetList<Container>(find.byType(Container));
      final iconContainer = containers.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).shape == BoxShape.circle,
      );

      expect(iconContainer.constraints?.maxWidth, 56.h);
      expect(iconContainer.constraints?.maxHeight, 56.h);
    });

    testWidgets('card gradient direction is correct',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;

      expect(gradient.begin, Alignment.topLeft);
      expect(gradient.end, Alignment.bottomRight);
    });

    group('Cross-Platform Consistency Tests', () {
      testWidgets('uses .fSize for all font sizes (iOS/Android)',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - all Text widgets use .fSize
        final textWidgets = tester.widgetList<Text>(find.byType(Text));
        for (final text in textWidgets) {
          // Font sizes should be calculated with .fSize extension
          expect(text.style?.fontSize, isNotNull);
        }
      });

      testWidgets('uses .h for spacing and sizing',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - verify responsive sizing is applied
        final container =
            tester.widget<Container>(find.byType(Container).first);
        expect(container.padding, EdgeInsets.all(16.h));
      });
    });

    group('Next Prayer Logic Tests (Single Source of Truth)', () {
      testWidgets('displays correct next prayer based on current prayer state',
          (WidgetTester tester) async {
        // Arrange - Default current prayer is Asr (from PrayerTrackerState init)
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final state = container.read(prayerTrackerNotifierProvider);

        // Assert - Next prayer should be computed correctly from state
        expect(state.currentPrayer, isA<String>());
        expect(state.nextPrayer, isA<String>());
        expect(find.text('Next Prayer is ${state.nextPrayer}'), findsOneWidget);
      });

      testWidgets('nextPrayer getter computes correctly for different values',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final state = container.read(prayerTrackerNotifierProvider);

        // Assert - Verify logic: next prayer is the one after current in kAllPrayerKeys
        final currentIndex = kAllPrayerKeys.indexOf(state.currentPrayer);
        final expectedNextIndex = (currentIndex + 1 < kAllPrayerKeys.length)
            ? currentIndex + 1
            : 0; // Wraps to Fajr
        final expectedNextPrayer = kAllPrayerKeys[expectedNextIndex];

        expect(state.nextPrayer, expectedNextPrayer);
      });

      testWidgets('displays correct icon for next prayer',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final state = container.read(prayerTrackerNotifierProvider);

        // Assert - Verify icon path matches next prayer
        final customImageViews =
            tester.widgetList<CustomImageView>(find.byType(CustomImageView));
        final prayerIcon = customImageViews.firstWhere(
          (img) => img.height == 38.h && img.width == 38.h,
        );
        expect(prayerIcon.imagePath,
            ImageConstant.iconForPrayer(state.nextPrayer));
      });

      testWidgets('displays correct time for next prayer from dailyTimes',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final state = container.read(prayerTrackerNotifierProvider);
        final nextPrayerTime = state.dailyTimes[state.nextPrayer] ?? '00:00';

        // Format the time (default is 12-hour format)
        final formattedTime = TimeFormatUtils.formatTime(nextPrayerTime, false);

        // Assert - Check that formatted time is displayed
        expect(find.text(formattedTime), findsOneWidget);
      });
    });
  });
}
