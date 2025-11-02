/// Test helpers for setting up test environment
///
/// This file provides utilities to properly initialize and configure
/// the test environment for Flutter widget and unit tests.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Initialize Flutter binding and mock SharedPreferences for testing
///
/// Call this at the start of setUp() in test files that use services
/// requiring SharedPreferences (like SettingsStorageService).
///
/// For unit tests (using `test()`):
/// ```dart
/// setUpAll(() {
///   initializeTestEnvironment();
/// });
/// ```
///
/// For widget tests (using `testWidgets()`):
/// ```dart
/// setUp(() {
///   initializeTestEnvironment();
/// });
/// ```
void initializeTestEnvironment({Map<String, Object>? initialValues}) {
  // Initialize Flutter bindings (required for SharedPreferences)
  TestWidgetsFlutterBinding.ensureInitialized();

  // Set up SharedPreferences with initial values
  final values = initialValues ?? getDefaultSettingsValues();
  SharedPreferences.setMockInitialValues(values);
}

/// Reset test environment after tests complete
///
/// Call this in tearDown() to clean up after tests.
///
/// Example:
/// ```dart
/// tearDown(() {
///   resetTestEnvironment();
/// });
/// ```
void resetTestEnvironment() {
  // Remove SharedPreferences mock
  SharedPreferences.setMockInitialValues({});
}

/// Get default settings values for tests
///
/// Returns a map matching the defaults in SettingsStorageService.
/// Use this to initialize SharedPreferences in tests with known values.
Map<String, Object> getDefaultSettingsValues() {
  return {
    'dark_mode': true,
    'hijri_calendar': false,
    'use_24_hour_format': false,
    'prayer_reminders': true,
    'location': 'Mecca, Saudi Arabia',
    'calculation_method': 4, // Muslim World League
    'islamic_school': 0, // Standard
  };
}

/// Get custom settings values for tests
///
/// Allows overriding specific settings while keeping defaults for others.
///
/// Example:
/// ```dart
/// final customSettings = getCustomSettingsValues(
///   darkMode: false,
///   location: 'Cairo, Egypt',
/// );
/// initializeTestEnvironment(initialValues: customSettings);
/// ```
Map<String, Object> getCustomSettingsValues({
  bool? darkMode,
  bool? hijriCalendar,
  bool? use24HourFormat,
  bool? prayerReminders,
  String? location,
  int? calculationMethod,
  int? islamicSchool,
}) {
  final defaults = getDefaultSettingsValues();
  return {
    'dark_mode': darkMode ?? defaults['dark_mode']!,
    'hijri_calendar': hijriCalendar ?? defaults['hijri_calendar']!,
    'use_24_hour_format': use24HourFormat ?? defaults['use_24_hour_format']!,
    'prayer_reminders': prayerReminders ?? defaults['prayer_reminders']!,
    'location': location ?? defaults['location']!,
    'calculation_method': calculationMethod ?? defaults['calculation_method']!,
    'islamic_school': islamicSchool ?? defaults['islamic_school']!,
  };
}
