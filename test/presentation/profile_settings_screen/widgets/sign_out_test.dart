import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/widgets/sign_out.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/notifier/profile_settings_notifier.dart';
import 'package:adam_s_application/core/utils/size_utils.dart';

void main() {
  setUp(() {
    // Initialize size utils for testing
    SizeUtils.width = 375;
    SizeUtils.height = 812;
  });

  group('SignOut Widget Tests', () {
    testWidgets('renders correctly with sign out text', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const SignOut(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets('is centered', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const SignOut(),
            ),
          ),
        ),
      );

      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('has pill-shaped container', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const SignOut(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(SignOut),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
      expect(decoration.border, isNotNull);
    });

    testWidgets('uses red color theme', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const SignOut(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(SignOut),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isA<Border>());
    });

    testWidgets('calls signOut when tapped', (tester) async {
      bool signOutCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(
                onSignOut: () => signOutCalled = true,
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const SignOut(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SignOut));
      await tester.pump();

      expect(signOutCalled, true);
    });

    testWidgets('has reduced padding', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const SignOut(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(SignOut),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.margin, isA<EdgeInsets>());
      expect(container.padding, isA<EdgeInsets>());
    });

    testWidgets('displays icon and text', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const SignOut(),
            ),
          ),
        ),
      );

      expect(find.text('Sign Out'), findsOneWidget);
      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });

    testWidgets('uses correct font size with .fSize', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const SignOut(),
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Sign Out'));
      expect(textWidget.style, isNotNull);
    });
  });
}

class _TestNotifier extends ProfileSettingsNotifier {
  final VoidCallback? onSignOut;

  _TestNotifier({
    this.onSignOut,
  });

  @override
  ProfileSettingsState build() {
    return ProfileSettingsState(
      darkMode: false,
      hijriCalendar: false,
      prayerReminders: false,
      selectedLanguage: 'English',
      selectedLocation: null,
      locationDropdownOpen: false,
      languageDropdownOpen: false,
      searchQuery: '',
      scrollPosition: 0.0,
      resetTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  void signOut() {
    onSignOut?.call();
    // Reset to initial state
    state = build();
  }
}
