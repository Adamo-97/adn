import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

/// Widget for the divider line separating header from content
/// Uses accent color for visual consistency
class InfoPageDivider extends StatelessWidget {
  final Color accentColor;

  const InfoPageDivider({
    super.key,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.h,
      width: double.infinity,
      color: accentColor,
    );
  }
}
