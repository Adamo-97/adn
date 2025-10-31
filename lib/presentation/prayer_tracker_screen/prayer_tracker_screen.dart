// lib/presentation/prayer_tracker_screen/prayer_tracker_screen.dart
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';

// Tab root screens (existing)
import '../salah_guide_screen/salah_guide_screen.dart';
import '../salah_guide_screen/notifier/salah_guide_notifier.dart';
import '../nearby_mosques_screen/nearby_mosques_screen.dart';
import '../nearby_mosques_screen/notifier/nearby_mosques_notifier.dart';
import '../profile_settings_screen/profile_settings_screen.dart';
import '../profile_settings_screen/notifier/profile_settings_notifier.dart';
import './prayer_tracker_initial_page.dart';
import './notifier/prayer_tracker_notifier.dart';

class PrayerTrackerScreen extends ConsumerStatefulWidget {
  const PrayerTrackerScreen({super.key});

  @override
  PrayerTrackerScreenState createState() => PrayerTrackerScreenState();
}

class PrayerTrackerScreenState extends ConsumerState<PrayerTrackerScreen> {
  // --- One Navigator per tab (preserves per-tab history) ---
  final _navigatorKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  // --- Indices must match your old bar order ---
  static const int _tabTracker = 0;
  static const int _tabSalahGuide = 1;
  static const int _tabMosques = 2;
  static const int _tabProfile = 3;

  int _selectedIndex = _tabTracker;

  // --- Reuse your AppRoutes names as tab roots (local to inner Navigators) ---
  static const String _routeTrackerRoot =
      AppRoutes.prayerTrackerScreenInitialPage;
  static const String _routeSalahGuideRoot = AppRoutes.salahGuideScreen;
  static const String _routeMosquesRoot = AppRoutes.nearbyMosquesScreen;
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
        if (index == _tabSalahGuide && settings.name == _routeSalahGuideRoot) {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => SalahGuideScreen(),
            transitionDuration: Duration.zero,
          );
        }
        if (index == _tabMosques && settings.name == _routeMosquesRoot) {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => NearbyMosquesScreen(),
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
              case _tabSalahGuide:
                return SalahGuideScreen();
              case _tabMosques:
                return NearbyMosquesScreen();
              case _tabProfile:
                return ProfileSettingsScreen();
              case _tabTracker:
              default:
                return PrayerTrackerInitialPage();
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

  // Reset state when leaving a tab (IndexedStack keeps widgets alive)
  void _resetTabState(int tabIndex) {
    switch (tabIndex) {
      case _tabTracker:
        // Reset prayer tracker state (calendar, selected date, qibla, stats)
        ref.read(prayerTrackerNotifierProvider.notifier).resetState();
        break;
      case _tabSalahGuide:
        // Reset salah guide state (including scroll position)
        ref.read(salahGuideNotifier.notifier).resetState();
        break;
      case _tabMosques:
        // Reset nearby mosques state (including scroll positions)
        ref.read(nearbyMosquesNotifierProvider.notifier).resetState();
        break;
      case _tabProfile:
        // Reset profile state
        ref.read(profileSettingsNotifier.notifier).resetState();
        break;
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
        icon: ImageConstant.imgIconPlaceholder7,
        routeName: AppRoutes.salahGuideScreen,
        height: 32.h,
        width: 34.h,
      ),
      CustomBottomBarItem(
        icon: ImageConstant.imgMosqueNavIcon,
        routeName: AppRoutes.nearbyMosquesScreen,
        height: 30.h,
        width: 30.h,
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
        extendBody: true, // Extend body behind the navbar

        // --- BODY: IndexedStack (no animation, instant switch) ---
        body: SafeArea(
          top: false,
          bottom: false, // Allow content to extend behind navbar
          child: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              _buildTabNavigator(
                  index: _tabTracker, initialRoute: _routeTrackerRoot),
              _buildTabNavigator(
                  index: _tabSalahGuide, initialRoute: _routeSalahGuideRoot),
              _buildTabNavigator(
                  index: _tabMosques, initialRoute: _routeMosquesRoot),
              _buildTabNavigator(
                  index: _tabProfile, initialRoute: _routeProfileRoot),
            ],
          ),
        ),

        // --- BOTTOM BAR: EXACT SAME WRAPPER / COLORS / RADII AS YOUR OLD CODE ---
        bottomNavigationBar: SafeArea(
          top: false,
          bottom: false, // fill under the home indicator
          child: Container(
            color: appColors.gray_900, // Match page background to eliminate gap
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
                      // Reset state of the tab we're leaving
                      _resetTabState(_selectedIndex);
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
