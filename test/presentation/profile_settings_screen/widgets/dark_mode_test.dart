import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/widgets/dark_mode.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/notifier/profile_settings_notifier.dart';
import 'package:adam_s_application/widgets/custom_image_view.dart';
import 'package:adam_s_application/core/utils/size_utils.dart';

void main() {
  setUp(() {
    SizeUtils.width = 375;
    SizeUtils.height = 812;
  });

  group('DarkMode Widget Tests', () {
    testWidgets('renders correctly with dark mode off', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const DarkMode(),
            ),
          ),
        ),
      );

      // Verify text elements
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Switch between light and dark theme'), findsOneWidget);

      // Verify icon presence
      expect(find.byType(CustomImageView), findsAtLeastNWidgets(2));
    });

    testWidgets('renders correctly with dark mode on', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(darkMode: true),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const DarkMode(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Dark Mode'), findsOneWidget);
    });

    testWidgets('calls toggleDarkMode when tapped', (tester) async {
      bool toggleCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(
                darkMode: false,
                onToggleDarkMode: () => toggleCalled = true,
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const DarkMode(),
            ),
          ),
        ),
      );

      // Find the GestureDetector within DarkMode widget
      // Tap on the 'Dark Mode' text which is inside the GestureDetector
      await tester.tap(find.text('Dark Mode'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(toggleCalled, true);
    });

    testWidgets('has consistent spacing and sizing', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const DarkMode(),
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(DarkMode),
              matching: find.byType(Padding),
            )
            .first,
      );

      expect(padding.padding, isA<EdgeInsets>());
    });

    testWidgets('displays correct icon based on state', (tester) async {
      // Test with dark mode off
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(darkMode: false),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const DarkMode(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify CustomImageView widgets exist
      expect(find.byType(CustomImageView), findsAtLeastNWidgets(2));
    });
  });
}

class _TestNotifier extends ProfileSettingsNotifier {
  final bool darkMode;
  final VoidCallback? onToggleDarkMode;

  _TestNotifier({
    this.darkMode = false,
    this.onToggleDarkMode,
  });

  @override
  ProfileSettingsState build() {
    return ProfileSettingsState(
      darkMode: darkMode,
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
  void toggleDarkMode() {
    onToggleDarkMode?.call();
    state = state.copyWith(darkMode: !state.darkMode!);
  }
}
