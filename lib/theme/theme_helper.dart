import 'package:flutter/material.dart';

// New, clearer name for the color palette getter. Use `appColors` in new code.
DarkCodeColors get appColors => ThemeHelper().themeColor();

// Theme helper internals
// Use `appColors` for palette access.

ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

class ThemeHelper {
  // The current selected theme key.
  // NOTE: Historically this project used the name "lightCode" for the
  // dark palette. We now use `darkCode` as the active key and the
  // `DarkCodeColors` class name to make intent clearer.
  final _activeTheme = "darkCode";

  // A map of custom color themes supported by the app
  final Map<String, DarkCodeColors> _supportedCustomColor = {
    'lightCode': DarkCodeColors(),
    // Provide a darkCode entry that re-uses the same color container.
    'darkCode': DarkCodeColors(),
  };

  // A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
    'darkCode': ColorSchemes.darkCodeColorScheme,
  };

  /// Returns the colors for the current theme (this object contains the
  /// app color palette used for dark mode).
  DarkCodeColors _getThemeColors() {
    return _supportedCustomColor[_activeTheme] ?? DarkCodeColors();
  }

  /// Returns the current theme data based on the selected color scheme.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_activeTheme] ?? ColorSchemes.darkCodeColorScheme;

    final colors = _getThemeColors();

    // Build a complete dark ThemeData using the palette values.
    return ThemeData.dark().copyWith(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.gray_900_01,
      primaryColor: colors.orange_200,
      cardColor: colors.gray_900,
      canvasColor: colors.gray_900,
      dividerColor: colors.gray_700.withAlpha((0.2 * 255).round()),
      iconTheme: IconThemeData(color: colors.whiteA700),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.gray_900,
        foregroundColor: colors.whiteA700,
        elevation: 0,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: colors.whiteA700),
        displayMedium: TextStyle(color: colors.whiteA700),
        displaySmall: TextStyle(color: colors.whiteA700),
        headlineMedium: TextStyle(color: colors.whiteA700),
        headlineSmall: TextStyle(color: colors.whiteA700),
        titleLarge: TextStyle(color: colors.whiteA700),
        bodyLarge: TextStyle(color: colors.whiteA700),
        bodyMedium: TextStyle(color: colors.gray_100),
        bodySmall: TextStyle(color: colors.gray_100),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.orange_200,
          foregroundColor: colors.gray_900,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colors.orange_200),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.gray_900.withAlpha((0.05 * 255).round()),
        hintStyle: TextStyle(color: colors.gray_600),
        labelStyle: TextStyle(color: colors.gray_100),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: colors.gray_700.withAlpha((0.3 * 255).round())),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.orange_200),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.orange_200,
        foregroundColor: colors.gray_900,
      ),
    );
  }

  /// Returns the colors for the current theme.
  DarkCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light();

  // Dark variant that should be used by the app's dark mode.
  static final darkCodeColorScheme = ColorScheme.dark(
    primary: DarkCodeColors().orange_200,
    onPrimary: DarkCodeColors().gray_900,
    secondary: DarkCodeColors().gray_700,
    onSecondary: DarkCodeColors().color7FFFFF,
    surface: DarkCodeColors().gray_900,
    onSurface: DarkCodeColors().gray_100,
    error: DarkCodeColors().redCustom,
  );
}

class DarkCodeColors {
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

  // Salah Guide category accent colors
  /// Accent color for the "Essentials" category (Teal)
  Color get salahEssentials => Color(0xFF4DB6AC);

  /// Accent color for the "Optional Prayers" category (Gold)
  Color get salahOptionalPrayers => Color(0xFFE0C389);

  /// Accent color for the "Special Situations" category (Deep Orange/Coral)
  Color get salahSpecialSituations => Color(0xFFFF7043);

  /// Accent color for the "Purification" category (Green)
  Color get salahPurification => Color(0xFF8F9B87);

  /// Accent color for the "Rituals" category (Purple/Violet)
  Color get salahRituals => Color(0xFFAB87CE);

  // Color Shades - Each shade has its own dedicated constant
  Color get grey200 => Colors.grey.shade200;
  Color get grey100 => Colors.grey.shade100;
}
