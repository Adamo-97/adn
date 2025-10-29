import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../notifier/profile_settings_notifier.dart';
import 'profile_location_option.dart';

/// Complete location section with dropdown and options (includes all styling)
class ProfileLocationSection extends ConsumerWidget {
  const ProfileLocationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSettingsNotifier);
    final notifier = ref.read(profileSettingsNotifier.notifier);
    final isOpen = state.locationDropdownOpen ?? false;

    return Column(
      children: [
        // Location Dropdown Header
        Container(
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
                        .copyWith(color: appTheme.whiteA700),
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
        ),
        SizedBox(height: 10.h),

        // Location Options (shown when dropdown is open)
        if (isOpen) ...[
          Container(
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
                ProfileLocationOption(
                  location: 'Berlin, Germany',
                  isSelected: state.selectedLocation == 'Berlin, Germany',
                  onTap: () => notifier.selectLocation('Berlin, Germany'),
                ),
                ProfileLocationOption(
                  location: 'Stockholm, Sweden',
                  isSelected: state.selectedLocation == 'Stockholm, Sweden',
                  onTap: () => notifier.selectLocation('Stockholm, Sweden'),
                ),
                ProfileLocationOption(
                  location: 'Moscow, Russia',
                  isSelected: state.selectedLocation == 'Moscow, Russia',
                  onTap: () => notifier.selectLocation('Moscow, Russia'),
                ),
                ProfileLocationOption(
                  location: 'Copenhagen, Denmark',
                  isSelected: state.selectedLocation == 'Copenhagen, Denmark',
                  onTap: () => notifier.selectLocation('Copenhagen, Denmark'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
