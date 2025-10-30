import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

/// Reusable image tile for mosque cards
class MosqueImageTile extends StatelessWidget {
  final String? imageUrl;
  final bool isExpanded;

  const MosqueImageTile({
    super.key,
    required this.imageUrl,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 47.h,
      height: 47.h,
      decoration: BoxDecoration(
        color: appTheme.gray_900,
        borderRadius: BorderRadius.circular(3.h),
        border: Border.all(
          color: isExpanded
              ? appTheme.orange_200
              : appTheme.gray_700.withAlpha((0.5 * 255).round()),
          width: 1,
        ),
      ),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(3.h),
              child: CustomImageView(
                imagePath: imageUrl!,
                fit: BoxFit.cover,
                width: 47.h,
                height: 47.h,
              ),
            )
          : Center(
              child: Text(
                'No Image',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: appTheme.whiteA700.withAlpha((0.5 * 255).round()),
                  fontSize: 7.fSize,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}
