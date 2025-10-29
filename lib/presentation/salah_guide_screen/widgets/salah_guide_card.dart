import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/salah_guide_card_model.dart';

class SalahGuideCard extends StatelessWidget {
  final SalahGuideCardModel card;
  final VoidCallback? onTap;

  const SalahGuideCard({
    super.key,
    required this.card,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final category = card.category;
    final accentColor = category?.accentColor ?? const Color(0xFF8F9B87);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.h,
        margin: EdgeInsets.only(right: 12.h),
        decoration: BoxDecoration(
          color: accentColor.withAlpha((0.15 * 255).round()),
          borderRadius: BorderRadius.circular(16.h),
          border: Border.all(
            color: accentColor.withAlpha((0.5 * 255).round()),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withAlpha((0.3 * 255).round()),
              blurRadius: 8,
              offset: Offset(0, 0),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.h),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      appTheme.gray_900.withAlpha((0.3 * 255).round()),
                      appTheme.gray_900.withAlpha((0.6 * 255).round()),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon at top
                  Container(
                    padding: EdgeInsets.all(12.h),
                    decoration: BoxDecoration(
                      color: appTheme.gray_900.withAlpha((0.4 * 255).round()),
                      borderRadius: BorderRadius.circular(12.h),
                      border: Border.all(
                        color: accentColor.withAlpha((0.3 * 255).round()),
                        width: 1,
                      ),
                    ),
                    child: CustomImageView(
                      imagePath: card.iconPath ?? '',
                      height: 32.h,
                      width: 32.h,
                      color: appTheme.whiteA700,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Title at bottom
                  Text(
                    card.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyleHelper.instance.body15RegularPoppins.copyWith(
                      color: appTheme.whiteA700,
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // Accent border on top
            Positioned(
              top: 0,
              left: 20.h,
              right: 20.h,
              child: Container(
                height: 3.h,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(2.h),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
