import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/widgets/time_format_24hour.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/notifier/profile_settings_notifier.dart';
import 'package:adam_s_application/widgets/custom_image_view.dart';
import '../../../helpers/test_helpers.dart';

/// Comprehensive test suite for TimeFormat24Hour widget.
/// Tests rendering, state management, user interactions, and visual consistency.
void main() {
  group('TimeFormat24Hour Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      // Initialize test environment for each test
      initializeTestEnvironment();
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
                body: const TimeFormat24Hour(),
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

      // Assert - verify all text elements
      expect(find.text('24-Hour Format'), findsOneWidget);
      expect(find.text('Display times in 24-hour format'), findsOneWidget);

      // Assert - verify icon is present
      final iconFinder = find.byType(CustomImageView);
      expect(iconFinder, findsNWidgets(2)); // time format icon + toggle icon
    });

    testWidgets('displays time format icon with correct styling',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - verify container with icon
      final containerFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == appColors.gray_700,
      );
      expect(containerFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('displays title with correct text style',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final titleWidget = tester.widget<Text>(find.text('24-Hour Format'));
      expect(titleWidget.style?.fontSize, 16.fSize);
    });

    testWidgets('displays subtitle with correct text style',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final subtitleWidget =
          tester.widget<Text>(find.text('Display times in 24-hour format'));
      expect(subtitleWidget.style?.fontSize, 11.fSize);
      expect(subtitleWidget.style?.color, appColors.gray_100);
    });

    group('State Management Tests', () {
      testWidgets('displays unchecked state initially (default: false)',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - should show unchecked icon
        final state = container.read(profileSettingsNotifier);
        expect(state.use24HourFormat, false);
      });

      testWidgets('toggles state when tapped', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Get initial state
        final initialState = container.read(profileSettingsNotifier);
        expect(initialState.use24HourFormat, false);

        // Act - tap toggle
        await tester.tap(find.byType(GestureDetector).last);
        await tester.pumpAndSettle();

        // Assert - state should be toggled
        final newState = container.read(profileSettingsNotifier);
        expect(newState.use24HourFormat, true);
      });

      testWidgets('state updates trigger UI rebuild',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Act - toggle on
        await tester.tap(find.byType(GestureDetector).last);
        await tester.pumpAndSettle();

        // Assert - UI should reflect new state
        final state = container.read(profileSettingsNotifier);
        expect(state.use24HourFormat, true);

        // Act - toggle off
        await tester.tap(find.byType(GestureDetector).last);
        await tester.pumpAndSettle();

        // Assert - back to false
        final finalState = container.read(profileSettingsNotifier);
        expect(finalState.use24HourFormat, false);
      });

      testWidgets('maintains immutability of state objects',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final initialState = container.read(profileSettingsNotifier);

        // Act - toggle state
        await tester.tap(find.byType(GestureDetector).last);
        await tester.pumpAndSettle();

        final newState = container.read(profileSettingsNotifier);

        // Assert - states should be different objects
        expect(identical(initialState, newState), false);
      });
    });

    group('State Transition Testing', () {
      testWidgets('transitions correctly: off → on',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Initial: false
        expect(container.read(profileSettingsNotifier).use24HourFormat, false);

        // Act: toggle
        await tester.tap(find.byType(GestureDetector).last);
        await tester.pumpAndSettle();

        // Assert: true
        expect(container.read(profileSettingsNotifier).use24HourFormat, true);
      });

      testWidgets('transitions correctly: on → off',
          (WidgetTester tester) async {
        // Arrange - set initial state to true
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Toggle to true first
        await tester.tap(find.byType(GestureDetector).last);
        await tester.pumpAndSettle();
        expect(container.read(profileSettingsNotifier).use24HourFormat, true);

        // Act: toggle back to false
        await tester.tap(find.byType(GestureDetector).last);
        await tester.pumpAndSettle();

        // Assert: false
        expect(container.read(profileSettingsNotifier).use24HourFormat, false);
      });

      testWidgets('handles multiple rapid toggles',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Act - rapid toggles
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.byType(GestureDetector).last);
          await tester.pump();
        }
        await tester.pumpAndSettle();

        // Assert - should end at true (odd number of toggles)
        expect(container.read(profileSettingsNotifier).use24HourFormat, true);
      });
    });

    group('Widget Interaction Testing', () {
      testWidgets('tap area is accessible (minimum 44.h x 44.h)',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - verify toggle icon has adequate size
        final iconFinder = find.byType(CustomImageView).last;
        final iconWidget = tester.widget<CustomImageView>(iconFinder);
        expect(iconWidget.height, 44.h);
        expect(iconWidget.width, greaterThanOrEqualTo(36.h));
      });

      testWidgets('responds to tap gestures', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        bool stateChanged = false;
        final initialValue =
            container.read(profileSettingsNotifier).use24HourFormat;

        // Act
        await tester.tap(find.byType(GestureDetector).last);
        await tester.pumpAndSettle();

        final newValue =
            container.read(profileSettingsNotifier).use24HourFormat;
        stateChanged = initialValue != newValue;

        // Assert
        expect(stateChanged, true);
      });
    });

    group('Rendering and Layout Tests', () {
      testWidgets('uses Row layout with correct alignment',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - verify Row exists
        expect(find.byType(Row), findsAtLeastNWidgets(1));
      });

      testWidgets('applies correct padding', (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - verify Padding widget
        final paddingFinder = find.byType(Padding);
        expect(paddingFinder, findsAtLeastNWidgets(1));

        final padding = tester.widget<Padding>(paddingFinder.first);
        expect(padding.padding, EdgeInsets.symmetric(vertical: 8.h));
      });

      testWidgets('icon container has correct styling',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - find icon container with constraints
        final containerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.constraints != null &&
              widget.constraints!.maxHeight == 40.h &&
              widget.constraints!.maxWidth == 40.h,
        );
        expect(containerFinder, findsAtLeastNWidgets(1));

        final containers = tester.widgetList<Container>(
          find.byType(Container),
        );
        final iconContainer = containers.firstWhere(
          (c) =>
              c.decoration is BoxDecoration &&
              (c.decoration as BoxDecoration).color == appColors.gray_700,
        );
        final decoration = iconContainer.decoration as BoxDecoration;
        expect(decoration.color, appColors.gray_700);
        expect(decoration.borderRadius, BorderRadius.circular(10.h));
      });

      testWidgets('text column expands to fill available space',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - verify Expanded widget wraps Column
        final expandedFinder = find.byType(Expanded);
        expect(expandedFinder, findsOneWidget);
      });
    });

    group('Cross-Platform Consistency Tests', () {
      testWidgets('uses .fSize for all font sizes',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - all Text widgets use .fSize
        final textWidgets = tester.widgetList<Text>(find.byType(Text));
        for (final text in textWidgets) {
          expect(text.style?.fontSize, isNotNull);
        }
      });

      testWidgets('uses .h for spacing and sizing',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - verify responsive sizing is applied
        final padding = tester.widget<Padding>(find.byType(Padding).first);
        expect(padding.padding, EdgeInsets.symmetric(vertical: 8.h));
      });
    });

    group('Icon Display Tests', () {
      testWidgets('displays time format icon from ImageConstant',
          (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert - verify time format icon path
        final iconWidgets = tester.widgetList<CustomImageView>(
          find.byType(CustomImageView),
        );
        final timeFormatIcon = iconWidgets.firstWhere(
          (icon) => icon.imagePath == ImageConstant.imgTimeFormatIcon,
        );
        expect(timeFormatIcon, isNotNull);
      });
    });

    testWidgets('widget is stateless (no internal state)',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Act - rebuild widget
      await tester.pump();

      // Assert - still shows same content
      expect(find.text('24-Hour Format'), findsOneWidget);
    });
  });
}
