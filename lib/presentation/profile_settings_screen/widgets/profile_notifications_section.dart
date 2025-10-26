import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../notifier/profile_settings_notifier.dart';
import 'profile_section_header.dart';
import 'profile_notification_row.dart';

/// Complete notifications section with header and list (includes all styling)
class ProfileNotificationsSection extends ConsumerWidget {
  const ProfileNotificationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSettingsNotifier);
    final notifier = ref.read(profileSettingsNotifier.notifier);

    return Column(
      children: [
        // Notifications Header
        ProfileSectionHeader(
          icon: ImageConstant.imgAppmodeIconWhiteA70024x24,
          title: 'Notifications',
          subtitle: 'Manage app notifications',
          showChevron: true,
        ),
        SizedBox(height: 12.h),

        // Notifications List
        Container(
          margin: EdgeInsets.symmetric(horizontal: 14.h),
          child: Column(
            children: [
              ProfileNotificationRow(
                title: 'All Notifications',
                isEnabled: state.allNotifications ?? true,
                onTap: notifier.toggleAllNotifications,
              ),
              SizedBox(height: 10.h),
              ProfileNotificationRow(
                title: 'Athan Notifications',
                isEnabled: state.athanNotifications ?? true,
                onTap: notifier.toggleAthanNotifications,
              ),
              SizedBox(height: 12.h),
              ProfileNotificationRow(
                title: 'Prayer Reminders',
                isEnabled: state.prayerReminders ?? true,
                onTap: notifier.togglePrayerReminders,
              ),
              SizedBox(height: 8.h),
              ProfileNotificationRow(
                title: 'Azkar Notifications',
                isEnabled: state.azkarNotifications ?? true,
                onTap: notifier.toggleAzkarNotifications,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
