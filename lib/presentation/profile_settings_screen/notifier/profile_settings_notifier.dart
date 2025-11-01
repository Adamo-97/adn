import 'package:flutter/material.dart';
import '../models/profile_settings_model.dart';
import '../../../core/app_export.dart';
import '../../../../notifier/theme_notifier.dart';

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
      locationDropdownOpen: false,
      languageDropdownOpen: false,
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

  void toggleLanguageDropdown() {
    state = state.copyWith(
      languageDropdownOpen: !(state.languageDropdownOpen ?? false),
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
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
      searchQuery: '',
      scrollPosition: 0.0,
      resetTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
