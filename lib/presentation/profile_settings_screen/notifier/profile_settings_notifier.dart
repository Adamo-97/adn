import '../models/profile_settings_model.dart';
import '../../../core/app_export.dart';

part 'profile_settings_state.dart';

final profileSettingsNotifier = StateNotifierProvider.autoDispose<
    ProfileSettingsNotifier, ProfileSettingsState>(
  (ref) => ProfileSettingsNotifier(
    ProfileSettingsState(
      profileSettingsModel: ProfileSettingsModel(),
    ),
  ),
);

class ProfileSettingsNotifier extends StateNotifier<ProfileSettingsState> {
  ProfileSettingsNotifier(ProfileSettingsState state) : super(state) {
    initialize();
  }

  void initialize() {
    state = state.copyWith(
      darkMode: true,
      hijriCalendar: false,
      selectedLocation: 'Stockholm, Sweden',
      selectedLanguage: 'English',
      allNotifications: true,
      athanNotifications: true,
      prayerReminders: true,
      azkarNotifications: true,
      locationDropdownOpen: false,
    );
  }

  void toggleDarkMode() {
    state = state.copyWith(
      darkMode: !(state.darkMode ?? false),
    );
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
    );
  }

  void toggleAllNotifications() {
    state = state.copyWith(
      allNotifications: !(state.allNotifications ?? false),
    );
  }

  void toggleAthanNotifications() {
    state = state.copyWith(
      athanNotifications: !(state.athanNotifications ?? false),
    );
  }

  void togglePrayerReminders() {
    state = state.copyWith(
      prayerReminders: !(state.prayerReminders ?? false),
    );
  }

  void toggleAzkarNotifications() {
    state = state.copyWith(
      azkarNotifications: !(state.azkarNotifications ?? false),
    );
  }
}
