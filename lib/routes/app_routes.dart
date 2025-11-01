import 'package:flutter/material.dart';
import '../presentation/prayer_tracker_screen/prayer_tracker_screen.dart';
import '../presentation/salah_guide_screen/salah_guide_screen.dart';
import '../presentation/nearby_mosques_screen/nearby_mosques_screen.dart';
import '../presentation/profile_settings_screen/profile_settings_screen.dart';
import '../presentation/full_analytics_screen/full_analytics_screen.dart';

class AppRoutes {
  static const String prayerTrackerScreen = '/prayer_tracker_screen';
  static const String prayerTrackerScreenInitialPage =
      '/prayer_tracker_screen_initial_page';
  static const String salahGuideScreen = '/salah_guide_screen';
  static const String nearbyMosquesScreen = '/nearby_mosques_screen';
  static const String profileSettingsScreen = '/profile_settings_screen';
  static const String fullAnalyticsScreen = '/full_analytics_screen';
  static const String infoPageScreen = '/info_page_screen';

  static const String initialRoute = '/';

  static Map<String, WidgetBuilder> get routes => {
        prayerTrackerScreen: (context) => PrayerTrackerScreen(),
        salahGuideScreen: (context) => SalahGuideScreen(),
        nearbyMosquesScreen: (context) => NearbyMosquesScreen(),
        profileSettingsScreen: (context) => ProfileSettingsScreen(),
        fullAnalyticsScreen: (context) => FullAnalyticsScreen(),
        // Note: infoPageScreen requires parameters, use Navigator.push instead
        initialRoute: (context) => PrayerTrackerScreen()
      };
}
