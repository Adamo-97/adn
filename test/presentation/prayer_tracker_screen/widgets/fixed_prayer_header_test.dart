import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/widgets/fixed_prayer_header.dart';

/// Comprehensive test suite for FixedPrayerHeader widget following project testing standards.
/// Tests cover rendering, sizing, layout, colors, and cross-platform consistency.
void main() {
  group('FixedPrayerHeader Widget Tests', () {
    /// Helper to wrap widget with MaterialApp and Sizer for testing.
    Widget buildTestWidget({
      required double topInset,
      required double totalHeight,
    }) {
      return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  FixedPrayerHeader(
                    topInset: topInset,
                    totalHeight: totalHeight,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    testWidgets('renders correctly with all required elements',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        buildTestWidget(topInset: 40.0, totalHeight: 100.0),
      );

      // Assert - verify title text is present
      expect(find.text('Prayers'), findsOneWidget);

      // Assert - verify container is positioned correctly
      final positionedFinder = find.byType(Positioned);
      expect(positionedFinder, findsOneWidget);
    });

    testWidgets('displays title with correct text style',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        buildTestWidget(topInset: 40.0, totalHeight: 100.0),
      );
      await tester.pumpAndSettle();

      // Assert - verify text widget
      final textWidget = tester.widget<Text>(find.text('Prayers'));
      expect(textWidget.style?.fontSize, 22.fSize);
      expect(textWidget.style?.fontWeight, FontWeight.w700);
      expect(textWidget.style?.color, appColors.whiteA700);
      expect(textWidget.textAlign, TextAlign.center);
    });

    testWidgets('applies correct positioning constraints',
        (WidgetTester tester) async {
      // Arrange
      const testTopInset = 45.0;
      const testTotalHeight = 120.0;

      // Act
      await tester.pumpWidget(
        buildTestWidget(
          topInset: testTopInset,
          totalHeight: testTotalHeight,
        ),
      );

      // Assert - verify positioned widget properties
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.top, 0);
      expect(positioned.left, 0);
      expect(positioned.right, 0);
      expect(positioned.height, testTotalHeight);
    });

    group('Boundary Value Analysis - Height Tests', () {
      testWidgets('handles minimum height (edge case)',
          (WidgetTester tester) async {
        // Arrange & Act - minimum realistic height
        await tester.pumpWidget(
          buildTestWidget(topInset: 0.0, totalHeight: 50.0),
        );
        await tester.pumpAndSettle();

        // Assert - widget renders without errors
        expect(find.text('Prayers'), findsOneWidget);
      });

      testWidgets('handles maximum height (edge case)',
          (WidgetTester tester) async {
        // Arrange & Act - large height value
        await tester.pumpWidget(
          buildTestWidget(topInset: 100.0, totalHeight: 500.0),
        );
        await tester.pumpAndSettle();

        // Assert - widget renders without errors
        expect(find.text('Prayers'), findsOneWidget);
      });

      testWidgets('handles standard height (normal case)',
          (WidgetTester tester) async {
        // Arrange & Act - typical production height
        await tester.pumpWidget(
          buildTestWidget(topInset: 40.0, totalHeight: 100.0),
        );
        await tester.pumpAndSettle();

        // Assert - widget renders correctly
        expect(find.text('Prayers'), findsOneWidget);
      });
    });

    testWidgets('applies correct background color and border',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        buildTestWidget(topInset: 40.0, totalHeight: 100.0),
      );
      await tester.pumpAndSettle();

      // Assert - find the container
      final containerFinder = find.descendant(
        of: find.byType(Positioned),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsOneWidget);

      // Assert - verify container decoration
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, appColors.gray_900);
      expect(decoration.border, isA<Border>());

      final border = decoration.border as Border;
      expect(border.bottom.color, appColors.gray_700.withValues(alpha: 0.3));
      expect(border.bottom.width, 1.0);
    });

    testWidgets('applies correct padding with responsive sizing',
        (WidgetTester tester) async {
      // Arrange
      const testTopInset = 50.0;

      // Act
      await tester.pumpWidget(
        buildTestWidget(topInset: testTopInset, totalHeight: 110.0),
      );
      await tester.pumpAndSettle();

      // Assert - verify container padding
      final containerFinder = find.descendant(
        of: find.byType(Positioned),
        matching: find.byType(Container),
      );
      final container = tester.widget<Container>(containerFinder);

      expect(
        container.padding,
        EdgeInsets.fromLTRB(20.h, testTopInset + 16.h, 20.h, 16.h),
      );
    });

    testWidgets('header is centered horizontally', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        buildTestWidget(topInset: 40.0, totalHeight: 100.0),
      );
      await tester.pumpAndSettle();

      // Assert - verify Center widget wraps the text
      final centerFinder = find.descendant(
        of: find.byType(Container),
        matching: find.byType(Center),
      );
      expect(centerFinder, findsOneWidget);
    });

    testWidgets('uses .fSize for font sizing (cross-platform consistency)',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        buildTestWidget(topInset: 40.0, totalHeight: 100.0),
      );
      await tester.pumpAndSettle();

      // Assert - verify .fSize is used (should be 22.fSize)
      final textWidget = tester.widget<Text>(find.text('Prayers'));
      // .fSize scales differently on Android vs iOS, but the value should be calculated
      expect(textWidget.style?.fontSize, isNotNull);
      expect(textWidget.style?.fontSize, 22.fSize);
    });

    testWidgets('header is stateless (no state changes)',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        buildTestWidget(topInset: 40.0, totalHeight: 100.0),
      );
      await tester.pumpAndSettle();

      // Act - pump again to simulate rebuild
      await tester.pump();

      // Assert - still shows same content
      expect(find.text('Prayers'), findsOneWidget);
    });

    group('Equivalence Partitioning - TopInset Tests', () {
      testWidgets('valid partition: zero topInset',
          (WidgetTester tester) async {
        // Arrange & Act - partition: topInset == 0
        await tester.pumpWidget(
          buildTestWidget(topInset: 0.0, totalHeight: 60.0),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Prayers'), findsOneWidget);
      });

      testWidgets('valid partition: normal topInset (20-50)',
          (WidgetTester tester) async {
        // Arrange & Act - partition: 20 <= topInset <= 50
        await tester.pumpWidget(
          buildTestWidget(topInset: 35.0, totalHeight: 95.0),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Prayers'), findsOneWidget);
      });

      testWidgets('valid partition: large topInset (>50)',
          (WidgetTester tester) async {
        // Arrange & Act - partition: topInset > 50
        await tester.pumpWidget(
          buildTestWidget(topInset: 80.0, totalHeight: 140.0),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Prayers'), findsOneWidget);
      });
    });

    testWidgets('matches design system color scheme',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        buildTestWidget(topInset: 40.0, totalHeight: 100.0),
      );
      await tester.pumpAndSettle();

      // Assert - verify colors match app theme
      final containerFinder = find.descendant(
        of: find.byType(Positioned),
        matching: find.byType(Container),
      );
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      // Background matches other page headers (gray_900)
      expect(decoration.color, appColors.gray_900);

      // Text color is white
      final textWidget = tester.widget<Text>(find.text('Prayers'));
      expect(textWidget.style?.color, appColors.whiteA700);

      // Border color with transparency
      final border = decoration.border as Border;
      expect(
        border.bottom.color,
        appColors.gray_700.withValues(alpha: 0.3),
      );
    });
  });
}
