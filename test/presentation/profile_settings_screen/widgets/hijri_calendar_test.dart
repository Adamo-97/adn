import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/widgets/hijri_calendar.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/notifier/profile_settings_notifier.dart';
import 'package:adam_s_application/widgets/custom_image_view.dart';
import 'package:adam_s_application/core/utils/size_utils.dart';

void main() {
  setUp(() {
    SizeUtils.width = 375;
    SizeUtils.height = 812;
  });
  group('HijriCalendar Widget Tests', () {
    testWidgets('renders correctly with Hijri calendar off', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const HijriCalendar(),
            ),
          ),
        ),
      );

      expect(find.text('Hijri Calendar'), findsOneWidget);
      expect(find.text('Switch to Hijri calendar display'), findsOneWidget);
      expect(find.byType(CustomImageView), findsAtLeastNWidgets(2));
    });

    testWidgets('renders correctly with Hijri calendar on', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(hijriCalendar: true),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const HijriCalendar(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Hijri Calendar'), findsOneWidget);
    });

    testWidgets('calls toggleHijriCalendar when toggle tapped', (tester) async {
      bool toggleCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(
                hijriCalendar: false,
                onToggleHijri: () => toggleCalled = true,
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const HijriCalendar(),
            ),
          ),
        ),
      );

      // Find and tap the toggle image (not the whole row)
      await tester.tap(find.byType(CustomImageView).last);
      await tester.pumpAndSettle();

      expect(toggleCalled, true);
    });

    testWidgets('has rounded square container with correct styling',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const HijriCalendar(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(HijriCalendar),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('maintains consistent spacing', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const HijriCalendar(),
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(HijriCalendar),
              matching: find.byType(Padding),
            )
            .first,
      );

      expect(padding.padding, isA<EdgeInsets>());
    });
  });
}

class _TestNotifier extends ProfileSettingsNotifier {
  final bool hijriCalendar;
  final VoidCallback? onToggleHijri;

  _TestNotifier({
    this.hijriCalendar = false,
    this.onToggleHijri,
  });

  @override
  ProfileSettingsState build() {
    return ProfileSettingsState(
      darkMode: false,
      hijriCalendar: hijriCalendar,
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
  void toggleHijriCalendar() {
    onToggleHijri?.call();
    state = state.copyWith(hijriCalendar: !state.hijriCalendar!);
  }
}
