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

class PrayerTrackerScreenState extends ConsumerState<PrayerTrackerScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        child: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    var bottomBarItemList = <CustomBottomBarItem>[
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
        icon: ImageConstant.imgSubtract,
        routeName: AppRoutes.prayerTrackerScreen,
        height: 58.h,
        width: 110.h,
        isSpecialItem: true,
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

    int selectedIndex = 2;

    return CustomBottomBar(
      bottomBarItemList: bottomBarItemList,
      onChanged: (index) {
        selectedIndex = index;
        var bottomBarItem = bottomBarItemList[index];
        navigatorKey.currentState?.pushNamed(bottomBarItem.routeName);
      },
      selectedIndex: selectedIndex,
      backgroundColor: appTheme.gray_700,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.h),
        topRight: Radius.circular(10.h),
        bottomLeft: Radius.circular(5.h),
        bottomRight: Radius.circular(5.h),
      ),
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
