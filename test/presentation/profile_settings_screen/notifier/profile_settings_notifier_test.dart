import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/notifier/profile_settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adam_s_application/notifier/theme_notifier.dart';

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
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileSettingsNotifier Tests', () {
    late ProviderContainer container;

    setUp(() {
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

      // Wait for microtask to complete
      await Future.microtask(() {});

      final state = container.read(profileSettingsNotifier);

      expect(state.darkMode, true);
      expect(state.hijriCalendar, false);
      expect(state.prayerReminders, true);
      expect(state.selectedLanguage, 'English');
      expect(state.selectedLocation, 'Stockholm, Sweden');
      expect(state.locationDropdownOpen, false);
      expect(state.languageDropdownOpen, false);
      expect(state.searchQuery, '');
      expect(state.scrollPosition, 0.0);
    });

    test('toggleDarkMode changes dark mode state', () async {
      final notifier = container.read(profileSettingsNotifier.notifier);

      // Wait for initialization
      await Future.microtask(() {});

      // First toggle: true -> false
      notifier.toggleDarkMode();
      var state = container.read(profileSettingsNotifier);
      expect(state.darkMode, false);

      // Second toggle: false -> true
      notifier.toggleDarkMode();
      state = container.read(profileSettingsNotifier);
      expect(state.darkMode, true);
    });

    test('toggleHijriCalendar changes hijri calendar state', () {
      final notifier = container.read(profileSettingsNotifier.notifier);

      notifier.toggleHijriCalendar();
      var state = container.read(profileSettingsNotifier);
      expect(state.hijriCalendar, true);

      notifier.toggleHijriCalendar();
      state = container.read(profileSettingsNotifier);
      expect(state.hijriCalendar, false);
    });

    test('togglePrayerReminders changes prayer reminders state', () {
      final notifier = container.read(profileSettingsNotifier.notifier);

      notifier.togglePrayerReminders();
      var state = container.read(profileSettingsNotifier);
      expect(state.prayerReminders, false);

      notifier.togglePrayerReminders();
      state = container.read(profileSettingsNotifier);
      expect(state.prayerReminders, true);
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

    test('selectLocation updates selected location and closes dropdown', () {
      final notifier = container.read(profileSettingsNotifier.notifier);

      // Open dropdown first
      notifier.toggleLocationDropdown();

      notifier.selectLocation('Berlin, Germany');
      final state = container.read(profileSettingsNotifier);

      expect(state.selectedLocation, 'Berlin, Germany');
      expect(state.locationDropdownOpen, false);
      expect(state.searchQuery, ''); // Should clear search
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
      final notifier = container.read(profileSettingsNotifier.notifier);

      // Wait for initialization
      await Future.microtask(() {});

      // Change multiple settings
      notifier.toggleDarkMode();
      notifier.toggleHijriCalendar();
      notifier.togglePrayerReminders();
      notifier.selectLocation('Paris, France');
      notifier.selectLanguage('Arabic');

      // Verify changes
      var state = container.read(profileSettingsNotifier);
      expect(state.darkMode, false); // Started true, toggled to false
      expect(state.hijriCalendar, true); // Started false, toggled to true
      expect(state.prayerReminders, false); // Started true, toggled to false
      expect(state.selectedLocation, 'Paris, France');
      expect(state.selectedLanguage, 'Arabic');

      // Sign out - currently just prints debug message, doesn't reset state
      notifier.signOut();

      // Verify state is unchanged (signOut doesn't reset state yet)
      state = container.read(profileSettingsNotifier);
      expect(state.darkMode, false);
      expect(state.hijriCalendar, true);
      expect(state.prayerReminders, false);
      expect(state.selectedLocation, 'Paris, France');
      expect(state.selectedLanguage, 'Arabic');
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
      final notifier = container.read(profileSettingsNotifier.notifier);

      // Wait for initialization
      await Future.microtask(() {});

      // Toggle all settings multiple times
      // Initial: darkMode=true, hijri=false, prayer=true
      for (int i = 0; i < 3; i++) {
        notifier.toggleDarkMode();
        notifier.toggleHijriCalendar();
        notifier.togglePrayerReminders();
      }
      // After 3 toggles: darkMode=false, hijri=true, prayer=false

      final state = container.read(profileSettingsNotifier);
      expect(state.darkMode, false); // true -> false -> true -> false
      expect(state.hijriCalendar, true); // false -> true -> false -> true
      expect(state.prayerReminders, false); // true -> false -> true -> false
    });

    test('state maintains immutability', () async {
      final notifier = container.read(profileSettingsNotifier.notifier);

      // Wait for initialization
      await Future.microtask(() {});

      final initialState = container.read(profileSettingsNotifier);

      notifier.toggleDarkMode();
      final newState = container.read(profileSettingsNotifier);

      // States should be different objects
      expect(identical(initialState, newState), false);
      // Original state should be unchanged from initial (true)
      expect(initialState.darkMode, true);
      expect(initialState.darkMode, true);
      // New state should reflect change (toggled to false)
      expect(newState.darkMode, false);
    });
  });
}
