import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/info_page_section.dart';

/// Widget for rendering bulleted lists in info pages
/// Each item is displayed with a bullet point
/// Supports both plain text and formatted text with Arabic fonts
class ListItemWidget extends StatelessWidget {
  final List<dynamic> items; // Can be String or Map with formatted_text

  const ListItemWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          if (item is String) {
            return _buildListItem(item, null);
          } else if (item is Map<String, dynamic>) {
            final listItemData = ListItemData.fromJson(item);
            return _buildListItem(
              listItemData.plainText ?? '',
              listItemData.formattedText,
            );
          }
          return const SizedBox.shrink();
        }).toList(),
      ),
    );
  }

  /// Build a single list item with bullet point
  /// Supports both plain text and formatted text with Arabic fonts
  /// Quranic verses are centered with brackets, translations in italic
  Widget _buildListItem(String plainText, List<TextSegment>? formattedText) {
    // For formatted list items with Quran verses, don't use bullet - render as full-width
    if (formattedText != null &&
        formattedText.any((s) => s.type == 'quran_verse')) {
      return Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: _buildFormattedListItem(formattedText),
      );
    }

    // Regular list item with bullet
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet point
          Padding(
            padding: EdgeInsets.only(top: 7.h, right: 12.h),
            child: Container(
              width: 5.h,
              height: 5.h,
              decoration: BoxDecoration(
                color: appColors.whiteA700.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // List item text - use formatted text if available
          Expanded(
            child: formattedText != null && formattedText.isNotEmpty
                ? _buildInlineFormattedText(formattedText)
                : Text(
                    plainText,
                    style:
                        TextStyleHelper.instance.body15RegularPoppins.copyWith(
                      fontSize: 14.fSize,
                      color: appColors.whiteA700.withValues(alpha: 0.9),
                      height: 1.5,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// Build formatted list item with Quran verse (no bullet, full width)
  Widget _buildFormattedListItem(List<TextSegment> segments) {
    List<Widget> widgets = [];

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];

      if (segment.type == 'quran_verse') {
        // Add the Quranic verse centered with brackets
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
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
      } else if (segment.type == 'english_text' &&
          segment.text.trim().isNotEmpty) {
        // Translation in italic
        widgets.add(
          Text(
            segment.text.trim(),
            textAlign: TextAlign.center,
            style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
              fontSize: 14.fSize,
              color: appColors.whiteA700.withValues(alpha: 0.85),
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  /// Build inline formatted text for list items (with bullet)
  Widget _buildInlineFormattedText(List<TextSegment> segments) {
    // Check if contains Arabic text
    bool hasArabic = segments.any((s) => s.type == 'arabic_text');

    if (hasArabic) {
      // Render Arabic and English separately
      List<Widget> widgets = [];

      for (var segment in segments) {
        if (segment.type == 'arabic_text') {
          widgets.add(
            Align(
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
          );
        } else if (segment.text.trim().isNotEmpty) {
          widgets.add(
            Text(
              segment.text.trim(),
              textAlign: TextAlign.left,
              style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                fontSize: 14.fSize,
                color: appColors.whiteA700.withValues(alpha: 0.9),
                height: 1.5,
              ),
            ),
          );
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widgets,
      );
    }

    // Regular inline text
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
