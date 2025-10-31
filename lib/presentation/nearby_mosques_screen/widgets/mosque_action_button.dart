import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

/// Reusable action button used inside mosque cards
class MosqueActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const MosqueActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.h),
        decoration: BoxDecoration(
          color: appColors.gray_900,
          borderRadius: BorderRadius.circular(6.h),
          border: Border.all(
            color: appColors.orange_200.withAlpha((0.3 * 255).round()),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14.h,
              color: appColors.orange_200,
            ),
            SizedBox(width: 6.h),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: appColors.whiteA700,
                fontSize: 10.fSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
