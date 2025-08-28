import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/// Custom icon button widget with configurable styling and variants
///
/// Supports different sizes, colors, and border radius configurations
/// Uses CustomImageView for SVG icon rendering
///
/// @param iconPath - Path to the SVG icon asset
/// @param onPressed - Callback function when button is pressed
/// @param height - Height of the button (defaults based on variant)
/// @param width - Width of the button (defaults based on variant)
/// @param backgroundColor - Background color of the button
/// @param borderRadius - Border radius for rounded corners
/// @param padding - Internal padding around the icon
/// @param iconColor - Color tint for the icon
/// @param variant - Predefined styling variant (large or small)
class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    required this.iconPath,
    this.onPressed,
    this.height,
    this.width,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.iconColor,
    this.variant = CustomIconButtonVariant.large,
  }) : super(key: key);

  /// Path to the SVG icon asset
  final String iconPath;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Height of the button
  final double? height;

  /// Width of the button
  final double? width;

  /// Background color of the button
  final Color? backgroundColor;

  /// Border radius for rounded corners
  final double? borderRadius;

  /// Internal padding around the icon
  final EdgeInsetsGeometry? padding;

  /// Color tint for the icon
  final Color? iconColor;

  /// Predefined styling variant
  final CustomIconButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? _getDefaultHeight(),
      width: width ?? _getDefaultWidth(),
      decoration: BoxDecoration(
        color: backgroundColor ?? _getDefaultBackgroundColor(),
        borderRadius: BorderRadius.circular(
          borderRadius ?? _getDefaultBorderRadius(),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        padding: padding ?? _getDefaultPadding(),
        icon: CustomImageView(
          imagePath: iconPath,
          height: _getIconSize(),
          width: _getIconSize(),
          color: iconColor,
        ),
      ),
    );
  }

  /// Get default height based on variant
  double _getDefaultHeight() {
    switch (variant) {
      case CustomIconButtonVariant.large:
        return 56.h;
      case CustomIconButtonVariant.small:
        return 24.h;
    }
  }

  /// Get default width based on variant
  double _getDefaultWidth() {
    switch (variant) {
      case CustomIconButtonVariant.large:
        return 56.h;
      case CustomIconButtonVariant.small:
        return 24.h;
    }
  }

  /// Get default background color based on variant
  Color _getDefaultBackgroundColor() {
    switch (variant) {
      case CustomIconButtonVariant.large:
        return Color(0xFF8F9B87);
      case CustomIconButtonVariant.small:
        return Color(0xFFFFFFFF);
    }
  }

  /// Get default border radius based on variant
  double _getDefaultBorderRadius() {
    switch (variant) {
      case CustomIconButtonVariant.large:
        return 28.h;
      case CustomIconButtonVariant.small:
        return 12.h;
    }
  }

  /// Get default padding based on variant
  EdgeInsetsGeometry _getDefaultPadding() {
    switch (variant) {
      case CustomIconButtonVariant.large:
        return EdgeInsets.all(10.h);
      case CustomIconButtonVariant.small:
        return EdgeInsets.all(4.h);
    }
  }

  /// Get icon size based on variant
  double _getIconSize() {
    switch (variant) {
      case CustomIconButtonVariant.large:
        return 32.h;
      case CustomIconButtonVariant.small:
        return 16.h;
    }
  }
}

/// Enum for predefined icon button styling variants
enum CustomIconButtonVariant {
  /// Large icon button (56x56) with green background
  large,

  /// Small icon button (24x24) with white background
  small,
}
