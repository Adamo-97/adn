import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../notifier/profile_settings_notifier.dart';

/// Modern location selector with search and expandable dropdown
class LocationSelector extends ConsumerWidget {
  const LocationSelector({super.key});

  // Sample list of locations (can be expanded)
  static const List<String> _allLocations = [
    'Berlin, Germany',
    'Stockholm, Sweden',
    'Moscow, Russia',
    'Copenhagen, Denmark',
    'London, United Kingdom',
    'Paris, France',
    'Madrid, Spain',
    'Rome, Italy',
    'Amsterdam, Netherlands',
    'Vienna, Austria',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSettingsNotifier);
    final notifier = ref.read(profileSettingsNotifier.notifier);
    final isOpen = state.locationDropdownOpen ?? false;
    final searchQuery = state.searchQuery.toLowerCase();

    // Filter locations based on search query
    final filteredLocations = searchQuery.isEmpty
        ? _allLocations
        : _allLocations
            .where((loc) => loc.toLowerCase().contains(searchQuery))
            .toList();

    return Column(
      children: [
        // Location Header - Whole row is clickable
        GestureDetector(
          onTap: notifier.toggleLocationDropdown,
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
                    imagePath: ImageConstant.imgAppmodeIcon,
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
                        'Location',
                        style: TextStyleHelper.instance.title18SemiBoldPoppins
                            .copyWith(fontSize: 16.fSize),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        state.selectedLocation ?? 'Select your location',
                        style: TextStyleHelper.instance.label10LightPoppins
                            .copyWith(
                          fontSize: 11.fSize,
                          color: appColors.gray_100,
                        ),
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

        // Expandable Dropdown with Animation
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
              ? const SizedBox.shrink(key: ValueKey('location-closed'))
              : Container(
                  key: const ValueKey('location-open'),
                  margin: EdgeInsets.only(
                    left: 20.h,
                    right: 20.h,
                    top: 8.h,
                  ),
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                    color: appColors.gray_900_01,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Column(
                    children: [
                      // Search Field - Modern minimal style
                      Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgSearch,
                            height: 18.h,
                            width: 18.h,
                            color: appColors.gray_500,
                          ),
                          SizedBox(width: 10.h),
                          Expanded(
                            child: TextField(
                              onChanged: notifier.updateSearchQuery,
                              style: TextStyleHelper
                                  .instance.body15RegularPoppins
                                  .copyWith(
                                fontSize: 13.fSize,
                                color: appColors.whiteA700,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search location...',
                                hintStyle: TextStyleHelper
                                    .instance.body15RegularPoppins
                                    .copyWith(
                                  fontSize: 13.fSize,
                                  color: appColors.gray_500,
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // Location List
                      Container(
                        constraints: BoxConstraints(maxHeight: 200.h),
                        child: filteredLocations.isEmpty
                            ? _buildNoResults()
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: filteredLocations.length,
                                itemBuilder: (context, index) {
                                  final location = filteredLocations[index];
                                  final isSelected =
                                      state.selectedLocation == location;
                                  return _buildLocationOption(
                                    location: location,
                                    isSelected: isSelected,
                                    onTap: () =>
                                        notifier.selectLocation(location),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildNoResults() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: Text(
          'No locations found',
          style: TextStyleHelper.instance.body15RegularPoppins
              .copyWith(fontSize: 13.fSize, color: appColors.gray_500),
        ),
      ),
    );
  }

  Widget _buildLocationOption({
    required String location,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? appColors.gray_900 : Colors.transparent,
          borderRadius: BorderRadius.circular(6.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                location,
                style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                  fontSize: 13.fSize,
                  color: isSelected ? appColors.whiteA700 : appColors.gray_100,
                ),
              ),
            ),
            if (isSelected)
              CustomImageView(
                imagePath: ImageConstant.imgCheckMark,
                height: 18.h,
                width: 18.h,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
