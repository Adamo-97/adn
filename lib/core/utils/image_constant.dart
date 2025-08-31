// lib/core/utils/image_constant.dart

// Prayer types for icons
enum PrayerType { fajr, sunrise, dhuhr, asr, maghrib, isha }

extension PrayerTypeAsset on PrayerType {
  String get icon {
    switch (this) {
      case PrayerType.fajr:    return ImageConstant.imgFajr;
      case PrayerType.sunrise: return ImageConstant.imgSunrise;
      case PrayerType.dhuhr:   return ImageConstant.imgDhuhr;
      case PrayerType.asr:     return ImageConstant.imgAsr;
      case PrayerType.maghrib: return ImageConstant.imgMaghrib;
      case PrayerType.isha:    return ImageConstant.imgIsha;
    }
  }
}

class ImageConstant {
  // Base path for all assets
  static String _basePath = 'assets/images/';
  // Placeholder image for fallback
  static String imgPlaceholder = '${_basePath}placeholder.png';
  

  // Six prayer SVGs — placed directly under assets/images/
  static String imgFajr    = '${_basePath}fajr.svg';
  static String imgSunrise = '${_basePath}sunrise.svg';
  static String imgDhuhr   = '${_basePath}dhuhr.svg';
  static String imgAsr     = '${_basePath}asr.svg';
  static String imgMaghrib = '${_basePath}maghrib.svg';
  static String imgIsha    = '${_basePath}isha.svg';

  static String iconForPrayer(Object current) {
    final key = current.toString().trim().toLowerCase();
    switch (key) {
      case 'fajr':    return imgFajr;
      case 'sunrise': return imgSunrise;
      case 'dhuhr':   return imgDhuhr;
      case 'asr':     return imgAsr;
      case 'maghrib': return imgMaghrib;
      case 'isha':    return imgIsha;
     default:
       // Show an obvious error image so it’s visible in UI.
       assert(() {
         // Helpful in debug to see what was passed.
         // ignore: avoid_print
         print('[iconForPrayer] Unknown key: "$key" -> using imgImageNotFound');
         return true;
       }());
       return imgImageNotFound;
  }
}


  // Common Images
  static String imgAfterPrayGroup = '${_basePath}img_after_pray_group.svg';
  static String imgArrowNext = '${_basePath}img_arrow_next.svg';
  static String imgArrowPrev = '${_basePath}img_arrow_prev.svg';
  static String imgCheck = '${_basePath}img_check.svg';
  static String imgCheckedIcon = '${_basePath}img_checked_icon.svg';
  static String imgCompassIcon = '${_basePath}img_compass_icon.svg';
  static String imgConditionsIcon = '${_basePath}img_conditions_icon.svg';
  static String imgDhuhrIcon = '${_basePath}img_dhuhr_icon.svg';
  static String imgGhuslIcon = '${_basePath}img_ghusl_icon.svg';
  static String imgGroup10 = '${_basePath}img_group_10.svg';
  static String imgHowToIcon = '${_basePath}img_how_to_icon.svg';
  static String imgHowToPrayGroup = '${_basePath}img_how_to_pray_group.svg';
  static String imgIconPlaceholder = '${_basePath}img_icon_placeholder.svg';
  static String imgIconPlaceholder1 = '${_basePath}img_icon_placeholder_1.svg';
  static String imgIconPlaceholder10 =
      '${_basePath}img_icon_placeholder_10.svg';
  static String imgIconPlaceholder11 =
      '${_basePath}img_icon_placeholder_11.svg';
  static String imgIconPlaceholder12 =
      '${_basePath}img_icon_placeholder_12.svg';
  static String imgIconPlaceholder13 =
      '${_basePath}img_icon_placeholder_13.svg';
  static String imgIconPlaceholder14 =
      '${_basePath}img_icon_placeholder_14.svg';
  static String imgIconPlaceholder2 = '${_basePath}img_icon_placeholder_2.svg';
  static String imgIconPlaceholder3 = '${_basePath}img_icon_placeholder_3.svg';
  static String imgIconPlaceholder30x30 =
      '${_basePath}img_icon_placeholder_30x30.svg';
  static String imgIconPlaceholder4 = '${_basePath}img_icon_placeholder_4.svg';
  static String imgIconPlaceholder5 = '${_basePath}img_icon_placeholder_5.svg';
  static String imgIconPlaceholder6 = '${_basePath}img_icon_placeholder_6.svg';
  static String imgIconPlaceholder7 = '${_basePath}img_icon_placeholder_7.svg';
  static String imgIconPlaceholder8 = '${_basePath}img_icon_placeholder_8.svg';
  static String imgIconPlaceholder9 = '${_basePath}img_icon_placeholder_9.svg';
  static String imgIconPlaceholderWhiteA700 =
      '${_basePath}img_icon_placeholder_white_a700.svg';
  static String imgIconPlaceholderWhiteA70030x30 =
      '${_basePath}img_icon_placeholder_white_a700_30x30.svg';
  static String imgIconPlaceholoder = '${_basePath}img_icon_placeholoder.svg';
  static String imgIconPplaceholder = '${_basePath}img_icon_pplaceholder.svg';
  static String imgImportantIcon = '${_basePath}img_important_icon.svg';
  static String imgLocationIcon = '${_basePath}img_location_icon.svg';
  static String imgMobileIcon = '${_basePath}img_mobile_icon.svg';
  static String imgNotificationOn = '${_basePath}img_notification_on.svg';
  static String imgPrayerTimes = '${_basePath}img_prayer_times.svg';
  static String imgQiblaButton = '${_basePath}img_qibla_button.svg';
  static String imgSearchWhiteA700 = '${_basePath}img_search_white_a700.svg';
  static String imgShadowButtom1 = '${_basePath}img_shadow_buttom_1.png';
  static String imgTayammumIcon = '${_basePath}img_tayammum_icon.svg';
  static String imgWhuduGroup = '${_basePath}img_whudu_group.svg';
  static String imgWuduIcon = '${_basePath}img_wudu_icon.svg';

  // Azkhar Categories Screen
  static String imgAddicon = '${_basePath}img_addicon.svg';
  static String imgFavoriteIconPlaceholder =
      '${_basePath}img_favorite_icon_placeholder.svg';
  static String imgGroup5 = '${_basePath}img_group_5.svg';
  static String imgSearchGray500 = '${_basePath}img_search_gray_500.svg';
  static String imgShadowButtom76x374 =
      '${_basePath}img_shadow_buttom_76x374.png';

  // Model Profile Settings Model Screen
  static String imgAppmodeIcon = '${_basePath}img_appmode_icon.svg';
  static String imgAppmodeIconWhiteA700 =
      '${_basePath}img_appmode_icon_white_a700.svg';
  static String imgAppmodeIconWhiteA70024x24 =
      '${_basePath}img_appmode_icon_white_a700_24x24.svg';
  static String imgCalendarIcon = '${_basePath}img_calendar_icon.svg';
  static String imgVectorWhiteA700 = '${_basePath}img_vector_white_a700.svg';

  // Prayer Tracker Screen
  static String imgDikrnavicon = '${_basePath}img_dikrnavicon.svg';
  static String imgPraynavicon = '${_basePath}img_praynavicon.svg';
  static String imgProfileNavIcon = '${_basePath}img_profile_nav_icon.svg';
  static String imgQuranNavIcon = '${_basePath}img_quran_nav_icon.svg';
  static String imgSubtract = '${_basePath}img_subtract.svg';

  // Profile Settings Screen
  static String imgArrowDown = '${_basePath}img_arrow_down.svg';
  static String imgArrowDownWhiteA700 =
      '${_basePath}img_arrow_down_white_a700.svg';
  static String imgCheckMark = '${_basePath}img_check_mark.svg';
  static String imgDropDownClick = '${_basePath}img_drop_down_click.svg';
  static String imgDropDownClickWhiteA700 =
      '${_basePath}img_drop_down_click_white_a700.svg';
  static String imgGroup3 = '${_basePath}img_group_3.svg';
  static String imgIconFrame = '${_basePath}img_icon_frame.svg';
  static String imgIconPlaceholderGray900 =
      '${_basePath}img_icon_placeholder_gray_900.svg';
  static String imgIconPlaceholderGray90024x24 =
      '${_basePath}img_icon_placeholder_gray_900_24x24.svg';
  static String imgSearchGray900 = '${_basePath}img_search_gray_900.svg';
  static String imgSelected = '${_basePath}img_selected.svg';
  static String imgShadowButtom2 = '${_basePath}img_shadow_buttom_2.png';
  static String imgStatusChecked = '${_basePath}img_status_checked.svg';
  static String imgStatusUnchecked = '${_basePath}img_status_unchecked.svg';
  static String imgUnselected = '${_basePath}img_unselected.svg';

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
  static String imgBgRectangel = '${_basePath}img_bg_rectangel.svg';
}
