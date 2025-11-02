import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/models.dart';

/// Service for caching prayer times locally using SharedPreferences
///
/// Implements once-per-day fetch strategy with automatic midnight invalidation.
/// Caches are tied to specific location and calculation settings to ensure accuracy.
class PrayerTimesCacheService {
  static const String _keyPrefix = 'prayer_times_cache';
  static const String _lastFetchDateKey = 'prayer_times_last_fetch_date';
  static const String _cachedLocationKey = 'prayer_times_cached_location';
  static const String _cachedMethodKey = 'prayer_times_cached_method';
  static const String _cachedSchoolKey = 'prayer_times_cached_school';

  /// Check if cached data exists and is still valid for today
  ///
  /// Cache is invalid if:
  /// 1. No cached data exists
  /// 2. Last fetch was on a different day (new day = cache expired)
  /// 3. Location or settings changed (requires re-fetch with new parameters)
  ///
  /// Returns true if cache is valid and can be used, false if re-fetch needed.
  Future<bool> isCacheValid({
    required String city,
    required String country,
    required int calculationMethod,
    required int school,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get last fetch date
      final lastFetchDateString = prefs.getString(_lastFetchDateKey);
      if (lastFetchDateString == null) return false;

      final lastFetchDate = DateTime.parse(lastFetchDateString);
      final today = DateTime.now();

      // Check if it's a new day (comparing date-only, ignoring time)
      final isSameDay = lastFetchDate.year == today.year &&
          lastFetchDate.month == today.month &&
          lastFetchDate.day == today.day;

      if (!isSameDay) return false;

      // Check if location or settings changed
      final cachedLocation = prefs.getString(_cachedLocationKey);
      final cachedMethod = prefs.getInt(_cachedMethodKey);
      final cachedSchool = prefs.getInt(_cachedSchoolKey);

      final currentLocation = _formatLocation(city, country);

      if (cachedLocation != currentLocation ||
          cachedMethod != calculationMethod ||
          cachedSchool != school) {
        return false;
      }

      return true;
    } catch (e) {
      // If any error occurs during validation, treat cache as invalid
      return false;
    }
  }

  /// Save prayer times to cache
  ///
  /// Stores the prayer times data along with metadata (location, settings, fetch date)
  /// to enable proper cache invalidation logic.
  Future<void> savePrayerTimes({
    required PrayerTimesData prayerTimes,
    required String city,
    required String country,
    required int calculationMethod,
    required int school,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save prayer times as JSON
      final dateKey = _getCacheKey(prayerTimes.date);
      await prefs.setString(dateKey, json.encode(prayerTimes.toJson()));

      // Save metadata for cache validation
      await prefs.setString(
          _lastFetchDateKey, DateTime.now().toIso8601String());
      await prefs.setString(_cachedLocationKey, _formatLocation(city, country));
      await prefs.setInt(_cachedMethodKey, calculationMethod);
      await prefs.setInt(_cachedSchoolKey, school);
    } catch (e) {
      // Log error but don't throw - caching is non-critical
      // ignore: avoid_print
      print('Failed to save prayer times to cache: $e');
    }
  }

  /// Load prayer times from cache for a specific date
  ///
  /// Returns null if no cached data exists for the specified date.
  Future<PrayerTimesData?> loadPrayerTimes(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateKey = _getCacheKey(date);
      final cachedJson = prefs.getString(dateKey);

      if (cachedJson == null) return null;

      final Map<String, dynamic> jsonMap = json.decode(cachedJson);
      return PrayerTimesData.fromJson(jsonMap);
    } catch (e) {
      // If parsing fails, return null to trigger re-fetch
      return null;
    }
  }

  /// Clear all cached prayer times and metadata
  ///
  /// Should be called when:
  /// 1. User changes location
  /// 2. User changes calculation method or school
  /// 3. User explicitly clears cache in settings
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Remove all prayer times cache keys
      final keys = prefs.getKeys();
      final cacheKeys = keys.where((key) => key.startsWith(_keyPrefix));

      for (final key in cacheKeys) {
        await prefs.remove(key);
      }

      // Remove metadata
      await prefs.remove(_lastFetchDateKey);
      await prefs.remove(_cachedLocationKey);
      await prefs.remove(_cachedMethodKey);
      await prefs.remove(_cachedSchoolKey);
    } catch (e) {
      // Log error but don't throw
      // ignore: avoid_print
      print('Failed to clear prayer times cache: $e');
    }
  }

  /// Get cache statistics (for debugging/UI display)
  ///
  /// Returns a map with cache info: entries count, last fetch date, etc.
  Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final cacheKeys = keys.where((key) => key.startsWith(_keyPrefix));

      return {
        'entriesCount': cacheKeys.length,
        'lastFetchDate': prefs.getString(_lastFetchDateKey),
        'cachedLocation': prefs.getString(_cachedLocationKey),
        'cachedMethod': prefs.getInt(_cachedMethodKey),
        'cachedSchool': prefs.getInt(_cachedSchoolKey),
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Private helper methods

  /// Generate cache key for a specific date
  String _getCacheKey(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return '${_keyPrefix}_${dateOnly.toIso8601String()}';
  }

  /// Format location as "City, Country" for comparison
  String _formatLocation(String city, String country) {
    return '$city, $country';
  }
}
