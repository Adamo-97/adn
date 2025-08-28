import '../../../core/app_export.dart';

/// This class is used in the [ProfileSettingsScreen] screen.

// ignore_for_file: must_be_immutable
class ProfileSettingsModel extends Equatable {
  ProfileSettingsModel({
    this.title,
    this.darkModeIcon,
    this.hijriCalendarIcon,
    this.locationIcon,
    this.languageIcon,
    this.notificationIcon,
    this.locations,
    this.languages,
    this.id,
  }) {
    title = title ?? 'Profile';
    darkModeIcon = darkModeIcon ?? ImageConstant.imgVectorWhiteA700;
    hijriCalendarIcon = hijriCalendarIcon ?? ImageConstant.imgCalendarIcon;
    locationIcon = locationIcon ?? ImageConstant.imgAppmodeIcon;
    languageIcon = languageIcon ?? ImageConstant.imgAppmodeIconWhiteA700;
    notificationIcon =
        notificationIcon ?? ImageConstant.imgAppmodeIconWhiteA70024x24;
    locations = locations ??
        [
          'Berlin, Germany',
          'Stockholm, Sweden',
          'Moscow, Russia',
          'Copenhagen, Denmark'
        ];
    languages = languages ?? ['English', 'العربية'];
    id = id ?? '';
  }

  String? title;
  String? darkModeIcon;
  String? hijriCalendarIcon;
  String? locationIcon;
  String? languageIcon;
  String? notificationIcon;
  List<String>? locations;
  List<String>? languages;
  String? id;

  ProfileSettingsModel copyWith({
    String? title,
    String? darkModeIcon,
    String? hijriCalendarIcon,
    String? locationIcon,
    String? languageIcon,
    String? notificationIcon,
    List<String>? locations,
    List<String>? languages,
    String? id,
  }) {
    return ProfileSettingsModel(
      title: title ?? this.title,
      darkModeIcon: darkModeIcon ?? this.darkModeIcon,
      hijriCalendarIcon: hijriCalendarIcon ?? this.hijriCalendarIcon,
      locationIcon: locationIcon ?? this.locationIcon,
      languageIcon: languageIcon ?? this.languageIcon,
      notificationIcon: notificationIcon ?? this.notificationIcon,
      locations: locations ?? this.locations,
      languages: languages ?? this.languages,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
        title,
        darkModeIcon,
        hijriCalendarIcon,
        locationIcon,
        languageIcon,
        notificationIcon,
        locations,
        languages,
        id,
      ];
}
