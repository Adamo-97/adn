import 'package:flutter/material.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  final _appTheme = "lightCode";

  // A map of custom color themes supported by the app
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

  // A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light();
}

class LightCodeColors {
  // App Colors
  Color get whiteA700 => Color(0xFFFFFFFF);
  Color get gray_700 => Color(0xFF5C6248);
  Color get gray_500 => Color(0xFF8F9B87);
  Color get orange_200 => Color(0xFFE0C389);
  Color get gray_900 => Color(0xFF212121);
  Color get black_900_19 => Color(0x19000000);
  Color get blueGray700 => Color(0xFF525252);
  Color get gray_900_01 => Color(0xFF121111);
  Color get gray_600 => Color(0xFF6E6E6E);
  Color get gray_100 => Color(0xFFF6F6F6);

  // Additional Colors
  Color get transparentCustom => Colors.transparent;
  Color get greyCustom => Colors.grey;
  Color get redCustom => Colors.red;
  Color get colorCCFFFF => Color(0xCCFFFFFF);
  Color get color195C62 => Color(0x195C6248);
  Color get color7FFFFF => Color(0x7FFFFFFF);
  Color get color48195C => Color(0x48195C62);

  // Color Shades - Each shade has its own dedicated constant
  Color get grey200 => Colors.grey.shade200;
  Color get grey100 => Colors.grey.shade100;
}
