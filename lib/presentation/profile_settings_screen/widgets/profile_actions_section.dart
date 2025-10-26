import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import 'profile_action_row.dart';

/// Complete app actions section with all action buttons (includes all styling)
class ProfileActionsSection extends StatelessWidget {
  const ProfileActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileActionRow(
          icon: ImageConstant.imgIconFrame,
          title: 'Rate App',
          onTap: () {
            // TODO: Handle rate app
          },
        ),
        SizedBox(height: 30.h),
        ProfileActionRow(
          icon: ImageConstant.imgIconPlaceholderGray900,
          title: 'Terms and Conditions',
          onTap: () {
            // TODO: Handle terms and conditions
          },
        ),
        SizedBox(height: 30.h),
        ProfileActionRow(
          icon: ImageConstant.imgIconPlaceholderGray90024x24,
          title: 'About App',
          onTap: () {
            // TODO: Handle about app
          },
        ),
        SizedBox(height: 30.h),
        ProfileActionRow(
          icon: ImageConstant.imgSearchGray900,
          title: 'Share App',
          onTap: () {
            // TODO: Handle share app
          },
        ),
      ],
    );
  }
}
