import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/// CustomTextFieldWithIcon - A reusable text input field component with optional left icon
///
/// This component provides a TextFormField with customizable left icon, placeholder text,
/// text styling, and validation support. It's designed to be responsive and follows
/// Material Design guidelines.
///
/// @param controller - TextEditingController for managing text input
/// @param hintText - Placeholder text displayed when field is empty
/// @param leftIcon - Path to the left icon image (SVG/PNG supported)
/// @param textStyle - Custom text style for the input text
/// @param hintStyle - Custom text style for the hint text
/// @param validator - Validation function for form validation
/// @param keyboardType - Type of keyboard to show for input
/// @param onTap - Callback function when field is tapped
/// @param readOnly - Whether the field is read-only
/// @param enabled - Whether the field is enabled for interaction
class CustomTextFieldWithIcon extends StatelessWidget {
  const CustomTextFieldWithIcon({
    super.key,
    this.controller,
    this.hintText,
    this.leftIcon,
    this.textStyle,
    this.hintStyle,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.readOnly,
    this.enabled,
  });

  /// Controller for managing text input
  final TextEditingController? controller;

  /// Placeholder text displayed when field is empty
  final String? hintText;

  /// Path to the left icon image
  final String? leftIcon;

  /// Custom text style for input text
  final TextStyle? textStyle;

  /// Custom text style for hint text
  final TextStyle? hintStyle;

  /// Validation function for form validation
  final String? Function(String?)? validator;

  /// Type of keyboard to show
  final TextInputType? keyboardType;

  /// Callback when field is tapped
  final VoidCallback? onTap;

  /// Whether field is read-only
  final bool? readOnly;

  /// Whether field is enabled
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      child: TextFormField(
        controller: controller,
        style: textStyle ??
            TextStyleHelper.instance.body15RegularPoppins
                .copyWith(color: appColors.whiteA700),
        decoration: InputDecoration(
          hintText: hintText ?? "Enter text",
          hintStyle: hintStyle ??
              TextStyleHelper.instance.body15RegularPoppins
                  .copyWith(color: Color(0xFFFFFFFF).withAlpha(179)),
          prefixIcon: leftIcon != null
              ? Container(
                  padding: EdgeInsets.all(12.h),
                  child: CustomImageView(
                    imagePath: leftIcon!,
                    height: 14.h,
                    width: 14.h,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(
            top: 4.h,
            right: 12.h,
            bottom: 4.h,
            left: leftIcon != null ? 0.h : 12.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.h),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.h),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.h),
            borderSide: BorderSide(
              color: Color(0xFFFFFFFF).withAlpha(77),
              width: 1.h,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.h),
            borderSide: BorderSide(
              color: appColors.redCustom,
              width: 1.h,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.h),
            borderSide: BorderSide(
              color: appColors.redCustom,
              width: 1.h,
            ),
          ),
          filled: true,
          fillColor: appColors.transparentCustom,
        ),
        validator: validator,
        keyboardType: keyboardType ?? TextInputType.text,
        onTap: onTap,
        readOnly: readOnly ?? false,
        enabled: enabled ?? true,
      ),
    );
  }
}
