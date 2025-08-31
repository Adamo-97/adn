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
  const CustomBottomBar({
    Key? key,
    required this.bottomBarItemList,
    required this.onChanged,
    this.selectedIndex = 0,
    this.backgroundColor,   // NOTE: ignored — outer wrapper paints bg
    this.borderRadius,      // NOTE: ignored — outer wrapper clips corners
    this.height,
    this.horizontalPadding,
  }) : super(key: key);

  /// List of bottom bar items with their properties
  final List<CustomBottomBarItem> bottomBarItemList;

  /// Current selected index of the bottom bar
  final int selectedIndex;

  /// Callback function triggered when a bottom bar item is tapped
  final Function(int) onChanged;

  /// Background color of the bottom bar (ignored)
  final Color? backgroundColor;

  /// Border radius for the bottom bar container (ignored)
  final BorderRadius? borderRadius;

  /// Height of the bottom bar
  final double? height;

  /// Horizontal padding inside the bottom bar
  final double? horizontalPadding;

  @override
  Size get preferredSize => Size.fromHeight(height ?? 76.h);

  @override
  Widget build(BuildContext context) {
    // Colors per spec
    const goldActive = Color(0xFFE0C389);        // selected icon (gold)
    const lightGreenCircle = Color(0xFF8F9B87);  // selected circle (light green)
    final holeColor = appTheme.gray_900;         // #212121 — true cutout color
    final liftY = 12.h;                          // lift selected a bit higher
    final notchTop = 0.h;                       // notch slightly above top edge
    final bottomPad = 10.h;                      // bottom padding inside the bar

    // Transparent — the outer wrapper paints the olive rectangle.
    return SizedBox(
      height: height ?? 76.h,
      child: Padding(
        // keep your horizontal padding + add bottom padding
        padding: EdgeInsets.fromLTRB(
          horizontalPadding ?? 14.h,
          0,
          horizontalPadding ?? 14.h,
          bottomPad,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final count = bottomBarItemList.length;
            final rowWidth = constraints.maxWidth;
            final cellWidth = rowWidth / count;
            // Center X of selected cell inside the padded area
            final notchCenterX = cellWidth * (selectedIndex + 0.5);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // --- Moving notch behind the selected item (visible dark cutout) ---
                Positioned(
                  top: notchTop, // nudge up so it reads as a “cutout”
                  left: notchCenterX - (110.h / 2), // 110.h = asset width
                  child: CustomImageView(
                    imagePath: ImageConstant.imgSubtract,
                    height: 58.h,  // asset height
                    width: 110.h,  // asset width
                    // dark “hole” — match page/dark background exactly
                    color: holeColor,
                  ),
                ),

                // --- Row of items on top ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(count, (index) {
                    final isSelected = selectedIndex == index;
                    final item = bottomBarItemList[index];
                    return Expanded(
                      child: InkWell(
                        onTap: () => onChanged(index),
                        child: _buildBottomBarItem(
                          item,
                          isSelected,
                          index,
                          goldActive,
                          lightGreenCircle,
                          liftY,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomBarItem(
    CustomBottomBarItem item,
    bool isSelected,
    int index,
    Color goldActive,
    Color lightGreenCircle,
    double liftY,
  ) {
    final icon = CustomImageView(
      imagePath: isSelected && item.activeIcon != null ? item.activeIcon! : item.icon,
      height: (item.height ?? 30.h),
      width: (item.width ?? 34.h),
      fit: BoxFit.contain,
      color: isSelected ? goldActive : appTheme.white_A700,
    );

    if (!isSelected) {
      return Container(alignment: Alignment.center, child: icon);
    }

    // Selected: center icon in a light-green circle and lift both slightly.
    // TODO: If the notch appears 1px off on certain devices, tweak `notchTop` +/- 2.h.
    return Transform.translate(
      offset: Offset(0, -liftY),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 46.h,
            width: 46.h,
            decoration: BoxDecoration(
              color: lightGreenCircle,
              shape: BoxShape.circle,
            ),
          ),
          icon,
        ],
      ),
    );
  }
}

/// Item data model for custom bottom bar
class CustomBottomBarItem {
  const CustomBottomBarItem({
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
