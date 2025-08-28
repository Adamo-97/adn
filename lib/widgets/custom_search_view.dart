import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomSearchView - A reusable search input widget with customizable icons and styling
 * 
 * This widget provides a text input field specifically designed for search functionality,
 * featuring left and right icons, custom placeholder text, and consistent bottom border styling.
 * 
 * @param controller - TextEditingController for managing input text
 * @param hintText - Placeholder text displayed when field is empty
 * @param prefixIconPath - Path to the left icon (search icon)
 * @param suffixIconPath - Path to the right icon (action icon)
 * @param onChanged - Callback function when text changes
 * @param onSubmitted - Callback function when user submits text
 * @param validator - Validation function for form validation
 * @param keyboardType - Type of keyboard to display
 * @param contentPadding - Internal padding of the text field
 */
class CustomSearchView extends StatelessWidget {
  CustomSearchView({
    Key? key,
    this.controller,
    this.hintText,
    this.prefixIconPath,
    this.suffixIconPath,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.keyboardType,
    this.contentPadding,
    this.prefixIconSize,
    this.suffixIconSize,
  }) : super(key: key);

  /// Controller for managing the text input
  final TextEditingController? controller;

  /// Placeholder text shown when the field is empty
  final String? hintText;

  /// Path to the prefix (left) icon
  final String? prefixIconPath;

  /// Path to the suffix (right) icon
  final String? suffixIconPath;

  /// Callback function triggered when text changes
  final Function(String)? onChanged;

  /// Callback function triggered when user submits the text
  final Function(String)? onSubmitted;

  /// Validation function for form validation
  final String? Function(String?)? validator;

  /// Type of keyboard to display
  final TextInputType? keyboardType;

  /// Internal padding of the text field
  final EdgeInsetsGeometry? contentPadding;

  /// Size of the prefix icon
  final Size? prefixIconSize;

  /// Size of the suffix icon
  final Size? suffixIconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10.h,
        left: 24.h,
        right: 24.h,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        validator: validator,
        style: TextStyleHelper.instance.body12RegularPoppins
            .copyWith(color: appTheme.color7FFFFF, height: 1.5),
        decoration: InputDecoration(
          hintText: hintText ?? "Search...",
          hintStyle: TextStyleHelper.instance.body12RegularPoppins
              .copyWith(color: appTheme.color7FFFFF, height: 1.5),
          prefixIcon: prefixIconPath != null
              ? Padding(
                  padding: EdgeInsets.all(8.h),
                  child: CustomImageView(
                    imagePath: prefixIconPath!,
                    height: prefixIconSize?.height ?? 26.h,
                    width: prefixIconSize?.width ?? 32.h,
                    fit: BoxFit.contain,
                  ),
                )
              : null,
          suffixIcon: suffixIconPath != null
              ? Padding(
                  padding: EdgeInsets.all(8.h),
                  child: CustomImageView(
                    imagePath: suffixIconPath!,
                    height: suffixIconSize?.height ?? 26.h,
                    width: suffixIconSize?.width ?? 20.h,
                    fit: BoxFit.contain,
                  ),
                )
              : null,
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(
                vertical: 16.h,
                horizontal: 40.h,
              ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: appTheme.color48195C,
              width: 1.h,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: appTheme.color48195C,
              width: 1.h,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: appTheme.color48195C,
              width: 1.h,
            ),
          ),
        ),
      ),
    );
  }
}
