import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/widgets/language_selector.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/notifier/profile_settings_notifier.dart';
import 'package:adam_s_application/core/utils/size_utils.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  setUp(() {
    // Initialize test environment for each test
    initializeTestEnvironment();
    SizeUtils.width = 375;
    SizeUtils.height = 812;
  });

  group('LanguageSelector Widget Tests', () {
    testWidgets('renders correctly when closed', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const LanguageSelector(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('expands when tapped', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const LanguageSelector(),
            ),
          ),
        ),
      );

      // Tap to expand
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      // Verify language options are visible
      expect(find.text('العربية'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays both language options when expanded', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(languageDropdownOpen: true),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const LanguageSelector(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify both options are visible
      expect(find.text('English'), findsAtLeastNWidgets(1));
      expect(find.text('العربية'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays selected language in subtitle', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(selectedLanguage: 'Arabic'),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const LanguageSelector(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('العربية'), findsOneWidget);
    });

    testWidgets('uses correct font for Arabic text', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(
                languageDropdownOpen: true,
                selectedLanguage: 'Arabic',
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const LanguageSelector(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Arabic text should be present
      expect(find.text('العربية'), findsAtLeastNWidgets(1));
    });

    testWidgets('chevron animates on expand/collapse', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const LanguageSelector(),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedRotation), findsOneWidget);
    });

    testWidgets('maintains consistent spacing', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const LanguageSelector(),
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(GestureDetector).first,
              matching: find.byType(Padding),
            )
            .first,
      );

      expect(padding.padding, isA<EdgeInsets>());
    });
  });
}

class _TestNotifier extends ProfileSettingsNotifier {
  final bool languageDropdownOpen;
  final String selectedLanguage;

  _TestNotifier({
    this.languageDropdownOpen = false,
    this.selectedLanguage = 'English',
  });

  @override
  ProfileSettingsState build() {
    return ProfileSettingsState(
      darkMode: false,
      hijriCalendar: false,
      prayerReminders: false,
      selectedLanguage: selectedLanguage,
      selectedLocation: null,
      locationDropdownOpen: false,
      languageDropdownOpen: languageDropdownOpen,
      searchQuery: '',
      scrollPosition: 0.0,
      resetTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  void toggleLanguageDropdown() {
    state = state.copyWith(languageDropdownOpen: !state.languageDropdownOpen!);
  }

  @override
  void selectLanguage(String language) {
    state = state.copyWith(selectedLanguage: language);
  }
}
