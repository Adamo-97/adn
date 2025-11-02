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
                appColors.danger_20,
                appColors.danger_15,
              ],
            ),
            borderRadius: BorderRadius.circular(16.h),
            border: Border.all(
              color: appColors.danger_60,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: appColors.danger_30,
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
                  color: appColors.danger_15,
                  borderRadius: BorderRadius.circular(8.h),
                  border: Border.all(
                    color: appColors.danger_30,
                    width: 1,
                  ),
                ),
                child: CustomImageView(
                  imagePath: ImageConstant.imgSignOutIcon,
                  height: 16.h,
                  width: 16.h,
                  color: appColors.danger,
                ),
              ),
              SizedBox(width: 12.h),
              Text(
                'Sign Out',
                style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                  fontSize: 15.fSize,
                  fontWeight: FontWeight.w600,
                  color: appColors.danger,
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
