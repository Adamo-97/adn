import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../notifier/profile_settings_notifier.dart';

/// Modern sign out button - compact and subtle
class SignOut extends ConsumerWidget {
  const SignOut({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(profileSettingsNotifier.notifier);

    return Center(
      child: GestureDetector(
        onTap: notifier.signOut,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4.h),
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFF4444).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(100.h), // Full pill shape
            border: Border.all(
              color: const Color(0xFFFF4444),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgSignOutIcon,
                height: 18.h,
                width: 18.h,
                color: const Color(0xFFFF4444),
              ),
              SizedBox(width: 10.h),
              Text(
                'Sign Out',
                style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                  fontSize: 15.fSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF4444),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
