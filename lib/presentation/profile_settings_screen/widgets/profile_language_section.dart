import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../notifier/profile_settings_notifier.dart';
import 'profile_language_option.dart';

/// Complete language section with dropdown and options (includes all styling)
class ProfileLanguageSection extends ConsumerWidget {
  const ProfileLanguageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSettingsNotifier);
    final notifier = ref.read(profileSettingsNotifier.notifier);
    final isOpen = state.languageDropdownOpen ?? false;

    return Column(
      children: [
        // Language Header
        Container(
          margin: EdgeInsets.only(right: 24.h),
          child: GestureDetector(
            onTap: notifier.toggleLanguageDropdown,
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
                  imagePath: ImageConstant.imgDropDownClick,
                  height: 50.h,
                  width: 36.h,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // Language Options (shown when dropdown is open)
        if (isOpen)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 46.h),
            child: Row(
              children: [
                ProfileLanguageOption(
                  language: 'English',
                  isSelected: state.selectedLanguage == 'English',
                  onTap: () => notifier.selectLanguage('English'),
                ),
                const Spacer(),
                ProfileLanguageOption(
                  language: 'العربية',
                  isSelected: state.selectedLanguage == 'Arabic',
                  isArabic: true,
                  onTap: () => notifier.selectLanguage('Arabic'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
