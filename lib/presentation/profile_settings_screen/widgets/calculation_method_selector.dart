import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../notifier/profile_settings_notifier.dart';
import '../../../services/prayer_times/models/models.dart';

/// Calculation Method selector for prayer time calculations
///
/// Allows users to choose from various Islamic organization calculation standards (0-16).
/// Each method uses different Fajr/Isha angles for determining prayer times.
/// Searchable list similar to Location selector design.
///
/// Default: Muslim World League (method 3)
class CalculationMethodSelector extends ConsumerWidget {
  const CalculationMethodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSettingsNotifier);
    final notifier = ref.read(profileSettingsNotifier.notifier);
    final isOpen = state.calculationMethodDropdownOpen ?? false;
    final selectedMethod =
        CalculationMethod.getById(state.selectedCalculationMethod) ??
            CalculationMethod.defaultMethod;
    final searchQuery = state.calculationMethodSearchQuery.toLowerCase();

    // Filter calculation methods based on search query
    final filteredMethods = searchQuery.isEmpty
        ? CalculationMethod.allMethods
        : CalculationMethod.allMethods
            .where((method) =>
                method.name.toLowerCase().contains(searchQuery) ||
                (method.description?.toLowerCase().contains(searchQuery) ??
                    false))
            .toList();

    return Column(
      children: [
        // Calculation Method Header - Whole row is clickable
        GestureDetector(
          onTap: notifier.toggleCalculationMethodDropdown,
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
                    imagePath: ImageConstant.imgCalculationMethodIcon,
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
                        'Calculation Method',
                        style: TextStyleHelper.instance.title18SemiBoldPoppins
                            .copyWith(fontSize: 16.fSize),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        selectedMethod.name,
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

        // Expandable Method List with Search - Similar to Location Selector
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
              ? const SizedBox.shrink(key: ValueKey('method-closed'))
              : Container(
                  key: const ValueKey('method-open'),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 12.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Search bar
                      Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: appColors.gray_700.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10.h),
                          border: Border.all(
                            color: appColors.gray_700.withValues(alpha: 0.8),
                          ),
                        ),
                        child: TextField(
                          onChanged:
                              notifier.updateCalculationMethodSearchQuery,
                          style: TextStyleHelper.instance.body15RegularPoppins
                              .copyWith(
                            fontSize: 14.fSize,
                            color: appColors.whiteA700,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search method...',
                            hintStyle: TextStyleHelper
                                .instance.label10LightPoppins
                                .copyWith(
                              fontSize: 12.fSize,
                              color: appColors.gray_500,
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10.h),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgSearch,
                                height: 20.h,
                                width: 20.h,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.h,
                              vertical: 10.h,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Scrollable list of methods
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 250.h, // Reduced from 300.h
                        ),
                        child: filteredMethods.isEmpty
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Text(
                                  'No methods found',
                                  style: TextStyleHelper
                                      .instance.label10LightPoppins
                                      .copyWith(
                                    fontSize: 12.fSize,
                                    color: appColors.gray_500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                padding:
                                    EdgeInsets.zero, // Remove default padding
                                itemCount: filteredMethods.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 6.h),
                                itemBuilder: (context, index) {
                                  final method = filteredMethods[index];
                                  final isSelected =
                                      state.selectedCalculationMethod ==
                                          method.id;

                                  return _buildMethodOption(
                                    method: method,
                                    isSelected: isSelected,
                                    onTap: () {
                                      notifier
                                          .selectCalculationMethod(method.id);
                                      // Clear search on selection
                                      notifier
                                          .updateCalculationMethodSearchQuery(
                                              '');
                                    },
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

  Widget _buildMethodOption({
    required CalculationMethod method,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? appColors.gray_900
              : appColors.gray_700.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8.h),
          border: Border.all(
            color: isSelected
                ? appColors.whiteA700.withValues(alpha: 0.2)
                : appColors.transparentCustom,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            CustomImageView(
              imagePath: isSelected
                  ? ImageConstant.imgSelected
                  : ImageConstant.imgUnselected,
              height: 18.h,
              width: 18.h,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style:
                        TextStyleHelper.instance.body15RegularPoppins.copyWith(
                      fontSize: 13.fSize,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color:
                          isSelected ? appColors.whiteA700 : appColors.gray_100,
                    ),
                  ),
                  if (method.description != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      method.description!,
                      style:
                          TextStyleHelper.instance.label10LightPoppins.copyWith(
                        fontSize: 10.fSize,
                        color: appColors.gray_500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
