import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import 'mosque_action_button.dart';
import 'mosque_image_tile.dart';
import '../models/mosque_model.dart';

/// Mosque list item card widget with expandable details
class MosqueCard extends StatefulWidget {
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
  State<MosqueCard> createState() => _MosqueCardState();
}

class _MosqueCardState extends State<MosqueCard> {
  @override
  Widget build(BuildContext context) {
    // Preserve the original visual behavior but keep this widget stateful so
    // we can move per-card animations and logic here without changing the
    // public API used by the sheet/notifier.
    final isExpanded = widget.isExpanded;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          color: appColors.gray_900, // Same grey as navbar hole #212121
          borderRadius: BorderRadius.circular(8.h),
          border: Border.all(
            color: isExpanded
                ? appColors.orange_200 // Golden stroke when expanded
                : appColors.gray_700.withAlpha((0.3 * 255).round()),
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
                MosqueImageTile(
                  imageUrl: widget.mosque.imageUrl,
                  isExpanded: isExpanded,
                ),

                SizedBox(width: 8.h),

                // Mosque info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.mosque.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: appColors.whiteA700,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.fSize,
                          letterSpacing: -0.23,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        widget.mosque.address,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: appColors.whiteA700
                              .withAlpha((0.7 * 255).round()),
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
                      color: isExpanded ? appColors.orange_200 : null,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      widget.mosque.formattedDistance,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isExpanded
                            ? appColors.orange_200
                            : appColors.whiteA700
                                .withAlpha((0.7 * 255).round()),
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
                      color: appColors.orange_200,
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
                            child: MosqueActionButton(
                              label: 'Search Google',
                              icon: Icons.search,
                              onTap: widget.onSearchGoogle,
                            ),
                          ),
                          SizedBox(width: 8.h),
                          Expanded(
                            child: MosqueActionButton(
                              label: 'Open in Maps',
                              icon: Icons.directions,
                              onTap: widget.onMapTap,
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

  // Action button builder moved to MosqueActionButton widget.
}
