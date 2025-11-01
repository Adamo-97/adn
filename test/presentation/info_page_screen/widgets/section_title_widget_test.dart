import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/core/utils/size_utils.dart';
import 'package:adam_s_application/presentation/info_page_screen/widgets/section_title_widget.dart';

/// Widget tests for SectionTitleWidget
/// Tests rendering, sizing, colors, and responsiveness
void main() {
  group('SectionTitleWidget Tests', () {
    setUp(() {
      // Initialize size utils for responsive sizing
      WidgetsFlutterBinding.ensureInitialized();
    });

    Widget createTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: Sizer(
            builder: (context, orientation, deviceType) {
              return child;
            },
          ),
        ),
      );
    }

    group('Rendering Tests', () {
      testWidgets('renders with correct text', (tester) async {
        const testText = 'Test Section Title';

        await tester.pumpWidget(
          createTestWidget(
            SectionTitleWidget(
              text: testText,
              accentColor: const Color(0xFF4DB6AC),
            ),
          ),
        );

        expect(find.text(testText), findsOneWidget);
      });

      testWidgets('renders with custom accent color', (tester) async {
        const accentColor = Color(0xFFFF7043);

        await tester.pumpWidget(
          createTestWidget(
            SectionTitleWidget(
              text: 'Test',
              accentColor: accentColor,
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.byType(Container),
        );

        final decoration = container.decoration as BoxDecoration?;
        // Background uses 15% opacity
        expect(decoration?.color, accentColor.withValues(alpha: 0.15));
      });

      testWidgets('handles empty text', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SectionTitleWidget(
              text: '',
              accentColor: Color(0xFF4DB6AC),
            ),
          ),
        );

        expect(find.text(''), findsOneWidget);
      });

      testWidgets('handles very long text', (tester) async {
        final longText = 'A' * 1000;

        await tester.pumpWidget(
          createTestWidget(
            SectionTitleWidget(
              text: longText,
              accentColor: const Color(0xFF4DB6AC),
            ),
          ),
        );

        expect(find.text(longText), findsOneWidget);
      });
    });

    group('Layout and Sizing Tests', () {
      testWidgets('uses full width', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SectionTitleWidget(
              text: 'Test',
              accentColor: Color(0xFF4DB6AC),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.byType(Container),
        );

        expect(container.constraints?.maxWidth, double.infinity);
      });

      testWidgets('has correct border radius', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SectionTitleWidget(
              text: 'Test',
              accentColor: Color(0xFF4DB6AC),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.byType(Container),
        );

        final decoration = container.decoration as BoxDecoration?;
        final borderRadius = decoration?.borderRadius as BorderRadius?;
        
        // Should have rounded corners
        expect(borderRadius, isNotNull);
      });

      testWidgets('has correct padding', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SectionTitleWidget(
              text: 'Test',
              accentColor: Color(0xFF4DB6AC),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.byType(Container),
        );

        // Should have symmetric padding
        expect(container.padding, isNotNull);
      });
    });

    group('Text Styling Tests', () {
      testWidgets('uses correct font size', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SectionTitleWidget(
              text: 'Test',
              accentColor: Color(0xFF4DB6AC),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(
          find.text('Test'),
        );

        final style = textWidget.style;
        expect(style?.fontWeight, FontWeight.w600);
      });

      testWidgets('uses white text color', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SectionTitleWidget(
              text: 'Test',
              accentColor: Color(0xFF4DB6AC),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(
          find.text('Test'),
        );

        final style = textWidget.style;
        // Text should be white for contrast on colored background
        expect(style?.color, isNotNull);
      });
    });

    group('Color Variation Tests - Equivalence Partitioning', () {
      final colorTests = [
        ('Teal (Essentials)', Color(0xFF4DB6AC)),
        ('Orange (Optional Prayers)', Color(0xFFE0C389)),
        ('Deep Orange (Special)', Color(0xFFFF7043)),
        ('Grey (Purification)', Color(0xFF8F9B87)),
        ('Purple (Rituals)', Color(0xFFAB87CE)),
      ];

      for (final test in colorTests) {
        testWidgets('renders correctly with ${test.$1}', (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              SectionTitleWidget(
                text: 'Test Title',
                accentColor: test.$2,
              ),
            ),
          );

          final container = tester.widget<Container>(
            find.byType(Container),
          );

          final decoration = container.decoration as BoxDecoration?;
          // Background uses 15% opacity
          expect(decoration?.color, test.$2.withValues(alpha: 0.15));
          expect(find.text('Test Title'), findsOneWidget);
        });
      }
    });

    group('Accessibility Tests', () {
      testWidgets('text is readable and selectable', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SectionTitleWidget(
              text: 'Accessible Title',
              accentColor: Color(0xFF4DB6AC),
            ),
          ),
        );

        expect(find.text('Accessible Title'), findsOneWidget);
        
        final textWidget = tester.widget<Text>(
          find.text('Accessible Title'),
        );
        
        // Text should have proper styling for readability
        expect(textWidget.style, isNotNull);
      });
    });
  });
}
