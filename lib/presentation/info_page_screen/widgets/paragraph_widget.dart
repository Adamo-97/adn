import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

/// Widget for rendering paragraph content in info pages
/// Supports optional illustrations placed above the text
class ParagraphWidget extends StatelessWidget {
  final String text;
  final String? illustrationPath;

  const ParagraphWidget({
    super.key,
    required this.text,
    this.illustrationPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display illustration if provided
          if (illustrationPath != null && illustrationPath!.isNotEmpty) ...[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 16.h),
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: appColors.gray_700.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12.h),
                ),
                child: CustomImageView(
                  imagePath: illustrationPath!,
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],

          // Paragraph text
          Text(
            text,
            style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
              fontSize: 14.fSize,
              color: appColors.whiteA700.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
