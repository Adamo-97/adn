import 'package:flutter/material.dart';
import '../models/profile_settings_model.dart';
import '../../../core/app_export.dart';
import '../../../../notifier/theme_notifier.dart';
import '../../../services/prayer_times/prayer_times.dart';
import '../../../services/settings_storage_service.dart';
import '../../../services/location_service.dart';

part 'profile_settings_state.dart';

final profileSettingsNotifier =
    NotifierProvider.autoDispose<ProfileSettingsNotifier, ProfileSettingsState>(
  () => ProfileSettingsNotifier(),
);

class ProfileSettingsNotifier extends Notifier<ProfileSettingsState> {
  late final SettingsStorageService _storage;
  late final LocationService _locationService;

  @override
  ProfileSettingsState build() {
    _storage = SettingsStorageService();
    _locationService = LocationService();

    // Set sensible defaults immediately (will be overwritten by initialize())
    final initialState = ProfileSettingsState(
      profileSettingsModel: ProfileSettingsModel(),
      darkMode: true,
      hijriCalendar: false,
      use24HourFormat: false,
      prayerReminders: true,
      selectedLocation: 'Mecca, Saudi Arabia',
      selectedLanguage: 'English',
      locationDropdownOpen: false,
      languageDropdownOpen: false,
      islamicSchoolDropdownOpen: false,
      calculationMethodDropdownOpen: false,
      selectedIslamicSchool: 0,
      selectedCalculationMethod: 4,
      searchQuery: '',
      calculationMethodSearchQuery: '',
      scrollPosition: 0.0,
      resetTimestamp: 0,
    );
    Future.microtask(() => initialize());
    return initialState;
  }

  /// Initialize settings from persistent storage
  ///
  /// 1. Loads all settings from SharedPreferences
  /// 2. Attempts to auto-detect location if not previously set
  /// 3. Updates state with loaded/detected values
  Future<void> initialize() async {
    // Initialize storage service
    final storageInitialized = await _storage.initialize();
    if (!storageInitialized) {
      debugPrint('Failed to initialize settings storage, using defaults');
    }

    // Check if provider is still mounted after async operation
    if (!ref.mounted) return;

    // Load settings from storage
    final darkMode = _storage.darkMode;
    final hijriCalendar = _storage.hijriCalendar;
    final use24HourFormat = _storage.use24HourFormat;
    final prayerReminders = _storage.prayerReminders;
    final location = _storage.location;
    final calculationMethod = _storage.calculationMethod;
    final islamicSchool = _storage.islamicSchool;

    // Attempt auto-location detection if location hasn't been customized
    String finalLocation = location;
    if (!_storage.isLocationCustomized()) {
      final locationResult = await _locationService.getCurrentLocation();
      // Check again after async operation
      if (!ref.mounted) return;

      if (locationResult.success && locationResult.location != null) {
        finalLocation = locationResult.location!;
        // Save detected location
        await _storage.setLocation(finalLocation);
        // Check again after async operation
        if (!ref.mounted) return;
      }
    }

    // Update state with loaded settings
    state = state.copyWith(
      darkMode: darkMode,
      hijriCalendar: hijriCalendar,
      use24HourFormat: use24HourFormat,
      prayerReminders: prayerReminders,
      selectedLocation: finalLocation,
      selectedCalculationMethod: calculationMethod,
      selectedIslamicSchool: islamicSchool,
      selectedLanguage: 'English', // Not persisted yet
      locationDropdownOpen: false,
      languageDropdownOpen: false,
      islamicSchoolDropdownOpen: false,
      calculationMethodDropdownOpen: false,
    );

    // Update global theme to match loaded dark mode setting
    ref.read(themeNotifierProvider.notifier).setMode(
          darkMode ? ThemeMode.dark : ThemeMode.light,
        );
  }

  void toggleDarkMode() {
    final newDarkMode = !(state.darkMode ?? false);
    state = state.copyWith(
      darkMode: newDarkMode,
    );

    // Persist to storage
    _storage.setDarkMode(newDarkMode);

    // Also update the global theme provider so the app theme switches
    // immediately when the user toggles the setting in profile.
    ref
        .read(themeNotifierProvider.notifier)
        .setMode(newDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleHijriCalendar() {
    final newValue = !(state.hijriCalendar ?? false);
    state = state.copyWith(
      hijriCalendar: newValue,
    );

    // Persist to storage
    _storage.setHijriCalendar(newValue);
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

    // Persist to storage
    _storage.setLocation(location);

    // Clear prayer times cache when location changes
    _clearPrayerTimesCache();
  }

  /// Detect location using GPS and update settings
  ///
  /// Returns true if location was successfully detected and updated.
  /// Returns false if detection failed (permission denied, service disabled, etc.)
  Future<bool> detectLocation() async {
    final result = await _locationService.getCurrentLocation();

    if (result.success && result.location != null) {
      final location = result.location!;

      // Update state
      state = state.copyWith(
        selectedLocation: location,
        locationDropdownOpen: false,
      );

      // Persist to storage
      await _storage.setLocation(location);

      // Clear prayer times cache since location changed
      _clearPrayerTimesCache();

      return true;
    } else {
      // Show error message to user (could be via snackbar in UI)
      debugPrint('Location detection failed: ${result.errorMessage}');
      return false;
    }
  }

  void selectLanguage(String language) {
    state = state.copyWith(
      selectedLanguage: language,
      languageDropdownOpen: false,
    );
  }

  void togglePrayerReminders() {
    final newValue = !(state.prayerReminders ?? false);
    state = state.copyWith(
      prayerReminders: newValue,
    );

    // Persist to storage
    _storage.setPrayerReminders(newValue);
  }

  void toggle24HourFormat() {
    final newValue = !(state.use24HourFormat ?? false);
    state = state.copyWith(
      use24HourFormat: newValue,
    );

    // Persist to storage
    _storage.setUse24HourFormat(newValue);
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

    // Persist to storage
    _storage.setIslamicSchool(school);

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

    // Persist to storage
    _storage.setCalculationMethod(method);

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
