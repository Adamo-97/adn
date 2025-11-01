import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

/// Custom app bar for info pages
/// Displays page title with back button and share icon
/// Colors adapt based on category accent color
class InfoPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color accentColor;
  final VoidCallback onBackPressed;

  const InfoPageAppBar({
    super.key,
    required this.title,
    required this.accentColor,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appColors.gray_900,
      elevation: 0,
      leading: GestureDetector(
        onTap: onBackPressed,
        child: Container(
          width: 44.h,
          height: 44.h,
          alignment: Alignment.center,
          child: CustomImageView(
            imagePath: ImageConstant.imgInfoPageBackButton,
            color: accentColor,
            width: 24.h,
            height: 24.h,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyleHelper.instance.body14SemiBoldPoppins.copyWith(
          color: appColors.whiteA700,
          fontSize: 17.fSize,
        ),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () => _handleShare(context),
          child: Container(
            width: 44.h,
            height: 44.h,
            alignment: Alignment.center,
            child: CustomImageView(
              imagePath: ImageConstant.imgInfoPageShareIcon,
              color: accentColor,
              width: 24.h,
              height: 24.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  /// Handle share functionality
  /// TODO: Implement share functionality using share_plus package
  void _handleShare(BuildContext context) {
    // Placeholder for share functionality
    // Will be implemented with share_plus package in future
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share functionality coming soon'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
