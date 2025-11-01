import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../notifier/profile_settings_notifier.dart';

/// Modern language selector with English and Arabic options and animations
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSettingsNotifier);
    final notifier = ref.read(profileSettingsNotifier.notifier);
    final isOpen = state.languageDropdownOpen ?? false;

    return Column(
      children: [
        // Language Header - Whole row is clickable
        GestureDetector(
          onTap: notifier.toggleLanguageDropdown,
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
                    imagePath: ImageConstant.imgAppmodeIconWhiteA700,
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
                        'Language',
                        style: TextStyleHelper.instance.title18SemiBoldPoppins
                            .copyWith(fontSize: 16.fSize),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        state.selectedLanguage == 'English'
                            ? 'English'
                            : 'العربية',
                        style: state.selectedLanguage == 'Arabic'
                            ? TextStyleHelper
                                .instance.body15MediumNotoKufiArabic
                                .copyWith(
                                    fontSize: 11.fSize,
                                    color: appColors.gray_100)
                            : TextStyleHelper.instance.label10LightPoppins
                                .copyWith(
                                    fontSize: 11.fSize,
                                    color: appColors.gray_100),
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

        // Expandable Language Options with Animation
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
              ? const SizedBox.shrink(key: ValueKey('language-closed'))
              : Container(
                  key: const ValueKey('language-open'),
                  padding: EdgeInsets.only(
                    left: 20.h,
                    right: 20.h,
                    bottom: 16.h,
                    top: 8.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildLanguageOption(
                          language: 'English',
                          isSelected: state.selectedLanguage == 'English',
                          isArabic: false,
                          onTap: () => notifier.selectLanguage('English'),
                        ),
                      ),
                      SizedBox(width: 12.h),
                      Expanded(
                        child: _buildLanguageOption(
                          language: 'العربية',
                          isSelected: state.selectedLanguage == 'Arabic',
                          isArabic: true,
                          onTap: () => notifier.selectLanguage('Arabic'),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildLanguageOption({
    required String language,
    required bool isSelected,
    required bool isArabic,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? appColors.gray_900 : Colors.transparent,
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
            Text(
              language,
              style: (isArabic
                      ? TextStyleHelper.instance.body15MediumNotoKufiArabic
                      : TextStyleHelper.instance.body15RegularPoppins)
                  .copyWith(
                fontSize: 14.fSize,
                color: isSelected ? appColors.whiteA700 : appColors.gray_100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
