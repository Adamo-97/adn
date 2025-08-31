// lib/presentation/prayer_tracker_screen/prayer_tracker_screen.dart
import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';

// Tab root screens (existing)
import '../azkhar_categories_screen/azkhar_categories_screen.dart';
import '../quran_main_screen/quran_main_screen.dart';
import '../profile_settings_screen/profile_settings_screen.dart';
import './prayer_tracker_initial_page.dart';

class PrayerTrackerScreen extends ConsumerStatefulWidget {
  const PrayerTrackerScreen({Key? key}) : super(key: key);

  @override
  PrayerTrackerScreenState createState() => PrayerTrackerScreenState();
}

class PrayerTrackerScreenState extends ConsumerState<PrayerTrackerScreen> {
  // --- One Navigator per tab (preserves per-tab history) ---
  final _navigatorKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  // --- Indices must match your old bar order ---
  static const int _tabTracker = 0;
  static const int _tabAzkhar  = 1;
  static const int _tabQuran   = 2;
  static const int _tabProfile = 3;

  int _selectedIndex = _tabTracker;

  // --- Reuse your AppRoutes names as tab roots (local to inner Navigators) ---
  static const String _routeTrackerRoot = AppRoutes.prayerTrackerScreenInitialPage;
  static const String _routeAzkharRoot  = AppRoutes.azkharCategoriesScreen;
  static const String _routeQuranRoot   = AppRoutes.quranMainScreen;
  static const String _routeProfileRoot = AppRoutes.profileSettingsScreen;

  // Build a dedicated Navigator for each tab (zero-duration transitions)
  Widget _buildTabNavigator({
    required int index,
    required String initialRoute,
  }) {
    return Navigator(
      key: _navigatorKeys[index],
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        if (index == _tabTracker && settings.name == _routeTrackerRoot) {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => PrayerTrackerInitialPage(),
            transitionDuration: Duration.zero,
          );
        }
        if (index == _tabAzkhar && settings.name == _routeAzkharRoot) {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => AzkharCategoriesScreen(),
            transitionDuration: Duration.zero,
          );
        }
        if (index == _tabQuran && settings.name == _routeQuranRoot) {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => QuranMainScreen(),
            transitionDuration: Duration.zero,
          );
        }
        if (index == _tabProfile && settings.name == _routeProfileRoot) {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => ProfileSettingsScreen(),
            transitionDuration: Duration.zero,
          );
        }

        // Fallback = tab root (extend here with more intra-tab routes later)
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) {
            switch (index) {
              case _tabAzkhar:  return AzkharCategoriesScreen();
              case _tabQuran:   return QuranMainScreen();
              case _tabProfile: return ProfileSettingsScreen();
              case _tabTracker:
              default:          return PrayerTrackerInitialPage();
            }
          },
          transitionDuration: Duration.zero,
        );
      },
    );
  }

  // System back: pop inside current tab, else allow page to pop
  Future<bool> _onWillPop() async {
    final nav = _navigatorKeys[_selectedIndex].currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
      return false;
    }
    return true;
  }

  // Re-tap active tab: pop that tab to its root
  void _popCurrentTabToRoot() {
    final nav = _navigatorKeys[_selectedIndex].currentState;
    if (nav == null) return;
    while (nav.canPop()) {
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ SAME ITEMS / ICONS / SIZES / ORDER (design unchanged)
    final items = [
      CustomBottomBarItem(
        icon: ImageConstant.imgPraynavicon,
        routeName: AppRoutes.prayerTrackerScreen, // informational only
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBody: true,

        // --- BODY: IndexedStack preserves each tab exactly ---
        body: SafeArea(
          top: false,
          bottom: true,
          child: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              _buildTabNavigator(index: _tabTracker, initialRoute: _routeTrackerRoot),
              _buildTabNavigator(index: _tabAzkhar,  initialRoute: _routeAzkharRoot),
              _buildTabNavigator(index: _tabQuran,   initialRoute: _routeQuranRoot),
              _buildTabNavigator(index: _tabProfile, initialRoute: _routeProfileRoot),
            ],
          ),
        ),

        // --- BOTTOM BAR: EXACT SAME WRAPPER / COLORS / RADII AS YOUR OLD CODE ---
        bottomNavigationBar: SafeArea(
          top: false,
          bottom: false, // fill under the home indicator
          child: Container(
            color: appTheme.gray_900, // #212121 — page/dark background
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF5C6248), // olive bar
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.h),
                  topRight: Radius.circular(16.h),
                  // no bottom radius — bar fills the very bottom edge
                ),
              ),
              child: SizedBox(
                width: double.maxFinite,
                child: CustomBottomBar(
                  bottomBarItemList: items,
                  selectedIndex: _selectedIndex,
                  // 🔑 SWITCH TAB ONLY (no push here). Design unchanged.
                  onChanged: (i) {
                    if (i == _selectedIndex) {
                      _popCurrentTabToRoot();
                    } else {
                      setState(() => _selectedIndex = i);
                    }
                  },
                  height: 76.h,
                  horizontalPadding: 14.h,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
