import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/notifier/profile_settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adam_s_application/notifier/theme_notifier.dart';
import '../../../helpers/test_helpers.dart';

// Mock ThemeNotifier that doesn't require SharedPreferences
class _MockThemeNotifier extends ThemeNotifier {
  @override
  ThemeMode build() => ThemeMode.dark;

  @override
  void setMode(ThemeMode mode) {
    state = mode;
  }
}

void main() {
  group('ProfileSettingsNotifier Tests', () {
    late ProviderContainer container;

    setUp(() {
      // Initialize test environment for each test
      initializeTestEnvironment();

      container = ProviderContainer(
        overrides: [
          // Override themeNotifierProvider to avoid SharedPreferences dependency
          themeNotifierProvider.overrideWith(() => _MockThemeNotifier()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state has correct default values', () async {
      // Trigger provider creation
      container.read(profileSettingsNotifier);

      // Wait for microtask to complete (initialization)
      await Future.microtask(() {});
      await Future.delayed(
          Duration(milliseconds: 100)); // Give time for async initialize

      final state = container.read(profileSettingsNotifier);

      expect(state.darkMode, true);
      expect(state.hijriCalendar, false);
      expect(state.prayerReminders, true);
      expect(state.selectedLanguage, 'English');
      expect(state.selectedLocation,
          'Mecca, Saudi Arabia'); // Updated to match SettingsStorageService default
      expect(state.locationDropdownOpen, false);
      expect(state.languageDropdownOpen, false);
      expect(state.searchQuery, '');
      expect(state.scrollPosition, 0.0);
    });

    test('toggleDarkMode changes dark mode state', () async {
      // Keep provider alive by maintaining a listener
      final subscription = container.listen(
        profileSettingsNotifier,
        (_, __) {},
      );

      final notifier = container.read(profileSettingsNotifier.notifier);

      // Wait for initialization to complete
      await Future.delayed(Duration(milliseconds: 150));

      // Get initial state
      var initialState = container.read(profileSettingsNotifier);
      var initialDarkMode = initialState.darkMode ?? false;

      // First toggle
      notifier.toggleDarkMode();
      await Future.delayed(Duration(milliseconds: 50)); // Wait for state update
      var state = container.read(profileSettingsNotifier);
      expect(state.darkMode, !initialDarkMode);

      // Second toggle
      notifier.toggleDarkMode();
      await Future.delayed(Duration(milliseconds: 50)); // Wait for state update
      state = container.read(profileSettingsNotifier);
      expect(state.darkMode, initialDarkMode);

      subscription.close();
    });

    test('toggleHijriCalendar changes hijri calendar state', () async {
      // Keep provider alive by maintaining a listener
      final subscription = container.listen(
        profileSettingsNotifier,
        (_, __) {},
      );

      final notifier = container.read(profileSettingsNotifier.notifier);

      // Wait for initialization to complete
      await Future.delayed(Duration(milliseconds: 150));

      notifier.toggleHijriCalendar();
      await Future.delayed(Duration(milliseconds: 50)); // Wait for state update
      var state = container.read(profileSettingsNotifier);
      expect(state.hijriCalendar, true);

      notifier.toggleHijriCalendar();
      await Future.delayed(Duration(milliseconds: 50)); // Wait for state update
      state = container.read(profileSettingsNotifier);
      expect(state.hijriCalendar, false);

      subscription.close();
    });

    test('togglePrayerReminders changes prayer reminders state', () async {
      // Keep provider alive by maintaining a listener
      final subscription = container.listen(
        profileSettingsNotifier,
        (_, __) {},
      );

      final notifier = container.read(profileSettingsNotifier.notifier);

      // Wait for initialization to complete
      await Future.delayed(Duration(milliseconds: 150));

      notifier.togglePrayerReminders();
      await Future.delayed(Duration(milliseconds: 50)); // Wait for state update
      var state = container.read(profileSettingsNotifier);
      expect(state.prayerReminders, false); // Was true by default, now false

      notifier.togglePrayerReminders();
      await Future.delayed(Duration(milliseconds: 50)); // Wait for state update
      state = container.read(profileSettingsNotifier);
      expect(state.prayerReminders, true); // Back to true

      subscription.close();
    });

    test('toggleLocationDropdown changes location dropdown state', () {
      final notifier = container.read(profileSettingsNotifier.notifier);

      notifier.toggleLocationDropdown();
      var state = container.read(profileSettingsNotifier);
      expect(state.locationDropdownOpen, true);

      notifier.toggleLocationDropdown();
      state = container.read(profileSettingsNotifier);
      expect(state.locationDropdownOpen, false);
    });

    test('toggleLanguageDropdown changes language dropdown state', () {
      final notifier = container.read(profileSettingsNotifier.notifier);

      notifier.toggleLanguageDropdown();
      var state = container.read(profileSettingsNotifier);
      expect(state.languageDropdownOpen, true);

      notifier.toggleLanguageDropdown();
      state = container.read(profileSettingsNotifier);
      expect(state.languageDropdownOpen, false);
    });

    test('selectLocation updates selected location and closes dropdown',
        () async {
      // Keep provider alive by maintaining a listener
      final subscription = container.listen(
        profileSettingsNotifier,
        (_, __) {},
      );

      final notifier = container.read(profileSettingsNotifier.notifier);

      // Wait for initialization to complete
      await Future.delayed(Duration(milliseconds: 150));

      // Open dropdown first
      notifier.toggleLocationDropdown();

      notifier.selectLocation('Berlin, Germany');
      await Future.delayed(Duration(milliseconds: 50)); // Wait for state update
      final state = container.read(profileSettingsNotifier);

      expect(state.selectedLocation, 'Berlin, Germany');
      expect(state.locationDropdownOpen, false);

      subscription.close();
    });

    test('selectLanguage updates selected language and closes dropdown', () {
      final notifier = container.read(profileSettingsNotifier.notifier);

      // Open dropdown first
      notifier.toggleLanguageDropdown();

      notifier.selectLanguage('Arabic');
      final state = container.read(profileSettingsNotifier);

      expect(state.selectedLanguage, 'Arabic');
      expect(state.languageDropdownOpen, false);
    });

    test('updateSearchQuery updates search query', () {
      final notifier = container.read(profileSettingsNotifier.notifier);

      notifier.updateSearchQuery('berlin');
      var state = container.read(profileSettingsNotifier);
      expect(state.searchQuery, 'berlin');

      notifier.updateSearchQuery('london');
      state = container.read(profileSettingsNotifier);
      expect(state.searchQuery, 'london');
    });

    test('signOut prints debug message', () async {
      // Keep provider alive by maintaining a listener
      final subscription = container.listen(
        profileSettingsNotifier,
        (_, __) {},
      );

      final notifier = container.read(profileSettingsNotifier.notifier);

      // Wait for initialization to complete
      await Future.delayed(Duration(milliseconds: 150));

      // Get initial states
      var initialState = container.read(profileSettingsNotifier);
      var initialDarkMode = initialState.darkMode ?? false;

      // Change multiple settings
      notifier.toggleDarkMode();
      await Future.delayed(Duration(milliseconds: 50));
      notifier.toggleHijriCalendar();
      await Future.delayed(Duration(milliseconds: 50));
      notifier.togglePrayerReminders();
      await Future.delayed(Duration(milliseconds: 50));
      notifier.selectLocation('Paris, France');
      await Future.delayed(Duration(milliseconds: 50));
      notifier.selectLanguage('Arabic');
      await Future.delayed(Duration(milliseconds: 50));

      // Verify changes
      var state = container.read(profileSettingsNotifier);
      expect(state.darkMode, !initialDarkMode);
      expect(state.hijriCalendar, true); // Started false, toggled to true
      expect(state.prayerReminders, false); // Started true, toggled to false
      expect(state.selectedLocation, 'Paris, France');
      expect(state.selectedLanguage, 'Arabic');

      // Sign out - currently just prints debug message, doesn't reset state
      notifier.signOut();

      // Verify state is unchanged (signOut doesn't reset state yet)
      state = container.read(profileSettingsNotifier);
      expect(state.darkMode, !initialDarkMode);
      expect(state.hijriCalendar, true);
      expect(state.prayerReminders, false);
      expect(state.selectedLocation, 'Paris, France');
      expect(state.selectedLanguage, 'Arabic');

      subscription.close();
    });

    test('closing dropdown does not clear search query', () {
      final notifier = container.read(profileSettingsNotifier.notifier);

      // Open dropdown and search
      notifier.toggleLocationDropdown();
      notifier.updateSearchQuery('test');

      var state = container.read(profileSettingsNotifier);
      expect(state.searchQuery, 'test');

      // Close dropdown
      notifier.toggleLocationDropdown();

      state = container.read(profileSettingsNotifier);
      expect(state.searchQuery,
          'test'); // Currently not cleared (could be improved)
      expect(state.locationDropdownOpen, false);
    });

    test('multiple toggles work correctly', () async {
      // Keep provider alive by maintaining a listener
      final subscription = container.listen(
        profileSettingsNotifier,
        (_, __) {},
      );

      final notifier = container.read(profileSettingsNotifier.notifier);

      // Wait for initialization to complete
      await Future.delayed(Duration(milliseconds: 150));

      // Get initial state
      var initialState = container.read(profileSettingsNotifier);
      var initialDarkMode = initialState.darkMode ?? false;

      // Toggle all settings multiple times
      for (int i = 0; i < 3; i++) {
        notifier.toggleDarkMode();
        await Future.delayed(Duration(milliseconds: 50));
        notifier.toggleHijriCalendar();
        await Future.delayed(Duration(milliseconds: 50));
        notifier.togglePrayerReminders();
        await Future.delayed(Duration(milliseconds: 50));
      }
      // After 3 toggles: values flip 3 times (odd number)

      final state = container.read(profileSettingsNotifier);
      expect(state.darkMode, !initialDarkMode); // Flipped 3 times (odd)
      expect(state.hijriCalendar, true); // false -> true -> false -> true
      expect(state.prayerReminders, false); // true -> false -> true -> false

      subscription.close();
    });

    test('state maintains immutability', () async {
      // Keep provider alive by maintaining a listener
      final subscription = container.listen(
        profileSettingsNotifier,
        (_, __) {},
      );

      final notifier = container.read(profileSettingsNotifier.notifier);

      // Wait for initialization to complete
      await Future.delayed(Duration(milliseconds: 150));

      final initialState = container.read(profileSettingsNotifier);
      var initialDarkMode = initialState.darkMode ?? false;

      notifier.toggleDarkMode();
      await Future.delayed(Duration(milliseconds: 50));
      final newState = container.read(profileSettingsNotifier);

      // States should be different objects
      expect(identical(initialState, newState), false);
      // Original state should be unchanged
      expect(initialState.darkMode, initialDarkMode);
      // New state should reflect change (toggled)
      expect(newState.darkMode, !initialDarkMode);

      subscription.close();
    });
  });
}
