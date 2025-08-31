import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../azkhar_categories_screen/azkhar_categories_screen.dart';
import '../profile_settings_screen/profile_settings_screen.dart';
import '../quran_main_screen/quran_main_screen.dart';
import './prayer_tracker_initial_page.dart';

class PrayerTrackerScreen extends ConsumerStatefulWidget {
  const PrayerTrackerScreen({Key? key}) : super(key: key);

  @override
  PrayerTrackerScreenState createState() => PrayerTrackerScreenState();
}

class PrayerTrackerScreenState extends ConsumerState {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Navigator(
          key: navigatorKey,
          initialRoute: AppRoutes.prayerTrackerScreenInitialPage,
          onGenerateRoute: (routeSetting) => PageRouteBuilder(
            pageBuilder: (ctx, a1, a2) =>
                getCurrentPage(context, routeSetting.name!),
            transitionDuration: Duration.zero,
          ),
        ),
      ),
      // ✅ Bottom bar fills the whole bottom; only top corners rounded.
      // Outer wrapper uses DARK bg so the rounded corners match the page.
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: false, // fill under the home indicator instead of padding above it
        child: Container(
          color: appTheme.gray_900, // #212121 — page/dark background
          child: Container(
            // OLIVE bar with only top corners rounded; no clipping so raised
            // circle/icon are never cropped.
            decoration: BoxDecoration(
              color: const Color(0xFF5C6248), // olive bar
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.h),
                topRight: Radius.circular(16.h),
                // ⛔ no bottom radius — bar fills the very bottom edge
              ),
            ),
            child: SizedBox(
              width: double.maxFinite,
              child: _buildBottomBar(context), // inner bar is transparent
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final items = [
      CustomBottomBarItem(
        icon: ImageConstant.imgPraynavicon,
        routeName: AppRoutes.prayerTrackerScreen,
        height: 30.h,
        width: 34.h,
      ),
      CustomBottomBarItem(
        icon: ImageConstant.imgDikrnavicon,
        routeName: AppRoutes.azkharCategoriesScreen,
        height: 32.h,
        width: 34.h,
      ),
      CustomBottomBarItem(
        icon: ImageConstant.imgQuranNavIcon,
        routeName: AppRoutes.quranMainScreen,
        height: 18.h,
        width: 34.h,
      ),
      CustomBottomBarItem(
        icon: ImageConstant.imgProfileNavIcon,
        routeName: AppRoutes.profileSettingsScreen,
        height: 30.h,
        width: 22.h,
      ),
    ];

    return CustomBottomBar(
      bottomBarItemList: items,
      selectedIndex: _selectedIndex,
      onChanged: (i) {
        setState(() => _selectedIndex = i);
        navigatorKey.currentState?.pushNamed(items[i].routeName);
      },
      // No background/borderRadius passed — outer wrapper paints/clips.
      height: 76.h,
      horizontalPadding: 14.h,
    );
  }

  Widget getCurrentPage(BuildContext context, String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.prayerTrackerScreenInitialPage:
        return PrayerTrackerInitialPage();
      case AppRoutes.azkharCategoriesScreen:
        return AzkharCategoriesScreen();
      case AppRoutes.quranMainScreen:
        return QuranMainScreen();
      case AppRoutes.profileSettingsScreen:
        return ProfileSettingsScreen();
      default:
        return Container();
    }
  }
}
