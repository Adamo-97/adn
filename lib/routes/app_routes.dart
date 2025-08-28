import 'package:flutter/material.dart';
import '../presentation/prayer_tracker_screen/prayer_tracker_screen.dart';
import '../presentation/purification_selection_screen/purification_selection_screen.dart';
import '../presentation/salah_guide_menu_screen/salah_guide_menu_screen.dart';
import '../presentation/azkhar_categories_screen/azkhar_categories_screen.dart';
import '../presentation/quran_main_screen/quran_main_screen.dart';
import '../presentation/profile_settings_screen/profile_settings_screen.dart';

import '../presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String prayerTrackerScreen = '/prayer_tracker_screen';
  static const String prayerTrackerScreenInitialPage =
      '/prayer_tracker_screen_initial_page';
  static const String purificationSelectionScreen =
      '/purification_selection_screen';
  static const String salahGuideMenuScreen = '/salah_guide_menu_screen';
  static const String azkharCategoriesScreen = '/azkhar_categories_screen';
  static const String quranMainScreen = '/quran_main_screen';
  static const String profileSettingsScreen = '/profile_settings_screen';

  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/';

  static Map<String, WidgetBuilder> get routes => {
        prayerTrackerScreen: (context) => PrayerTrackerScreen(),
        purificationSelectionScreen: (context) => PurificationSelectionScreen(),
        salahGuideMenuScreen: (context) => SalahGuideMenuScreen(),
        azkharCategoriesScreen: (context) => AzkharCategoriesScreen(),
        quranMainScreen: (context) => QuranMainScreen(),
        profileSettingsScreen: (context) => ProfileSettingsScreen(),
        appNavigationScreen: (context) => AppNavigationScreen(),
        initialRoute: (context) => AppNavigationScreen()
      };
}
