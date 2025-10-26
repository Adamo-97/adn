import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../notifier/profile_settings_notifier.dart';
import 'profile_setting_row.dart';

/// Complete settings list section with all styling included
class ProfileSettingsList extends ConsumerWidget {
  const ProfileSettingsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSettingsNotifier);
    final notifier = ref.read(profileSettingsNotifier.notifier);

    return Container(
      margin: EdgeInsets.only(right: 24.h),
      child: Column(
        children: [
          ProfileSettingRow(
            icon: ImageConstant.imgVectorWhiteA700,
            title: 'Dark Mode',
            subtitle: 'Switch between light and dark theme',
            isToggleable: true,
            toggleValue: state.darkMode ?? false,
            onTap: notifier.toggleDarkMode,
          ),
          SizedBox(height: 26.h),
          ProfileSettingRow(
            icon: ImageConstant.imgCalendarIcon,
            title: 'Hijri Calendar',
            subtitle: 'Switch to Hijri calendar display',
            isToggleable: true,
            toggleValue: state.hijriCalendar ?? false,
            onTap: notifier.toggleHijriCalendar,
          ),
          SizedBox(height: 26.h),
          ProfileSettingRow(
            icon: ImageConstant.imgAppmodeIcon,
            title: 'Location',
            subtitle: 'Update your current location',
            showChevron: true,
            onTap: notifier.toggleLocationDropdown,
          ),
        ],
      ),
    );
  }
}
