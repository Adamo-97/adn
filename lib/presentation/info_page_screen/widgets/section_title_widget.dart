import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

/// Widget for rendering section titles in info pages
/// Uses accent color for visual indicator bar
class SectionTitleWidget extends StatelessWidget {
  final String text;
  final Color accentColor;

  const SectionTitleWidget({
    super.key,
    required this.text,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 12.h,
      ),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
          fontSize: 15.fSize,
          fontWeight: FontWeight.w600,
          color: accentColor,
        ),
      ),
    );
  }
}
