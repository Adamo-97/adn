import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

/// Widget for rendering bulleted lists in info pages
/// Each item is displayed with a bullet point
class ListItemWidget extends StatelessWidget {
  final List<String> items;

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
        children: items.map((item) => _buildListItem(item)).toList(),
      ),
    );
  }

  /// Build a single list item with bullet point
  Widget _buildListItem(String item) {
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

          // List item text
          Expanded(
            child: Text(
              item,
              style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
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
}
