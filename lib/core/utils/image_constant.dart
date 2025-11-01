// lib/core/utils/image_constant.dart

// Prayer types for icons
enum PrayerType { fajr, sunrise, dhuhr, asr, maghrib, isha }

extension PrayerTypeAsset on PrayerType {
  String get icon {
    switch (this) {
      case PrayerType.fajr:
        return ImageConstant.imgFajr;
      case PrayerType.sunrise:
        return ImageConstant.imgSunrise;
      case PrayerType.dhuhr:
        return ImageConstant.imgDhuhr;
      case PrayerType.asr:
        return ImageConstant.imgAsr;
      case PrayerType.maghrib:
        return ImageConstant.imgMaghrib;
      case PrayerType.isha:
        return ImageConstant.imgIsha;
    }
  }
}

class ImageConstant {
  // Base path for all assets
  static final String _basePath = 'assets/images/';
  static final String _homePath = 'assets/images/home/';
  static final String _mosquesPath = 'assets/images/mosques/';
  static final String _profilePath = 'assets/images/profile/';
  // Placeholder image for fallback
  static String imgPlaceholder = '${_basePath}placeholder.png';

  // Notification bell states
  static const String bellAdhan = 'assets/images/notifications/bell_adhan.svg';
  static const String bellPling = 'assets/images/notifications/bell_pling.svg';
  static const String bellMute = 'assets/images/notifications/bell_mute.svg';

  // Six prayer SVGs — organized in home/ subdirectory
  static String imgFajr = '${_homePath}fajr.svg';
  static String imgSunrise = '${_homePath}sunrise.svg';
  static String imgDhuhr = '${_homePath}dhuhr.svg';
  static String imgAsr = '${_homePath}asr.svg';
  static String imgMaghrib = '${_homePath}maghrib.svg';
  static String imgIsha = '${_homePath}isha.svg';

  static String iconForPrayer(Object current) {
    final key = current.toString().trim().toLowerCase();
    switch (key) {
      case 'fajr':
        return imgFajr;
      case 'sunrise':
        return imgSunrise;
      case 'dhuhr':
        return imgDhuhr;
      case 'asr':
        return imgAsr;
      case 'maghrib':
        return imgMaghrib;
      case 'isha':
        return imgIsha;
      default:
        // Show an obvious error image so it’s visible in UI.
        assert(() {
          // Helpful in debug to see what was passed.
          // ignore: avoid_print
          print(
              '[iconForPrayer] Unknown key: "$key" -> using imgImageNotFound');
          return true;
        }());
        return imgImageNotFound;
    }
  }

  // Common Images - Home/Prayer Tracker
  static String imgArrowNext = '${_homePath}img_arrow_next.svg';
  static String imgArrowPrev = '${_homePath}img_arrow_prev.svg';
  static String imgCheck = '${_homePath}img_check.svg';
  static String imgCheckedIcon = '${_basePath}img_checked_icon.svg';
  static String imgCompassIcon = '${_homePath}img_compass_icon.svg';
  static String imgConditionsIcon =
      '${_basePath}salah_guide/img_conditions_icon.svg';
  static String imgDhuhrIcon = '${_basePath}img_dhuhr_icon.svg';
  static String imgGhuslIcon = '${_basePath}img_ghusl_icon.svg';
  static String imgGroup10 = '${_basePath}img_group_10.svg';
  static String imgHowToIcon = '${_basePath}salah_guide/img_how_to_icon.svg';
  static String imgIconPlaceholder = '${_basePath}img_icon_placeholder.svg';
  static String imgIconPlaceholder1 = '${_basePath}img_icon_placeholder_1.svg';
  static String imgIconPlaceholder10 =
      '${_basePath}salah_guide/img_icon_placeholder_10.svg';
  static String imgIconPlaceholder11 =
      '${_basePath}salah_guide/img_icon_placeholder_11.svg';
  static String imgIconPlaceholder12 =
      '${_basePath}salah_guide/img_icon_placeholder_12.svg';
  static String imgIconPlaceholder13 =
      '${_basePath}salah_guide/img_icon_placeholder_13.svg';
  static String imgIconPlaceholder14 =
      '${_basePath}salah_guide/img_icon_placeholder_14.svg';
  static String imgIconPlaceholder2 = '${_basePath}img_icon_placeholder_2.svg';
  static String imgIconPlaceholder3 = '${_basePath}img_icon_placeholder_3.svg';
  static String imgIconPlaceholder30x30 =
      '${_basePath}img_icon_placeholder_30x30.svg';
  static String imgIconPlaceholder4 = '${_basePath}img_icon_placeholder_4.svg';
  static String imgIconPlaceholder5 =
      '${_basePath}salah_guide/img_icon_placeholder_5.svg';
  static String imgIconPlaceholder6 =
      '${_basePath}salah_guide/img_icon_placeholder_6.svg';
  static String imgIconPlaceholder7 =
      '${_basePath}salah_guide/img_icon_placeholder_7.svg';
  static String imgIconPlaceholder8 =
      '${_basePath}salah_guide/img_icon_placeholder_8.svg';
  static String imgIconPlaceholder9 =
      '${_basePath}salah_guide/img_icon_placeholder_9.svg';
  static String imgIconPlaceholderWhiteA700 =
      '${_basePath}img_icon_placeholder_white_a700.svg';
  static String imgIconPlaceholderWhiteA70030x30 =
      '${_basePath}img_icon_placeholder_white_a700_30x30.svg';
  static String imgIconPlaceholoder =
      '${_basePath}salah_guide/img_icon_placeholoder.svg';
  static String imgIconPplaceholder = '${_basePath}img_icon_pplaceholder.svg';
  static String imgImportantIcon =
      '${_basePath}salah_guide/img_important_icon.svg';
  static String imgLocationIcon = '${_homePath}img_location_icon.svg';
  static String imgMobileIcon = '${_homePath}img_mobile_icon.svg';
  static String imgPrayerTimes = '${_basePath}salah_guide/img_prayer_times.svg';
  static String imgQiblaButton = '${_homePath}img_qibla_button_unselected.svg';
  static String imgQiblaButtonSelected =
      '${_homePath}img_qibla_button_selected.svg';

  // Stats buttons - Weekly (7 days), Monthly (30 days), Quarterly (90 days)
  static String imgWeeklyStat = '${_homePath}weekly_stat.svg';
  static String imgWeeklyStatSelected = '${_homePath}weekly_stat_selected.svg';
  static String imgMonthlyStat = '${_homePath}monthly_stat.svg';
  static String imgMonthlyStatSelected =
      '${_homePath}monthly_stat_selected.svg';
  static String imgQuadStat = '${_homePath}quad_stat.svg';
  static String imgQuadStatSelected = '${_homePath}quad_stat_selected.svg';

  static String imgSearchWhiteA700 = '${_basePath}img_search_white_a700.svg';
  static String imgShadowButtom1 = '${_basePath}img_shadow_buttom_1.png';
  static String imgTayammumIcon = '${_basePath}img_tayammum_icon.svg';
  static String imgWuduIcon = '${_basePath}img_wudu_icon.svg';

  // Salah Guide Screen
  static String imgAddicon = '${_basePath}img_addicon.svg';
  static String imgFavoriteIconPlaceholder =
      '${_basePath}img_favorite_icon_placeholder.svg';
  static String imgGroup5 = '${_basePath}img_group_5.svg';
  static String imgSearchGray500 = '${_basePath}img_search_gray_500.svg';
  static String imgShadowButtom76x374 =
      '${_basePath}img_shadow_buttom_76x374.png';

  // Model Profile Settings Model Screen
  static String imgAppmodeIcon = '${_profilePath}img_appmode_icon.svg';
  static String imgAppmodeIconWhiteA700 =
      '${_profilePath}img_appmode_icon_white_a700.svg';
  static String imgAppmodeIconWhiteA70024x24 =
      '${_profilePath}img_appmode_icon_white_a700_24x24.svg';
  static String imgCalendarIcon = '${_profilePath}img_calendar_icon.svg';
  static String imgVectorWhiteA700 = '${_profilePath}img_vector_white_a700.svg';

  // Prayer Tracker Screen
  static String imgDikrnavicon = '${_basePath}img_dikrnavicon.svg';
  static String imgPraynavicon = '${_basePath}img_praynavicon.svg';
  static String imgProfileNavIcon = '${_basePath}img_profile_nav_icon.svg';
  static String imgMosqueNavIcon = '${_mosquesPath}mosque_near_icon.svg';
  static String imgSubtract = '${_basePath}img_subtract.svg';

  // Nearby Mosques Screen
  static String imgSearchButton = '${_mosquesPath}search_button.svg';
  static String imgOpenMapIcon = '${_mosquesPath}open_map_icon.svg';
  static String imgMinMaxButton = '${_mosquesPath}min_max_button.svg';
  static String imgLocationButton = '${_mosquesPath}location_button.svg';
  static String imgDivider = '${_mosquesPath}devider.svg';
  static String imgMapPlaceholder = '${_mosquesPath}MAP_EXAMPLE.jpg';

  // Profile Settings Screen
  static String imgArrowDown = '${_profilePath}img_arrow_down.svg';
  static String imgArrowDownWhiteA700 =
      '${_profilePath}img_arrow_down_white_a700.svg';
  static String imgCheckMark = '${_profilePath}img_check_mark.svg';
  static String imgDropDownClick = '${_profilePath}img_drop_down_click.svg';
  static String imgDropDownClickWhiteA700 =
      '${_profilePath}img_drop_down_click_white_a700.svg';
  static String imgGroup3 = '${_profilePath}img_group_3.svg';
  static String imgIconFrame = '${_profilePath}img_icon_frame.svg';
  static String imgIconPlaceholderGray900 =
      '${_profilePath}img_icon_placeholder_gray_900.svg';
  static String imgIconPlaceholderGray90024x24 =
      '${_profilePath}img_icon_placeholder_gray_900_24x24.svg';
  static String imgSearchGray900 = '${_basePath}img_search_gray_900.svg';
  static String imgSelected = '${_profilePath}img_selected.svg';
  static String imgStatusChecked = '${_profilePath}img_status_checked.svg';
  static String imgStatusUnchecked = '${_profilePath}img_status_unchecked.svg';
  static String imgUnselected = '${_profilePath}img_unselected.svg';
  static String imgSignOutIcon = '${_profilePath}sign_out_icon.svg';

  // Purification Selection Screen
  static String imgBackButton = '${_basePath}img_back_button.svg';

  // Quran Main Screen
  static String imgGroup1 = '${_basePath}img_group_1.svg';
  static String imgIcons = '${_basePath}img_icons.svg';
  static String imgIconsWhiteA700 = '${_basePath}img_icons_white_a700.svg';
  static String imgSearch = '${_basePath}img_search.svg';
  static String imgShadowButtom = '${_basePath}img_shadow_buttom.png';
  static String imgVector = '${_basePath}img_vector.svg';

  // Salah Guide Menu Screen
  // Custom Image View Screen
  static String imgImageNotFound = '${_basePath}image_not_found.png';
  // Surah Item Widget Screen
}
