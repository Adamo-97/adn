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
          margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.h),
          padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 14.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFF4444).withValues(alpha: 0.2),
                const Color(0xFFFF4444).withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(16.h),
            border: Border.all(
              color: const Color(0xFFFF4444).withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF4444).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: Offset(0, 2),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4444).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.h),
                  border: Border.all(
                    color: const Color(0xFFFF4444).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: CustomImageView(
                  imagePath: ImageConstant.imgSignOutIcon,
                  height: 16.h,
                  width: 16.h,
                  color: const Color(0xFFFF4444),
                ),
              ),
              SizedBox(width: 12.h),
              Text(
                'Sign Out',
                style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                  fontSize: 15.fSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF4444),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
