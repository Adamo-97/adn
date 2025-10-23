import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomBottomBar - A customizable bottom navigation bar component with liquid animations
 * 
 * Features:
 * - Liquid morph animation on tab selection
 * - Icon rising animation with smooth curves
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
class CustomBottomBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomBottomBar({
    Key? key,
    required this.bottomBarItemList,
    required this.onChanged,
    this.selectedIndex = 0,
    this.backgroundColor,
    this.borderRadius,
    this.height,
    this.horizontalPadding,
  }) : super(key: key);

  final List<CustomBottomBarItem> bottomBarItemList;
  final int selectedIndex;
  final Function(int) onChanged;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double? height;
  final double? horizontalPadding;

  @override
  Size get preferredSize => Size.fromHeight(height ?? 76.h);

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with TickerProviderStateMixin {
  late AnimationController _liquidController;
  late AnimationController _iconRiseController;
  late Animation<double> _liquidAnimation;
  late Animation<double> _iconRiseAnimation;
  late Animation<double> _circleScaleAnimation;

  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.selectedIndex;

    // Liquid morph animation (300ms)
    _liquidController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 1.0, // Start at full position so it's visible on first load
    );

    // Icon rise animation (400ms with delay)
    _iconRiseController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
      value: 1.0, // Start at full value so icon is visible on first load
    );

    // Liquid bubble effect with elastic curve
    _liquidAnimation = CurvedAnimation(
      parent: _liquidController,
      curve: Curves.easeInOutCubic,
    );

    // Icon rising with ease out curve (no overshoot)
    _iconRiseAnimation = CurvedAnimation(
      parent: _iconRiseController,
      curve: Curves.easeOut,
    );

    // Circle scale animation
    _circleScaleAnimation = CurvedAnimation(
      parent: _iconRiseController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _previousIndex = oldWidget.selectedIndex;

      // Reset icon rise controller to 0 BEFORE the build happens
      _iconRiseController.value = 0.0;

      _playLiquidAnimation();
    }
  }

  void _playLiquidAnimation() {
    _liquidController.forward(from: 0.0);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        _iconRiseController.forward(from: _iconRiseController.value);
      }
    });
  }

  @override
  void dispose() {
    _liquidController.dispose();
    _iconRiseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const goldActive = Color(0xFFE0C389);
    const lightGreenCircle = Color(0xFF8F9B87);
    final holeColor = appTheme.gray_900;
    final liftY = 12.h;
    final notchTop = 0.h;
    final bottomPad = 10.h;

    return SizedBox(
      height: widget.height ?? 76.h,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          widget.horizontalPadding ?? 14.h,
          0,
          widget.horizontalPadding ?? 14.h,
          bottomPad,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final count = widget.bottomBarItemList.length;
            final rowWidth = constraints.maxWidth;
            final cellWidth = rowWidth / count;

            // Animated notch position
            final targetX = cellWidth * (widget.selectedIndex + 0.5);
            final previousX = cellWidth * (_previousIndex + 0.5);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Animated liquid notch
                AnimatedBuilder(
                  animation: _liquidAnimation,
                  builder: (context, child) {
                    final currentX = previousX +
                        (targetX - previousX) * _liquidAnimation.value;

                    return Positioned(
                      top: notchTop,
                      left: currentX - (110.h / 2),
                      child: Transform.scale(
                        scale: 1.0 +
                            (_liquidAnimation.value *
                                0.2 *
                                (1 - _liquidAnimation.value) *
                                4),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgSubtract,
                          height: 58.h,
                          width: 110.h,
                          color: holeColor,
                        ),
                      ),
                    );
                  },
                ),

                // Row of items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(count, (index) {
                    final isSelected = widget.selectedIndex == index;
                    final item = widget.bottomBarItemList[index];
                    return Expanded(
                      child: InkWell(
                        onTap: () => widget.onChanged(index),
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
      imagePath:
          isSelected && item.activeIcon != null ? item.activeIcon! : item.icon,
      height: (item.height ?? 30.h),
      width: (item.width ?? 34.h),
      fit: BoxFit.contain,
      color: isSelected ? goldActive : appTheme.white_A700,
    );

    if (!isSelected) {
      return Container(alignment: Alignment.center, child: icon);
    }

    // Selected: animated icon rise with circle scale
    return AnimatedBuilder(
      animation: Listenable.merge([_iconRiseAnimation, _circleScaleAnimation]),
      builder: (context, child) {
        // Rise from bottom: start at +30 (below) and animate to 0 (final position)
        final riseOffset = (1 - _iconRiseAnimation.value) * 30.h;
        final circleScale = _circleScaleAnimation.value;
        final opacity = _iconRiseAnimation.value.clamp(0.0, 1.0);

        return Transform.translate(
          // Negative liftY to lift icon up into notch, positive riseOffset to start from bottom
          offset: Offset(0, -liftY + riseOffset),
          child: Opacity(
            opacity: opacity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: circleScale,
                  child: Container(
                    height: 46.h,
                    width: 46.h,
                    decoration: BoxDecoration(
                      color: lightGreenCircle,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                icon,
              ],
            ),
          ),
        );
      },
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

  final String icon;
  final String? activeIcon;
  final String? title;
  final String routeName;
  final double? height;
  final double? width;
  final bool isSpecialItem;
}
