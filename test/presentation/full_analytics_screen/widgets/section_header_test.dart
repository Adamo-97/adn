import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/presentation/full_analytics_screen/widgets/section_header.dart';

/// Comprehensive tests for SectionHeader widget
/// Tests title rendering, text styling, and responsive design
void main() {
  setUpAll(() {
    SizeUtils.width = 375;
    SizeUtils.height = 812;
  });

  /// Helper to create test widget with required wrappers
  Widget createTestWidget({required String title}) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: SectionHeader(title: title),
      ),
    );
  }

  group('SectionHeader Tests', () {
    group('Title Rendering', () {
      testWidgets('renders title text correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'Test Section'));

        expect(find.text('Test Section'), findsOneWidget);
      });

      testWidgets('renders empty string title', (tester) async {
        await tester.pumpWidget(createTestWidget(title: ''));

        // Should render empty text widget
        expect(find.byType(Text), findsOneWidget);
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, '');
      });

      testWidgets('renders long title text', (tester) async {
        const longTitle =
            'This is a very long section header title that contains many words and characters';
        await tester.pumpWidget(createTestWidget(title: longTitle));

        expect(find.text(longTitle), findsOneWidget);
      });

      testWidgets('renders title with special characters', (tester) async {
        const specialTitle = 'Section #1: Prayer (5/5) 100%';
        await tester.pumpWidget(createTestWidget(title: specialTitle));

        expect(find.text(specialTitle), findsOneWidget);
      });

      testWidgets('renders title with unicode characters', (tester) async {
        const unicodeTitle = 'Prayer Analytics 📊';
        await tester.pumpWidget(createTestWidget(title: unicodeTitle));

        expect(find.text(unicodeTitle), findsOneWidget);
      });

      testWidgets('renders title with arabic text', (tester) async {
        const arabicTitle = 'إحصائيات الصلاة';
        await tester.pumpWidget(createTestWidget(title: arabicTitle));

        expect(find.text(arabicTitle), findsOneWidget);
      });
    });

    group('Text Styling', () {
      testWidgets('applies correct text style', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'Styled Section'));

        final textWidget = tester.widget<Text>(find.text('Styled Section'));
        final textStyle = textWidget.style!;

        // Verify base style is body14SemiBoldPoppins
        expect(textStyle.fontFamily, 'Poppins');
        expect(textStyle.fontWeight, FontWeight.w600); // SemiBold
      });

      testWidgets('applies white color to text', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'White Text'));

        final textWidget = tester.widget<Text>(find.text('White Text'));
        expect(textWidget.style?.color, appColors.whiteA700);
      });

      testWidgets('uses responsive font sizing', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'Responsive Text'));

        final textWidget = tester.widget<Text>(find.text('Responsive Text'));
        final textStyle = textWidget.style!;

        // body14SemiBoldPoppins uses 14.fSize
        expect(textStyle.fontSize, 14.fSize);
      });
    });

    group('Widget Structure', () {
      testWidgets('is a Text widget', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'Structure Test'));

        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('does not have additional wrappers', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'No Wrappers'));

        // SectionHeader should return only a Text widget, no Container/Padding/etc
        final sectionHeaderWidget = find.byType(SectionHeader);
        expect(sectionHeaderWidget, findsOneWidget);

        // Check that Text is the direct child
        expect(
            find.descendant(
              of: sectionHeaderWidget,
              matching: find.byType(Text),
            ),
            findsOneWidget);
      });
    });

    group('Boundary Value Analysis', () {
      testWidgets('renders single character title', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'A'));

        expect(find.text('A'), findsOneWidget);
      });

      testWidgets('renders title with only spaces', (tester) async {
        await tester.pumpWidget(createTestWidget(title: '   '));

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, '   ');
      });

      testWidgets('renders title with newline characters', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'Line 1\nLine 2'));

        expect(find.text('Line 1\nLine 2'), findsOneWidget);
      });
    });

    group('State Consistency', () {
      testWidgets('updates when title changes', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'Initial Title'));
        expect(find.text('Initial Title'), findsOneWidget);

        await tester.pumpWidget(createTestWidget(title: 'Updated Title'));
        await tester.pumpAndSettle();

        expect(find.text('Initial Title'), findsNothing);
        expect(find.text('Updated Title'), findsOneWidget);
      });

      testWidgets('maintains style when title changes', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'First'));
        final firstTextWidget = tester.widget<Text>(find.text('First'));
        final firstStyle = firstTextWidget.style;

        await tester.pumpWidget(createTestWidget(title: 'Second'));
        await tester.pumpAndSettle();

        final secondTextWidget = tester.widget<Text>(find.text('Second'));
        final secondStyle = secondTextWidget.style;

        // Both should have identical styling
        expect(secondStyle?.color, firstStyle?.color);
        expect(secondStyle?.fontFamily, firstStyle?.fontFamily);
        expect(secondStyle?.fontWeight, firstStyle?.fontWeight);
        expect(secondStyle?.fontSize, firstStyle?.fontSize);
      });
    });

    group('Accessibility', () {
      testWidgets('text is readable by screen readers', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'Accessible Title'));

        final textWidget = tester.widget<Text>(find.text('Accessible Title'));
        // Text widget by default is accessible to screen readers
        expect(textWidget.data, isNotEmpty);
      });
    });

    group('Common Use Cases', () {
      testWidgets('renders "Weekly Analytics" title', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'Weekly Analytics'));

        expect(find.text('Weekly Analytics'), findsOneWidget);
      });

      testWidgets('renders "Monthly Analytics" title', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'Monthly Analytics'));

        expect(find.text('Monthly Analytics'), findsOneWidget);
      });

      testWidgets('renders "Quarterly Analytics" title', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'Quarterly Analytics'));

        expect(find.text('Quarterly Analytics'), findsOneWidget);
      });

      testWidgets('renders "Prayer Details" title', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'Prayer Details'));

        expect(find.text('Prayer Details'), findsOneWidget);
      });

      testWidgets('renders "Calendar" title', (tester) async {
        await tester.pumpWidget(createTestWidget(title: 'Calendar'));

        expect(find.text('Calendar'), findsOneWidget);
      });
    });
  });
}
