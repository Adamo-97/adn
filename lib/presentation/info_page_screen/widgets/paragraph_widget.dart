import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/info_page_section.dart';

/// Widget for rendering paragraph content in info pages
/// Supports optional illustrations placed above the text
/// Handles formatted text with Arabic fonts and RTL layout
class ParagraphWidget extends StatelessWidget {
  final String text;
  final String? illustrationPath;
  final List<TextSegment>? formattedText;

  const ParagraphWidget({
    super.key,
    required this.text,
    this.illustrationPath,
    this.formattedText,
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

          // Paragraph text - use formatted text if available
          if (formattedText != null && formattedText!.isNotEmpty)
            _buildFormattedText()
          else
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

  /// Build formatted text with proper fonts and RTL support
  Widget _buildFormattedText() {
    return RichText(
      textDirection: TextDirection.ltr, // Container is LTR
      text: TextSpan(
        children: formattedText!.map((segment) {
          return _buildTextSegment(segment);
        }).toList(),
      ),
    );
  }

  /// Build a single text segment with appropriate font and direction
  TextSpan _buildTextSegment(TextSegment segment) {
    final type = segment.type;
    final text = segment.text;

    if (type == 'quran_verse') {
      // Quranic verse - use Amiri Quran font with RTL
      return TextSpan(
        text: text,
        style: TextStyleHelper.instance.body16RegularAmiriQuran.copyWith(
          fontSize: 16.fSize,
          color: appColors.whiteA700.withValues(alpha: 0.95),
          height: 1.8,
        ),
        locale: const Locale('ar'),
      );
    } else if (type == 'arabic_text') {
      // Non-Quranic Arabic - use Noto Kufi Arabic font with RTL
      return TextSpan(
        text: text,
        style: TextStyleHelper.instance.body15MediumNotoKufiArabic.copyWith(
          fontSize: 15.fSize,
          color: appColors.whiteA700.withValues(alpha: 0.95),
          height: 1.7,
        ),
        locale: const Locale('ar'),
      );
    } else {
      // English text - use default Poppins font
      return TextSpan(
        text: text,
        style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
          fontSize: 14.fSize,
          color: appColors.whiteA700.withValues(alpha: 0.9),
          height: 1.5,
        ),
      );
    }
  }
}
