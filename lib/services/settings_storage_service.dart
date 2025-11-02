import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting user settings to device storage
///
/// Provides type-safe methods for storing and retrieving settings using SharedPreferences.
/// All settings are cached in memory after first load for faster access.
///
/// Settings stored:
/// - Dark mode preference (bool)
/// - Hijri calendar preference (bool)
/// - 24-hour time format preference (bool)
/// - Prayer reminders preference (bool)
/// - Selected location (String, format: "City, Country")
/// - Selected calculation method (int, 0-16)
/// - Selected Islamic school (int, 0=Standard, 1=Hanafi)
class SettingsStorageService {
  static const String _keyDarkMode = 'settings_dark_mode';
  static const String _keyHijriCalendar = 'settings_hijri_calendar';
  static const String _key24HourFormat = 'settings_24_hour_format';
  static const String _keyPrayerReminders = 'settings_prayer_reminders';
  static const String _keyLocation = 'settings_location';
  static const String _keyCalculationMethod = 'settings_calculation_method';
  static const String _keyIslamicSchool = 'settings_islamic_school';

  /// Default values for settings
  static const bool _defaultDarkMode = true;
  static const bool _defaultHijriCalendar = false;
  static const bool _default24HourFormat = false;
  static const bool _defaultPrayerReminders = true;
  static const String _defaultLocation = 'Stockholm, Sweden';
  static const int _defaultCalculationMethod = 3; // Muslim World League
  static const int _defaultIslamicSchool = 0; // Standard

  late final SharedPreferences _prefs;

  /// In-memory cache for faster access after initial load
  late bool _darkMode;
  late bool _hijriCalendar;
  late bool _use24HourFormat;
  late bool _prayerReminders;
  late String _location;
  late int _calculationMethod;
  late int _islamicSchool;

  bool _initialized = false;

  /// Initialize the service and load all settings from storage
  ///
  /// Must be called before accessing any settings.
  /// Returns true if initialization succeeded.
  Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      _prefs = await SharedPreferences.getInstance();

      // Load all settings with defaults
      _darkMode = _prefs.getBool(_keyDarkMode) ?? _defaultDarkMode;
      _hijriCalendar =
          _prefs.getBool(_keyHijriCalendar) ?? _defaultHijriCalendar;
      _use24HourFormat =
          _prefs.getBool(_key24HourFormat) ?? _default24HourFormat;
      _prayerReminders =
          _prefs.getBool(_keyPrayerReminders) ?? _defaultPrayerReminders;
      _location = _prefs.getString(_keyLocation) ?? _defaultLocation;
      _calculationMethod =
          _prefs.getInt(_keyCalculationMethod) ?? _defaultCalculationMethod;
      _islamicSchool =
          _prefs.getInt(_keyIslamicSchool) ?? _defaultIslamicSchool;

      _initialized = true;
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Failed to initialize SettingsStorageService: $e');
      return false;
    }
  }

  /// Ensure service is initialized before accessing settings
  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'SettingsStorageService not initialized. Call initialize() first.',
      );
    }
  }

  // ==================== Dark Mode ====================

  bool get darkMode {
    _ensureInitialized();
    return _darkMode;
  }

  Future<bool> setDarkMode(bool value) async {
    _ensureInitialized();
    _darkMode = value;
    return await _prefs.setBool(_keyDarkMode, value);
  }

  // ==================== Hijri Calendar ====================

  bool get hijriCalendar {
    _ensureInitialized();
    return _hijriCalendar;
  }

  Future<bool> setHijriCalendar(bool value) async {
    _ensureInitialized();
    _hijriCalendar = value;
    return await _prefs.setBool(_keyHijriCalendar, value);
  }

  // ==================== 24-Hour Format ====================

  bool get use24HourFormat {
    _ensureInitialized();
    return _use24HourFormat;
  }

  Future<bool> setUse24HourFormat(bool value) async {
    _ensureInitialized();
    _use24HourFormat = value;
    return await _prefs.setBool(_key24HourFormat, value);
  }

  // ==================== Prayer Reminders ====================

  bool get prayerReminders {
    _ensureInitialized();
    return _prayerReminders;
  }

  Future<bool> setPrayerReminders(bool value) async {
    _ensureInitialized();
    _prayerReminders = value;
    return await _prefs.setBool(_keyPrayerReminders, value);
  }

  // ==================== Location ====================

  String get location {
    _ensureInitialized();
    return _location;
  }

  Future<bool> setLocation(String value) async {
    _ensureInitialized();
    _location = value;
    return await _prefs.setString(_keyLocation, value);
  }

  // ==================== Calculation Method ====================

  int get calculationMethod {
    _ensureInitialized();
    return _calculationMethod;
  }

  Future<bool> setCalculationMethod(int value) async {
    _ensureInitialized();
    if (value < 0 || value > 16) {
      throw ArgumentError('Calculation method must be between 0 and 16');
    }
    _calculationMethod = value;
    return await _prefs.setInt(_keyCalculationMethod, value);
  }

  // ==================== Islamic School ====================

  int get islamicSchool {
    _ensureInitialized();
    return _islamicSchool;
  }

  Future<bool> setIslamicSchool(int value) async {
    _ensureInitialized();
    if (value < 0 || value > 1) {
      throw ArgumentError('Islamic school must be 0 (Standard) or 1 (Hanafi)');
    }
    _islamicSchool = value;
    return await _prefs.setInt(_keyIslamicSchool, value);
  }

  // ==================== Utility Methods ====================

  /// Clear all settings and reset to defaults
  Future<bool> clearAll() async {
    _ensureInitialized();
    final success = await _prefs.clear();
    if (success) {
      // Reset cache to defaults
      _darkMode = _defaultDarkMode;
      _hijriCalendar = _defaultHijriCalendar;
      _use24HourFormat = _default24HourFormat;
      _prayerReminders = _defaultPrayerReminders;
      _location = _defaultLocation;
      _calculationMethod = _defaultCalculationMethod;
      _islamicSchool = _defaultIslamicSchool;
    }
    return success;
  }

  /// Check if a specific setting has been customized (not using default)
  bool isDarkModeCustomized() => _prefs.containsKey(_keyDarkMode);
  bool isHijriCalendarCustomized() => _prefs.containsKey(_keyHijriCalendar);
  bool is24HourFormatCustomized() => _prefs.containsKey(_key24HourFormat);
  bool isPrayerRemindersCustomized() => _prefs.containsKey(_keyPrayerReminders);
  bool isLocationCustomized() => _prefs.containsKey(_keyLocation);
  bool isCalculationMethodCustomized() =>
      _prefs.containsKey(_keyCalculationMethod);
  bool isIslamicSchoolCustomized() => _prefs.containsKey(_keyIslamicSchool);
}
