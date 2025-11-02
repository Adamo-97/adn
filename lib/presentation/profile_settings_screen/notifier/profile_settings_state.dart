part of 'profile_settings_notifier.dart';

class ProfileSettingsState extends Equatable {
  final ProfileSettingsModel? profileSettingsModel;
  final bool? darkMode;
  final bool? hijriCalendar;
  final String? selectedLocation;
  final String? selectedLanguage;
  final bool? prayerReminders;
  final bool? use24HourFormat;
  final bool? locationDropdownOpen;
  final bool? languageDropdownOpen;
  final int selectedIslamicSchool; // 0: Standard, 1: Hanafi
  final int selectedCalculationMethod; // 0-16 (see CalculationMethod model)
  final bool? islamicSchoolDropdownOpen;
  final bool? calculationMethodDropdownOpen;
  final String searchQuery; // For location search
  final String calculationMethodSearchQuery; // For calculation method search
  final double scrollPosition;
  final int resetTimestamp; // Forces state change on reset

  const ProfileSettingsState({
    this.profileSettingsModel,
    this.darkMode,
    this.hijriCalendar,
    this.selectedLocation,
    this.selectedLanguage,
    this.prayerReminders,
    this.use24HourFormat,
    this.locationDropdownOpen,
    this.languageDropdownOpen,
    this.selectedIslamicSchool = 0, // Default: Standard
    this.selectedCalculationMethod = 3, // Default: Muslim World League
    this.islamicSchoolDropdownOpen,
    this.calculationMethodDropdownOpen,
    this.searchQuery = '',
    this.calculationMethodSearchQuery = '',
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
        use24HourFormat,
        locationDropdownOpen,
        languageDropdownOpen,
        selectedIslamicSchool,
        selectedCalculationMethod,
        islamicSchoolDropdownOpen,
        calculationMethodDropdownOpen,
        searchQuery,
        calculationMethodSearchQuery,
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
    bool? use24HourFormat,
    bool? locationDropdownOpen,
    bool? languageDropdownOpen,
    int? selectedIslamicSchool,
    int? selectedCalculationMethod,
    bool? islamicSchoolDropdownOpen,
    bool? calculationMethodDropdownOpen,
    String? searchQuery,
    String? calculationMethodSearchQuery,
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
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      locationDropdownOpen: locationDropdownOpen ?? this.locationDropdownOpen,
      languageDropdownOpen: languageDropdownOpen ?? this.languageDropdownOpen,
      selectedIslamicSchool:
          selectedIslamicSchool ?? this.selectedIslamicSchool,
      selectedCalculationMethod:
          selectedCalculationMethod ?? this.selectedCalculationMethod,
      islamicSchoolDropdownOpen:
          islamicSchoolDropdownOpen ?? this.islamicSchoolDropdownOpen,
      calculationMethodDropdownOpen:
          calculationMethodDropdownOpen ?? this.calculationMethodDropdownOpen,
      searchQuery: searchQuery ?? this.searchQuery,
      calculationMethodSearchQuery:
          calculationMethodSearchQuery ?? this.calculationMethodSearchQuery,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      resetTimestamp: resetTimestamp ?? this.resetTimestamp,
    );
  }
}
