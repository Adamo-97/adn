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
  Widget _buildListItem(String plainText, List<TextSegment>? formattedText) {
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
                ? _buildFormattedText(formattedText)
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

  /// Build formatted text with proper fonts and RTL support
  Widget _buildFormattedText(List<TextSegment> segments) {
    return RichText(
      textDirection: TextDirection.ltr, // Container is LTR
      text: TextSpan(
        children: segments.map((segment) {
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
