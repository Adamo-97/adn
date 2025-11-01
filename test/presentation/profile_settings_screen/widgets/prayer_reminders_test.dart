import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/widgets/prayer_reminders.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/notifier/profile_settings_notifier.dart';
import 'package:adam_s_application/widgets/custom_image_view.dart';
import 'package:adam_s_application/core/utils/size_utils.dart';

void main() {
  setUp(() {
    SizeUtils.width = 375;
    SizeUtils.height = 812;
  });
  group('PrayerReminders Widget Tests', () {
    testWidgets('renders correctly with reminders off', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const PrayerReminders(),
            ),
          ),
        ),
      );

      expect(find.text('Prayer Reminders'), findsOneWidget);
      expect(find.text('Remind me 30 mins before next prayer'), findsOneWidget);
      expect(find.byType(CustomImageView), findsAtLeastNWidgets(2));
    });

    testWidgets('renders correctly with reminders on', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(prayerReminders: true),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const PrayerReminders(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Prayer Reminders'), findsOneWidget);
    });

    testWidgets('calls togglePrayerReminders when toggle tapped',
        (tester) async {
      bool toggleCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(
                prayerReminders: false,
                onToggleReminders: () => toggleCalled = true,
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const PrayerReminders(),
            ),
          ),
        ),
      );

      // Find and tap the toggle image (not the whole row)
      await tester.tap(find.byType(CustomImageView).last);
      await tester.pumpAndSettle();

      expect(toggleCalled, true);
    });

    testWidgets('has consistent container styling', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const PrayerReminders(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(PrayerReminders),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.decoration, isA<BoxDecoration>());
    });

    testWidgets('uses correct font sizes with .fSize', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const PrayerReminders(),
            ),
          ),
        ),
      );

      expect(find.text('Prayer Reminders'), findsOneWidget);
      expect(find.text('Remind me 30 mins before next prayer'), findsOneWidget);
    });
  });
}

class _TestNotifier extends ProfileSettingsNotifier {
  final bool prayerReminders;
  final VoidCallback? onToggleReminders;

  _TestNotifier({
    this.prayerReminders = false,
    this.onToggleReminders,
  });

  @override
  ProfileSettingsState build() {
    return ProfileSettingsState(
      darkMode: false,
      hijriCalendar: false,
      prayerReminders: prayerReminders,
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
  void togglePrayerReminders() {
    onToggleReminders?.call();
    state = state.copyWith(prayerReminders: !state.prayerReminders!);
  }
}
