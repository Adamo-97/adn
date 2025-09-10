import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import 'notifier/profile_settings_notifier.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  ProfileSettingsScreenState createState() => ProfileSettingsScreenState();
}

class ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray_900,
        body: Container(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 4.h),
                      _buildMainContent(context)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: appTheme.gray_900,
      ),
      child: Column(
        children: [
          SizedBox(height: 32.h),
          Text(
            'Profile',
            style: TextStyleHelper.instance.title20BoldPoppins,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildMainContent(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 940.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(left: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingsList(context),
                  SizedBox(height: 10.h),
                  _buildLocationDropdown(context),
                  SizedBox(height: 10.h),
                  _buildLocationOptions(context),
                  SizedBox(height: 16.h),
                  _buildLanguageSection(context),
                  SizedBox(height: 20.h),
                  _buildLanguageOptions(context),
                  SizedBox(height: 20.h),
                  _buildNotificationsSection(context),
                  SizedBox(height: 12.h),
                  _buildNotificationsList(context),
                  SizedBox(height: 28.h),
                  _buildAppActions(context),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 76.h,
              width: double.maxFinite,
              margin: EdgeInsets.only(bottom: 114.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgShadowButtom2,
                height: 76.h,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: 40.h, bottom: 142.h),
              child: CustomIconButton(
                height: 56.h,
                width: 56.h,
                padding: EdgeInsets.all(12.h),
                iconPath: ImageConstant.imgGroup3,
                backgroundColor: appTheme.gray_500,
                borderRadius: 28.h,
                onPressed: () {
                  // Handle floating action button press
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSettingsList(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(profileSettingsNotifier);

        return Container(
          margin: EdgeInsets.only(right: 24.h),
          child: Column(
            children: [
              _buildSettingItem(
                context,
                icon: ImageConstant.imgVectorWhiteA700,
                title: 'Dark Mode',
                subtitle: 'Switch between light and dark theme',
                trailing: CustomImageView(
                  imagePath: ImageConstant.imgStatusChecked,
                  height: 44.h,
                  width: 36.h,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  ref.read(profileSettingsNotifier.notifier).toggleDarkMode();
                },
              ),
              SizedBox(height: 26.h),
              _buildSettingItem(
                context,
                icon: ImageConstant.imgCalendarIcon,
                title: 'Hijri Calendar',
                subtitle: 'Switch to Hijri calendar display',
                trailing: CustomImageView(
                  imagePath: ImageConstant.imgStatusUnchecked,
                  height: 44.h,
                  width: 36.h,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  ref
                      .read(profileSettingsNotifier.notifier)
                      .toggleHijriCalendar();
                },
              ),
              SizedBox(height: 26.h),
              _buildSettingItem(
                context,
                icon: ImageConstant.imgAppmodeIcon,
                title: 'Location',
                subtitle: 'Update your current location',
                trailing: CustomImageView(
                  imagePath: ImageConstant.imgDropDownClick,
                  height: 50.h,
                  width: 36.h,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  ref
                      .read(profileSettingsNotifier.notifier)
                      .toggleLocationDropdown();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Helper Widget
  Widget _buildSettingItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(top: 4.h),
            child: CustomImageView(
              imagePath: icon,
              height: 24.h,
              width: 24.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyleHelper.instance.title18SemiBoldPoppins,
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyleHelper.instance.label10LightPoppins,
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLocationDropdown(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(profileSettingsNotifier);

        return Container(
          margin: EdgeInsets.only(right: 24.h),
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          decoration: BoxDecoration(
            color: appTheme.gray_900_01,
            borderRadius: BorderRadius.circular(4.h),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 2.h),
                  child: Text(
                    'Type your country...',
                    style: TextStyleHelper.instance.body15RegularPoppins
                        .copyWith(color: appTheme.white_A700),
                  ),
                ),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgArrowDown,
                height: 24.h,
                width: 24.h,
                fit: BoxFit.cover,
              ),
              CustomImageView(
                imagePath: ImageConstant.imgArrowDownWhiteA700,
                height: 22.h,
                width: 24.h,
                fit: BoxFit.cover,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildLocationOptions(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(profileSettingsNotifier);

        return Container(
          margin: EdgeInsets.only(right: 24.h),
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.h),
          decoration: BoxDecoration(
            color: appTheme.gray_900_01,
            borderRadius: BorderRadius.circular(4.h),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Container(
                margin: EdgeInsets.only(left: 4.h),
                child: Text(
                  'Berlin, Germany',
                  style: TextStyleHelper.instance.body12RegularPoppins,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.h),
                decoration: BoxDecoration(
                  color: appTheme.gray_900,
                  borderRadius: BorderRadius.circular(4.h),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stockholm, Sweden',
                      style: TextStyleHelper.instance.body12RegularPoppins,
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgCheckMark,
                      height: 24.h,
                      width: 24.h,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                margin: EdgeInsets.only(left: 4.h),
                child: Text(
                  'Moscow, Russia',
                  style: TextStyleHelper.instance.body12RegularPoppins,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                margin: EdgeInsets.only(left: 4.h),
                child: Text(
                  'Copenhagen, Denmark',
                  style: TextStyleHelper.instance.body12RegularPoppins,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildLanguageSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 14.h),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(top: 2.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgAppmodeIconWhiteA700,
              height: 24.h,
              width: 24.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Language',
                  style: TextStyleHelper.instance.title18SemiBoldPoppins,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Select your preferred language',
                  style: TextStyleHelper.instance.label10LightPoppins,
                ),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgDropDownClickWhiteA700,
            height: 44.h,
            width: 10.h,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLanguageOptions(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(profileSettingsNotifier);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 46.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  ref
                      .read(profileSettingsNotifier.notifier)
                      .selectLanguage('English');
                },
                child: Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgSelected,
                      height: 24.h,
                      width: 24.h,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8.h),
                    Text(
                      'English',
                      style: TextStyleHelper.instance.body15RegularPoppins
                          .copyWith(color: appTheme.white_A700),
                    ),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  ref
                      .read(profileSettingsNotifier.notifier)
                      .selectLanguage('Arabic');
                },
                child: Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgUnselected,
                      height: 24.h,
                      width: 24.h,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 12.h),
                    Container(
                      margin: EdgeInsets.only(right: 30.h),
                      child: Text(
                        'العربية',
                        style:
                            TextStyleHelper.instance.body15MediumNotoKufiArabic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildNotificationsSection(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: 4.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgAppmodeIconWhiteA70024x24,
            height: 24.h,
            width: 24.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 10.h),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyleHelper.instance.title18SemiBoldPoppins
                      .copyWith(color: appTheme.gray_100),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Manage app notifications',
                  style: TextStyleHelper.instance.label10LightPoppins
                      .copyWith(color: appTheme.gray_100),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 24.h, left: 10.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgDropDownClick,
            height: 50.h,
            width: 36.h,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildNotificationsList(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(profileSettingsNotifier);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 14.h),
          child: Column(
            children: [
              _buildNotificationItem(
                context,
                title: 'All Notifications',
                isEnabled: state.allNotifications ?? true,
                onTap: () {
                  ref
                      .read(profileSettingsNotifier.notifier)
                      .toggleAllNotifications();
                },
              ),
              SizedBox(height: 10.h),
              _buildNotificationItem(
                context,
                title: 'Athan Notifications',
                isEnabled: state.athanNotifications ?? true,
                onTap: () {
                  ref
                      .read(profileSettingsNotifier.notifier)
                      .toggleAthanNotifications();
                },
              ),
              SizedBox(height: 12.h),
              _buildNotificationItem(
                context,
                title: 'Prayer Reminders',
                isEnabled: state.prayerReminders ?? true,
                onTap: () {
                  ref
                      .read(profileSettingsNotifier.notifier)
                      .togglePrayerReminders();
                },
              ),
              SizedBox(height: 8.h),
              _buildNotificationItem(
                context,
                title: 'Azkar Notifications',
                isEnabled: state.azkarNotifications ?? true,
                onTap: () {
                  ref
                      .read(profileSettingsNotifier.notifier)
                      .toggleAzkarNotifications();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Helper Widget
  Widget _buildNotificationItem(
    BuildContext context, {
    required String title,
    required bool isEnabled,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyleHelper.instance.body15RegularPoppins
                  .copyWith(color: appTheme.gray_100),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 24.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgStatusChecked,
              height: 22.h,
              width: 36.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildAppActions(BuildContext context) {
    return Column(
      children: [
        _buildActionItem(
          context,
          icon: ImageConstant.imgIconFrame,
          title: 'Rate App',
          onTap: () {
            // Handle rate app
          },
        ),
        SizedBox(height: 30.h),
        _buildActionItem(
          context,
          icon: ImageConstant.imgIconPlaceholderGray900,
          title: 'Terms and Conditions',
          onTap: () {
            // Handle terms and conditions
          },
        ),
        SizedBox(height: 30.h),
        _buildActionItem(
          context,
          icon: ImageConstant.imgIconPlaceholderGray90024x24,
          title: 'About App',
          onTap: () {
            // Handle about app
          },
        ),
        SizedBox(height: 30.h),
        _buildActionItem(
          context,
          icon: ImageConstant.imgSearchGray900,
          title: 'Share App',
          onTap: () {
            // Handle share app
          },
        ),
      ],
    );
  }

  /// Helper Widget
  Widget _buildActionItem(
    BuildContext context, {
    required String icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CustomIconButton(
            height: 24.h,
            width: 24.h,
            padding: EdgeInsets.all(4.h),
            iconPath: icon,
            backgroundColor: appTheme.white_A700,
            borderRadius: 12.h,
            variant: CustomIconButtonVariant.small,
          ),
          SizedBox(width: 10.h),
          Text(
            title,
            style: TextStyleHelper.instance.body15RegularPoppins
                .copyWith(color: appTheme.white_A700),
          ),
        ],
      ),
    );
  }
}
