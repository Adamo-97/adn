import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'notifier/profile_settings_notifier.dart';
import 'widgets/dark_mode.dart';
import 'widgets/hijri_calendar.dart';
import 'widgets/prayer_reminders.dart';
import 'widgets/time_format_24hour.dart';
import 'widgets/location_selector.dart';
import 'widgets/language_selector.dart';
import 'widgets/rate_app.dart';
import 'widgets/terms_conditions.dart';
import 'widgets/about_app.dart';
import 'widgets/share_app.dart';
import 'widgets/sign_out.dart';

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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            appColors.gray_900,
            appColors.gray_900.withValues(alpha: 0.95),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: appColors.gray_700.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 12.h),
          Text(
            'Profile Settings',
            style: TextStyleHelper.instance.title20BoldPoppins.copyWith(
              fontSize: 18.fSize,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 12.h),
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
      padding: EdgeInsets.symmetric(horizontal: 20.h).copyWith(
        bottom: 76.h + 24.h, // Bottom padding: navbar height + extra clearance
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 12.h),

          // Preferences Section
          _buildSectionHeader('Preferences'),
          SizedBox(height: 8.h),
          _buildSettingsCard(
            children: [
              const DarkMode(),
              _buildDivider(),
              const HijriCalendar(),
              _buildDivider(),
              const PrayerReminders(),
              _buildDivider(),
              const TimeFormat24Hour(),
            ],
          ),

          SizedBox(height: 20.h),

          // Location & Language Section
          _buildSectionHeader('Location & Language'),
          SizedBox(height: 8.h),
          _buildSettingsCard(
            children: [
              const LocationSelector(),
              _buildDivider(),
              const LanguageSelector(),
            ],
          ),

          SizedBox(height: 20.h),

          // Support & About Section
          _buildSectionHeader('Support & About'),
          SizedBox(height: 8.h),
          _buildSettingsCard(
            children: [
              const RateApp(),
              _buildDivider(),
              const AboutApp(),
              _buildDivider(),
              const ShareApp(),
              _buildDivider(),
              const TermsConditions(),
            ],
          ),

          SizedBox(height: 20.h),

          // Sign Out
          const SignOut(),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  /// Build section header with modern styling
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.h, bottom: 4.h),
      child: Text(
        title,
        style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
          fontSize: 13.fSize,
          fontWeight: FontWeight.w600,
          color: appColors.gray_100.withValues(alpha: 0.6),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Build modern settings card with gradient and styling
  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.gray_700.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.h),
        border: Border.all(
          color: appColors.gray_700.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.h),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    appColors.gray_900.withValues(alpha: 0.3),
                    appColors.gray_900.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  /// Build subtle divider between settings items
  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            appColors.gray_700.withValues(alpha: 0.4),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
