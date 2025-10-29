import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => TextStyle(
        fontSize: 20.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      );

  TextStyle get title20BoldPoppins => TextStyle(
        fontSize: 20.fSize,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
        color: appTheme.whiteA700,
      );

  TextStyle get title18SemiBoldPoppins => TextStyle(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: appTheme.whiteA700,
      );

  TextStyle get title17RegularSuraNames => TextStyle(
        fontSize: 17.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'sura_names',
        color: appTheme.orange_200,
      );

  // Body Styles
  // Standard text styles for body content

  TextStyle get body15RegularPoppins => TextStyle(
        fontSize: 15.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
      );

  TextStyle get body15MediumNotoKufiArabic => TextStyle(
        fontSize: 15.fSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Noto Kufi Arabic',
        color: appTheme.whiteA700,
      );

  TextStyle get body14SemiBoldPoppins => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: appTheme.whiteA700,
      );

  TextStyle get body12RegularPoppins => TextStyle(
        fontSize: 12.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: appTheme.whiteA700,
      );

  TextStyle get body12SemiBoldPoppins => TextStyle(
        fontSize: 12.fSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: appTheme.whiteA700,
      );

  // Label Styles
  // Small text styles for labels, captions, and hints

  TextStyle get label10LightPoppins => TextStyle(
        fontSize: 10.fSize,
        fontWeight: FontWeight.w300,
        fontFamily: 'Poppins',
        color: appTheme.whiteA700,
      );
}
