part of 'profile_settings_notifier.dart';

class ProfileSettingsState extends Equatable {
  final ProfileSettingsModel? profileSettingsModel;
  final bool? darkMode;
  final bool? hijriCalendar;
  final String? selectedLocation;
  final String? selectedLanguage;
  final bool? allNotifications;
  final bool? athanNotifications;
  final bool? prayerReminders;
  final bool? azkarNotifications;
  final bool? locationDropdownOpen;

  ProfileSettingsState({
    this.profileSettingsModel,
    this.darkMode,
    this.hijriCalendar,
    this.selectedLocation,
    this.selectedLanguage,
    this.allNotifications,
    this.athanNotifications,
    this.prayerReminders,
    this.azkarNotifications,
    this.locationDropdownOpen,
  });

  @override
  List<Object?> get props => [
        profileSettingsModel,
        darkMode,
        hijriCalendar,
        selectedLocation,
        selectedLanguage,
        allNotifications,
        athanNotifications,
        prayerReminders,
        azkarNotifications,
        locationDropdownOpen,
      ];

  ProfileSettingsState copyWith({
    ProfileSettingsModel? profileSettingsModel,
    bool? darkMode,
    bool? hijriCalendar,
    String? selectedLocation,
    String? selectedLanguage,
    bool? allNotifications,
    bool? athanNotifications,
    bool? prayerReminders,
    bool? azkarNotifications,
    bool? locationDropdownOpen,
  }) {
    return ProfileSettingsState(
      profileSettingsModel: profileSettingsModel ?? this.profileSettingsModel,
      darkMode: darkMode ?? this.darkMode,
      hijriCalendar: hijriCalendar ?? this.hijriCalendar,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      allNotifications: allNotifications ?? this.allNotifications,
      athanNotifications: athanNotifications ?? this.athanNotifications,
      prayerReminders: prayerReminders ?? this.prayerReminders,
      azkarNotifications: azkarNotifications ?? this.azkarNotifications,
      locationDropdownOpen: locationDropdownOpen ?? this.locationDropdownOpen,
    );
  }
}
