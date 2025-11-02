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
  /// Quranic verses are centered on their own line with brackets
  /// Translations are in italic below the verse
  Widget _buildFormattedText() {
    List<Widget> widgets = [];
    List<TextSegment> currentLineSegments = [];
    bool hasQuranVerse = false;

    for (int i = 0; i < formattedText!.length; i++) {
      final segment = formattedText![i];

      if (segment.type == 'quran_verse') {
        // Flush any pending segments before the verse
        if (currentLineSegments.isNotEmpty) {
          widgets.add(_buildInlineText(currentLineSegments));
          currentLineSegments = [];
        }

        // Add the Quranic verse centered with brackets
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Center(
              child: Text(
                '﴿${segment.text}﴾',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style:
                    TextStyleHelper.instance.body16RegularAmiriQuran.copyWith(
                  fontSize: 18.fSize,
                  color: appColors.whiteA700.withValues(alpha: 0.95),
                  height: 1.8,
                ),
              ),
            ),
          ),
        );
        hasQuranVerse = true;
      } else if (segment.type == 'english_text' &&
          hasQuranVerse &&
          segment.text.trim().startsWith('"')) {
        // This is likely a translation after a Quran verse - make it italic
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Text(
              segment.text.trim(),
              textAlign: TextAlign.center,
              style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                fontSize: 14.fSize,
                color: appColors.whiteA700.withValues(alpha: 0.85),
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        );
        hasQuranVerse = false; // Reset after translation
      } else if (segment.type == 'arabic_text') {
        // Flush any pending English segments
        if (currentLineSegments.isNotEmpty &&
            currentLineSegments.last.type == 'english_text') {
          widgets.add(_buildInlineText(currentLineSegments));
          currentLineSegments = [];
        }

        // Add Arabic text on its own line, RTL aligned
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                segment.text,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyleHelper.instance.body16MediumNotoKufiArabic
                    .copyWith(
                  fontSize: 16.fSize,
                  color: appColors.whiteA700.withValues(alpha: 0.95),
                  height: 1.7,
                ),
              ),
            ),
          ),
        );
        hasQuranVerse = false;
      } else {
        // Regular English text - accumulate for inline display
        currentLineSegments.add(segment);
      }
    }

    // Flush any remaining segments
    if (currentLineSegments.isNotEmpty) {
      widgets.add(_buildInlineText(currentLineSegments));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  /// Build inline text for English segments (LTR)
  Widget _buildInlineText(List<TextSegment> segments) {
    return RichText(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        children: segments.map((segment) {
          return TextSpan(
            text: segment.text,
            style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
              fontSize: 14.fSize,
              color: appColors.whiteA700.withValues(alpha: 0.9),
              height: 1.5,
            ),
          );
        }).toList(),
      ),
    );
  }
}
