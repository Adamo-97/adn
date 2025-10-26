import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/mosque_model.dart';

/// Mosque list item card widget with expandable details
class MosqueCard extends StatelessWidget {
  final MosqueModel mosque;
  final bool isExpanded;
  final VoidCallback? onTap;
  final VoidCallback? onMapTap;
  final VoidCallback? onSearchGoogle;

  const MosqueCard({
    super.key,
    required this.mosque,
    this.isExpanded = false,
    this.onTap,
    this.onMapTap,
    this.onSearchGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          color: appTheme.gray_900, // Same grey as navbar hole #212121
          borderRadius: BorderRadius.circular(8.h),
          border: Border.all(
            color: isExpanded
                ? appTheme.orange_200 // Golden stroke when expanded
                : appTheme.gray_700.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main row - always visible
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Mosque image placeholder
                Container(
                  width: 47.h,
                  height: 47.h,
                  decoration: BoxDecoration(
                    color: appTheme.gray_900,
                    borderRadius: BorderRadius.circular(3.h),
                    border: Border.all(
                      color: isExpanded
                          ? appTheme.orange_200 // Gold border when expanded
                          : appTheme.gray_700.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: mosque.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(3.h),
                          child: CustomImageView(
                            imagePath: mosque.imageUrl!,
                            fit: BoxFit.cover,
                            width: 47.h,
                            height: 47.h,
                          ),
                        )
                      : Center(
                          child: Text(
                            'No Image',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: appTheme.white_A700.withOpacity(0.5),
                              fontSize: 7.fSize,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),

                SizedBox(width: 8.h),

                // Mosque info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mosque.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: appTheme.white_A700,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.fSize,
                          letterSpacing: -0.23,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        mosque.address,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: appTheme.white_A700.withOpacity(0.7),
                          fontWeight: FontWeight.w300,
                          fontSize: 10.fSize,
                        ),
                        maxLines: isExpanded ? 3 : 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.h),

                // Distance and map icon (not a button)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgOpenMapIcon,
                      height: 21.h,
                      width: 21.h,
                      color: isExpanded ? appTheme.orange_200 : null,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      mosque.formattedDistance,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isExpanded
                            ? appTheme.orange_200
                            : appTheme.white_A700.withOpacity(0.7),
                        fontWeight: FontWeight.w300,
                        fontSize: 7.fSize,
                        letterSpacing: -0.39,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),

            // Expanded details section with smooth, slower height animation
            ClipRect(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                heightFactor: isExpanded ? 1.0 : 0.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),

                    // Divider - Gold when expanded
                    Container(
                      width: double.infinity,
                      height: 1.h,
                      color: appTheme.orange_200,
                    ),

                    SizedBox(height: 10.h),

                    // Action buttons - fade in after expansion starts
                    AnimatedOpacity(
                      opacity: isExpanded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOut,
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              context: context,
                              label: 'Search Google',
                              icon: Icons.search,
                              onTap: onSearchGoogle,
                            ),
                          ),
                          SizedBox(width: 8.h),
                          Expanded(
                            child: _buildActionButton(
                              context: context,
                              label: 'Open in Maps',
                              icon: Icons.directions,
                              onTap: onMapTap,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build action button
  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.h),
        decoration: BoxDecoration(
          color: appTheme.gray_900,
          borderRadius: BorderRadius.circular(6.h),
          border: Border.all(
            color: appTheme.orange_200.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14.h,
              color: appTheme.orange_200,
            ),
            SizedBox(width: 6.h),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: appTheme.white_A700,
                fontSize: 10.fSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
