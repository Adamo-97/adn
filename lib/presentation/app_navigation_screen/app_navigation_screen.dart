import 'package:flutter/material.dart';

import '../../core/app_export.dart';

class AppNavigationScreen extends ConsumerStatefulWidget {
  const AppNavigationScreen({super.key});

  @override
  AppNavigationScreenState createState() => AppNavigationScreenState();
}

class AppNavigationScreenState extends ConsumerState<AppNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFFFFFFF),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    children: [
                      _buildScreenTitle(
                        context,
                        screenTitle: "prayers_screen_EN",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.prayerTrackerScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "purification_screen_EN",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.purificationSelectionScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "salah_screen_EN",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.salahGuideMenuScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "salah_guide_screen",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.salahGuideScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "quran_screen_EN",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.quranMainScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "profile_screen_ENG",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.profileSettingsScreen),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        decoration: BoxDecoration(color: Color(0XFFFFFFFF)),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  screenTitle,
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.instance.title20RegularRoboto
                      .copyWith(color: Color(0XFF000000)),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Color(0XFF343330),
                )
              ],
            ),
            SizedBox(height: 10.h),
            Divider(height: 1.h, thickness: 1.h, color: Color(0XFFD2D2D2)),
          ],
        ),
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(BuildContext context, String routeName) {
    NavigatorService.pushNamed(routeName);
  }

  /// Common click event for bottomsheet
  void onTapBottomSheetTitle(BuildContext context, Widget className) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return className;
      },
      isScrollControlled: true,
      backgroundColor: appTheme.transparentCustom,
    );
  }

  /// Common click event for dialog
  void onTapDialogTitle(BuildContext context, Widget className) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: className,
          backgroundColor: appTheme.transparentCustom,
          insetPadding: EdgeInsets.zero,
        );
      },
    );
  }
}
