part of 'profile_settings_notifier.dart';

class ProfileSettingsState extends Equatable {
  final ProfileSettingsModel? profileSettingsModel;
  final bool? darkMode;
  final bool? hijriCalendar;
  final String? selectedLocation;
  final String? selectedLanguage;
  final bool? prayerReminders;
  final bool? locationDropdownOpen;
  final bool? languageDropdownOpen;
  final String searchQuery;
  final double scrollPosition;
  final int resetTimestamp; // Forces state change on reset

  const ProfileSettingsState({
    this.profileSettingsModel,
    this.darkMode,
    this.hijriCalendar,
    this.selectedLocation,
    this.selectedLanguage,
    this.prayerReminders,
    this.locationDropdownOpen,
    this.languageDropdownOpen,
    this.searchQuery = '',
    this.scrollPosition = 0.0,
    this.resetTimestamp = 0,
  });

  @override
  List<Object?> get props => [
        profileSettingsModel,
        darkMode,
        hijriCalendar,
        selectedLocation,
        selectedLanguage,
        prayerReminders,
        locationDropdownOpen,
        languageDropdownOpen,
        searchQuery,
        scrollPosition,
        resetTimestamp,
      ];

  ProfileSettingsState copyWith({
    ProfileSettingsModel? profileSettingsModel,
    bool? darkMode,
    bool? hijriCalendar,
    String? selectedLocation,
    String? selectedLanguage,
    bool? prayerReminders,
    bool? locationDropdownOpen,
    bool? languageDropdownOpen,
    String? searchQuery,
    double? scrollPosition,
    int? resetTimestamp,
  }) {
    return ProfileSettingsState(
      profileSettingsModel: profileSettingsModel ?? this.profileSettingsModel,
      darkMode: darkMode ?? this.darkMode,
      hijriCalendar: hijriCalendar ?? this.hijriCalendar,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      prayerReminders: prayerReminders ?? this.prayerReminders,
      locationDropdownOpen: locationDropdownOpen ?? this.locationDropdownOpen,
      languageDropdownOpen: languageDropdownOpen ?? this.languageDropdownOpen,
      searchQuery: searchQuery ?? this.searchQuery,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      resetTimestamp: resetTimestamp ?? this.resetTimestamp,
    );
  }
}
