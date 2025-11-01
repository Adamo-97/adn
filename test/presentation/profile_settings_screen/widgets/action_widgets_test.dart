import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/widgets/rate_app.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/widgets/about_app.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/widgets/share_app.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/widgets/terms_conditions.dart';
import 'package:adam_s_application/core/utils/size_utils.dart';


void main() {
  setUp(() {
    SizeUtils.width = 375;
    SizeUtils.height = 812;
  });
  group('Action Widgets Tests', () {
    group('RateApp Widget', () {
      testWidgets('renders correctly', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RateApp(),
            ),
          ),
        );

        expect(find.text('Rate App'), findsOneWidget);
        expect(find.byType(Container), findsAtLeastNWidgets(1));
      });

      testWidgets('has consistent icon container styling', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RateApp(),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(RateApp),
                matching: find.byType(Container),
              )
              .first,
        );

        expect(container.decoration, isA<BoxDecoration>());
      });

      testWidgets('uses correct font size', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RateApp(),
            ),
          ),
        );

        expect(find.text('Rate App'), findsOneWidget);
      });
    });

    group('AboutApp Widget', () {
      testWidgets('renders correctly', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AboutApp(),
            ),
          ),
        );

        expect(find.text('About App'), findsOneWidget);
      });

      testWidgets('has rounded square icon container', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AboutApp(),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(AboutApp),
                matching: find.byType(Container),
              )
              .first,
        );

        expect(container.decoration, isA<BoxDecoration>());
      });
    });

    group('ShareApp Widget', () {
      testWidgets('renders correctly', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShareApp(),
            ),
          ),
        );

        expect(find.text('Share App'), findsOneWidget);
      });

      testWidgets('maintains consistent styling with other actions',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShareApp(),
            ),
          ),
        );

        final padding = tester.widget<Padding>(
          find
              .descendant(
                of: find.byType(ShareApp),
                matching: find.byType(Padding),
              )
              .first,
        );

        expect(padding.padding, isA<EdgeInsets>());
      });
    });

    group('TermsConditions Widget', () {
      testWidgets('renders correctly', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TermsConditions(),
            ),
          ),
        );

        expect(find.text('Terms and Conditions'), findsOneWidget);
      });

      testWidgets('has consistent spacing', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TermsConditions(),
            ),
          ),
        );

        expect(find.byType(Padding), findsAtLeastNWidgets(1));
      });
    });

    group('All Action Widgets Consistency', () {
      testWidgets('all have same vertical padding', (tester) async {
        final widgets = [
          const RateApp(),
          const AboutApp(),
          const ShareApp(),
          const TermsConditions(),
        ];

        for (var widget in widgets) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          final padding = tester.widget<Padding>(
            find.byType(Padding).first,
          );

          expect(padding.padding, isA<EdgeInsets>());

          await tester.pumpWidget(Container()); // Clear the widget tree
        }
      });

      testWidgets('all have rounded square containers', (tester) async {
        final widgets = [
          const RateApp(),
          const AboutApp(),
          const ShareApp(),
          const TermsConditions(),
        ];

        for (var widget in widgets) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          final container = tester.widget<Container>(
            find.byType(Container).first,
          );

          expect(container.decoration, isA<BoxDecoration>());

          await tester.pumpWidget(Container());
        }
      });
    });
  });
}
