import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

/// Header widget that displays only the page title with consistent styling
/// across all app pages. Matches the design pattern used in Salah Guide,
/// Nearby Mosques, and Profile Settings screens.
class FixedPrayerHeader extends StatelessWidget {
  const FixedPrayerHeader({
    super.key,
    required this.topInset,
    required this.totalHeight,
  });

  final double topInset;
  final double totalHeight;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: totalHeight,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.gray_900,
          border: Border(
            bottom: BorderSide(
              color: appColors.gray_700.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        padding: EdgeInsets.fromLTRB(20.h, topInset + 16.h, 20.h, 16.h),
        child: Center(
          child: Text(
            'Prayers',
            style: TextStyleHelper.instance.title20BoldPoppins.copyWith(
              color: appColors.whiteA700,
              fontSize: 22.fSize,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
