import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'notifier/profile_settings_notifier.dart';
import 'widgets/profile_settings_list.dart';
import 'widgets/profile_location_section.dart';
import 'widgets/profile_language_section.dart';
import 'widgets/profile_notifications_section.dart';
import 'widgets/profile_actions_section.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ProfileSettingsScreenState createState() => ProfileSettingsScreenState();
}

class ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isResetting = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileSettingsNotifier);
    final notifier = ref.read(profileSettingsNotifier.notifier);

    // Listen to reset state changes from notifier
    ref.listen<ProfileSettingsState>(profileSettingsNotifier, (previous, next) {
      if (previous != null && next.resetTimestamp != previous.resetTimestamp) {
        if (!_isResetting) {
          _isResetting = true;

          // Reset scroll position
          if (_scrollController.hasClients && _scrollController.offset > 0.0) {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }

          // Reset flag after animations complete
          Future.delayed(const Duration(milliseconds: 350), () {
            if (mounted) {
              _isResetting = false;
            }
          });
        }
      }
    });

    return Scaffold(
      backgroundColor: appColors.gray_900,
      body: SizedBox(
        width: double.maxFinite,
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        SizedBox(height: 4.h),
                        _buildMainContent(context, state, notifier)
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom fade effect
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.4, 0.7, 1.0],
                      colors: [
                        appColors.gray_900.withAlpha(0),
                        appColors.gray_900.withAlpha((0.3 * 255).round()),
                        appColors.gray_900.withAlpha((0.7 * 255).round()),
                        appColors.gray_900,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget - Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.h,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        color: appColors.gray_900,
      ),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          Text(
            'Profile',
            style: TextStyleHelper.instance.title20BoldPoppins,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildMainContent(
    BuildContext context,
    ProfileSettingsState state,
    ProfileSettingsNotifier notifier,
  ) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 24.h),
      padding: EdgeInsets.only(
          bottom:
              76.h + 24.h), // Bottom padding: navbar height + extra clearance
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSettingsList(),
          SizedBox(height: 10.h),
          const ProfileLocationSection(),
          SizedBox(height: 16.h),
          const ProfileLanguageSection(),
          SizedBox(height: 20.h),
          const ProfileNotificationsSection(),
          SizedBox(height: 28.h),
          const ProfileActionsSection(),
        ],
      ),
    );
  }
}
