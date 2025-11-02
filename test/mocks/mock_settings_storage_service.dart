/// Mock implementation of SettingsStorageService for testing
///
/// This mock eliminates the need for SharedPreferences (which requires Flutter bindings)
/// in unit tests. It provides an in-memory only implementation that behaves identically
/// to the real service but without persistence.
library;

class MockSettingsStorageService {
  // In-memory storage simulating SharedPreferences
  bool _darkMode = true; // Default matches production
  bool _hijriCalendar = false;
  bool _use24HourFormat = false;
  bool _prayerReminders = true;
  String _location = 'Mecca, Saudi Arabia';
  int _calculationMethod = 4; // Muslim World League
  int _islamicSchool = 0; // Standard

  bool _isInitialized = false;

  /// Initialize the mock service (always succeeds, no async needed)
  Future<void> initialize() async {
    _isInitialized = true;
  }

  /// Check if service is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
          'SettingsStorageService not initialized. Call initialize() first.');
    }
  }

  // Dark Mode
  bool get darkMode {
    _ensureInitialized();
    return _darkMode;
  }

  Future<void> setDarkMode(bool value) async {
    _ensureInitialized();
    _darkMode = value;
  }

  // Hijri Calendar
  bool get hijriCalendar {
    _ensureInitialized();
    return _hijriCalendar;
  }

  Future<void> setHijriCalendar(bool value) async {
    _ensureInitialized();
    _hijriCalendar = value;
  }

  // 24-Hour Format
  bool get use24HourFormat {
    _ensureInitialized();
    return _use24HourFormat;
  }

  Future<void> setUse24HourFormat(bool value) async {
    _ensureInitialized();
    _use24HourFormat = value;
  }

  // Prayer Reminders
  bool get prayerReminders {
    _ensureInitialized();
    return _prayerReminders;
  }

  Future<void> setPrayerReminders(bool value) async {
    _ensureInitialized();
    _prayerReminders = value;
  }

  // Location
  String get location {
    _ensureInitialized();
    return _location;
  }

  Future<void> setLocation(String value) async {
    _ensureInitialized();
    _location = value;
  }

  // Calculation Method
  int get calculationMethod {
    _ensureInitialized();
    return _calculationMethod;
  }

  Future<void> setCalculationMethod(int value) async {
    _ensureInitialized();
    if (value < 0 || value > 16) {
      throw ArgumentError('calculationMethod must be between 0 and 16');
    }
    _calculationMethod = value;
  }

  // Islamic School
  int get islamicSchool {
    _ensureInitialized();
    return _islamicSchool;
  }

  Future<void> setIslamicSchool(int value) async {
    _ensureInitialized();
    if (value < 0 || value > 1) {
      throw ArgumentError('islamicSchool must be 0 or 1');
    }
    _islamicSchool = value;
  }

  /// Clear all settings (for testing purposes)
  Future<void> clearAll() async {
    _ensureInitialized();
    _darkMode = true;
    _hijriCalendar = false;
    _use24HourFormat = false;
    _prayerReminders = true;
    _location = 'Mecca, Saudi Arabia';
    _calculationMethod = 4;
    _islamicSchool = 0;
  }

  /// Reset to uninitialized state (for test cleanup)
  void reset() {
    _isInitialized = false;
    _darkMode = true;
    _hijriCalendar = false;
    _use24HourFormat = false;
    _prayerReminders = true;
    _location = 'Mecca, Saudi Arabia';
    _calculationMethod = 4;
    _islamicSchool = 0;
  }
}
