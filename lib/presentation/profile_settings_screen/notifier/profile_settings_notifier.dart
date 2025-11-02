import 'package:flutter/material.dart';
import '../models/profile_settings_model.dart';
import '../../../core/app_export.dart';
import '../../../../notifier/theme_notifier.dart';
import '../../../services/prayer_times/prayer_times.dart';

part 'profile_settings_state.dart';

final profileSettingsNotifier =
    NotifierProvider.autoDispose<ProfileSettingsNotifier, ProfileSettingsState>(
  () => ProfileSettingsNotifier(),
);

class ProfileSettingsNotifier extends Notifier<ProfileSettingsState> {
  @override
  ProfileSettingsState build() {
    final initialState = ProfileSettingsState(
      profileSettingsModel: ProfileSettingsModel(),
    );
    Future.microtask(() => initialize());
    return initialState;
  }

  void initialize() {
    state = state.copyWith(
      darkMode: true,
      hijriCalendar: false,
      selectedLocation: 'Stockholm, Sweden',
      selectedLanguage: 'English',
      prayerReminders: true,
      use24HourFormat: false,
      locationDropdownOpen: false,
      languageDropdownOpen: false,
      selectedIslamicSchool: 0, // Standard
      selectedCalculationMethod: 3, // Muslim World League
      islamicSchoolDropdownOpen: false,
      calculationMethodDropdownOpen: false,
    );
  }

  void toggleDarkMode() {
    final newDarkMode = !(state.darkMode ?? false);
    state = state.copyWith(
      darkMode: newDarkMode,
    );

    // Also update the global theme provider so the app theme switches
    // immediately when the user toggles the setting in profile.
    ref
        .read(themeNotifierProvider.notifier)
        .setMode(newDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleHijriCalendar() {
    state = state.copyWith(
      hijriCalendar: !(state.hijriCalendar ?? false),
    );
  }

  void toggleLocationDropdown() {
    state = state.copyWith(
      locationDropdownOpen: !(state.locationDropdownOpen ?? false),
    );
  }

  void selectLocation(String location) {
    state = state.copyWith(
      selectedLocation: location,
      locationDropdownOpen: false,
    );
  }

  void selectLanguage(String language) {
    state = state.copyWith(
      selectedLanguage: language,
      languageDropdownOpen: false,
    );
  }

  void togglePrayerReminders() {
    state = state.copyWith(
      prayerReminders: !(state.prayerReminders ?? false),
    );
  }

  void toggle24HourFormat() {
    state = state.copyWith(
      use24HourFormat: !(state.use24HourFormat ?? false),
    );
  }

  void toggleLanguageDropdown() {
    state = state.copyWith(
      languageDropdownOpen: !(state.languageDropdownOpen ?? false),
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateCalculationMethodSearchQuery(String query) {
    state = state.copyWith(calculationMethodSearchQuery: query);
  }

  void toggleIslamicSchoolDropdown() {
    state = state.copyWith(
      islamicSchoolDropdownOpen: !(state.islamicSchoolDropdownOpen ?? false),
    );
  }

  void selectIslamicSchool(int school) {
    state = state.copyWith(
      selectedIslamicSchool: school,
      islamicSchoolDropdownOpen: false,
    );

    // Clear prayer times cache when settings change
    _clearPrayerTimesCache();
  }

  void toggleCalculationMethodDropdown() {
    state = state.copyWith(
      calculationMethodDropdownOpen:
          !(state.calculationMethodDropdownOpen ?? false),
    );
  }

  void selectCalculationMethod(int method) {
    state = state.copyWith(
      selectedCalculationMethod: method,
      calculationMethodDropdownOpen: false,
    );

    // Clear prayer times cache when settings change
    _clearPrayerTimesCache();
  }

  /// Clear prayer times cache when location or calculation settings change
  ///
  /// This forces the app to re-fetch prayer times with updated parameters
  /// on the next prayer tracker screen load.
  void _clearPrayerTimesCache() {
    final service = ref.read(prayerTimesServiceProvider);
    service.clearCache();
  }

  void signOut() {
    // TODO: Implement sign-out logic (clear auth, navigate to login, etc.)
    debugPrint('Sign out requested');
  }

  /// Reset state to initial when navigating away
  void resetState() {
    state = state.copyWith(
      locationDropdownOpen: false,
      languageDropdownOpen: false,
      islamicSchoolDropdownOpen: false,
      calculationMethodDropdownOpen: false,
      searchQuery: '',
      calculationMethodSearchQuery: '',
      scrollPosition: 0.0,
      resetTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
