import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../notifier/profile_settings_notifier.dart';
import '../../../services/prayer_times/models/models.dart';

/// Islamic School selector for Asr prayer calculation
///
/// Allows users to choose between:
/// - Standard (Shafi'i, Maliki, Hanbali) - API school=0
/// - Hanafi - API school=1
///
/// Selection affects how Asr time is calculated based on shadow length.
class IslamicSchoolSelector extends ConsumerWidget {
  const IslamicSchoolSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSettingsNotifier);
    final notifier = ref.read(profileSettingsNotifier.notifier);
    final isOpen = state.islamicSchoolDropdownOpen ?? false;
    final selectedSchool =
        IslamicSchool.fromApiValue(state.selectedIslamicSchool);

    return Column(
      children: [
        // Islamic School Header - Whole row is clickable
        GestureDetector(
          onTap: notifier.toggleIslamicSchoolDropdown,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                Container(
                  height: 40.h,
                  width: 40.h,
                  padding: EdgeInsets.all(10.h),
                  decoration: BoxDecoration(
                    color: appColors.gray_700,
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgIslamicSchoolIcon,
                    height: 20.h,
                    width: 20.h,
                  ),
                ),
                SizedBox(width: 10.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Islamic School (Asr)',
                        style: TextStyleHelper.instance.title18SemiBoldPoppins
                            .copyWith(fontSize: 16.fSize),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        selectedSchool.displayName,
                        style: TextStyleHelper.instance.label10LightPoppins
                            .copyWith(
                          fontSize: 11.fSize,
                          color: appColors.gray_100,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeInOut,
                  child: Transform.rotate(
                    angle: 1.5708, // 90 degrees to point down initially
                    child: CustomImageView(
                      imagePath: ImageConstant.imgDropDownClick,
                      height: 50.h,
                      width: 36.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expandable School Options with Animation
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, anim) => SizeTransition(
            sizeFactor: anim,
            axisAlignment: -1.0,
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: !isOpen
              ? const SizedBox.shrink(key: ValueKey('school-closed'))
              : Container(
                  key: const ValueKey('school-open'),
                  padding: EdgeInsets.only(
                    left: 20.h,
                    right: 20.h,
                    bottom: 16.h,
                    top: 8.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSchoolOption(
                          school: IslamicSchool.standard,
                          isSelected: state.selectedIslamicSchool == 0,
                          onTap: () => notifier.selectIslamicSchool(0),
                        ),
                      ),
                      SizedBox(width: 12.h),
                      Expanded(
                        child: _buildSchoolOption(
                          school: IslamicSchool.hanafi,
                          isSelected: state.selectedIslamicSchool == 1,
                          onTap: () => notifier.selectIslamicSchool(1),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSchoolOption({
    required IslamicSchool school,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? appColors.gray_900 : appColors.transparentCustom,
          borderRadius: BorderRadius.circular(8.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              imagePath: isSelected
                  ? ImageConstant.imgSelected
                  : ImageConstant.imgUnselected,
              height: 20.h,
              width: 20.h,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 8.h),
            Flexible(
              child: Text(
                school == IslamicSchool.standard ? 'Standard' : 'Hanafi',
                style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                  fontSize: 14.fSize,
                  color: isSelected ? appColors.whiteA700 : appColors.gray_100,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
