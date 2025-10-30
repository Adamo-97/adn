import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../notifier/nearby_mosques_notifier.dart';

class NearbySearchBar extends StatelessWidget {
  final NearbyMosquesNotifier notifier;
  final TextEditingController searchController;

  const NearbySearchBar(
      {super.key, required this.notifier, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Location button - SVG already has circular bg
        GestureDetector(
          onTap: () {
            // TODO: Implement location selection
          },
          child: CustomImageView(
            imagePath: ImageConstant.imgLocationButton,
            height: 44.h,
            width: 44.h,
            fit: BoxFit.contain,
          ),
        ),

        SizedBox(width: 10.h),

        // Search input bar
        Expanded(
          child: Container(
            height: 44.h,
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            decoration: BoxDecoration(
              color: appTheme.gray_900,
              borderRadius: BorderRadius.circular(64.h),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.3 * 255).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: TextField(
                controller: searchController,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: appTheme.whiteA700,
                  fontSize: 14.fSize,
                  fontFamily: 'Poppins',
                ),
                decoration: InputDecoration(
                  hintText: 'Enter location',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.whiteA700.withAlpha((0.5 * 255).round()),
                    fontSize: 14.fSize,
                    fontFamily: 'Poppins',
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) => notifier.updateSearchQuery(value),
              ),
            ),
          ),
        ),

        SizedBox(width: 10.h),

        // Search button - SVG already has circular bg
        GestureDetector(
          onTap: () {
            // Trigger search
            notifier.updateSearchQuery(searchController.text);
          },
          child: CustomImageView(
            imagePath: ImageConstant.imgSearchButton,
            height: 44.h,
            width: 44.h,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
