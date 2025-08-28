import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomBottomBar - A customizable bottom navigation bar component
 * 
 * Features:
 * - Support for multiple navigation items with icons
 * - Special center icon with larger size
 * - Active/inactive states for navigation items
 * - Customizable styling and colors
 * - Navigation routing support
 * - Responsive design with proper scaling
 * 
 * @param bottomBarItemList - List of bottom bar navigation items
 * @param onChanged - Callback function when navigation item is tapped
 * @param selectedIndex - Currently selected navigation item index
 * @param backgroundColor - Background color of the bottom bar
 * @param borderRadius - Border radius for the bottom bar container
 * @param height - Height of the bottom bar
 * @param horizontalPadding - Horizontal padding inside the bottom bar
 */
class CustomBottomBar extends StatelessWidget implements PreferredSizeWidget {
  CustomBottomBar({
    Key? key,
    required this.bottomBarItemList,
    required this.onChanged,
    this.selectedIndex = 0,
    this.backgroundColor,
    this.borderRadius,
    this.height,
    this.horizontalPadding,
  }) : super(key: key);

  /// List of bottom bar items with their properties
  final List<CustomBottomBarItem> bottomBarItemList;

  /// Current selected index of the bottom bar
  final int selectedIndex;

  /// Callback function triggered when a bottom bar item is tapped
  final Function(int) onChanged;

  /// Background color of the bottom bar
  final Color? backgroundColor;

  /// Border radius for the bottom bar container
  final BorderRadius? borderRadius;

  /// Height of the bottom bar
  final double? height;

  /// Horizontal padding inside the bottom bar
  final double? horizontalPadding;

  @override
  Size get preferredSize => Size.fromHeight(height ?? 76.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 76.h,
      decoration: BoxDecoration(
        color: backgroundColor ?? Color(0xFF5C6248),
        borderRadius: borderRadius ??
            BorderRadius.only(
              topLeft: Radius.circular(10.h),
              topRight: Radius.circular(10.h),
              bottomLeft: Radius.circular(5.h),
              bottomRight: Radius.circular(5.h),
            ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(bottomBarItemList.length, (index) {
            final isSelected = selectedIndex == index;
            final item = bottomBarItemList[index];

            return Expanded(
              child: InkWell(
                onTap: () => onChanged(index),
                child: _buildBottomBarItem(item, isSelected, index),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBottomBarItem(
      CustomBottomBarItem item, bool isSelected, int index) {
    // Check if this is a special center item (larger icon)
    bool isSpecialItem = item.isSpecialItem ?? false;

    return Container(
      alignment: Alignment.center,
      child: CustomImageView(
        imagePath: isSelected && item.activeIcon != null
            ? item.activeIcon!
            : item.icon,
        height: isSpecialItem ? 58.h : (item.height ?? 30.h),
        width: isSpecialItem ? 110.h : (item.width ?? 34.h),
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Item data model for custom bottom bar
class CustomBottomBarItem {
  CustomBottomBarItem({
    required this.icon,
    required this.routeName,
    this.activeIcon,
    this.title,
    this.height,
    this.width,
    this.isSpecialItem = false,
  });

  /// Path to the icon (SVG or other image format)
  final String icon;

  /// Path to the active state icon (optional)
  final String? activeIcon;

  /// Title text for the navigation item (optional)
  final String? title;

  /// Route name for navigation
  final String routeName;

  /// Custom height for the icon
  final double? height;

  /// Custom width for the icon
  final double? width;

  /// Whether this is a special center item with larger size
  final bool isSpecialItem;
}
