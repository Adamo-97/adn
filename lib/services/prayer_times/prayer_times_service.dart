import 'models/models.dart';
import 'aladhan_api_service.dart';
import 'prayer_times_cache_service.dart';

/// Main service orchestrating prayer times fetching and caching
///
/// This service combines API fetching with local caching to provide:
/// - Once-per-day API calls (triggered at midnight or first app open of the day)
/// - Instant loading from cache for all other times
/// - Automatic cache invalidation when location/settings change
class PrayerTimesService {
  final AladhanApiService _apiService;
  final PrayerTimesCacheService _cacheService;

  PrayerTimesService({
    AladhanApiService? apiService,
    PrayerTimesCacheService? cacheService,
  })  : _apiService = apiService ?? AladhanApiService(),
        _cacheService = cacheService ?? PrayerTimesCacheService();

  /// Get prayer times for a specific date
  ///
  /// Implements smart caching strategy:
  /// 1. Check if cache is valid (same day, same location/settings)
  /// 2. If valid, load from cache (instant)
  /// 3. If invalid, fetch from API and update cache
  ///
  /// Parameters:
  /// - [city]: City name (e.g., "Stockholm")
  /// - [country]: Country name (e.g., "Sweden")
  /// - [date]: Date for prayer times (defaults to today)
  /// - [calculationMethod]: Calculation method ID (default: 3 - MWL)
  /// - [school]: Islamic school (0: Standard, 1: Hanafi)
  ///
  /// Returns [PrayerTimesResult] with data or error
  Future<PrayerTimesResult> getPrayerTimes({
    required String city,
    required String country,
    DateTime? date,
    int calculationMethod = 3,
    int school = 0,
  }) async {
    final targetDate = date ?? DateTime.now();
    final dateOnly =
        DateTime(targetDate.year, targetDate.month, targetDate.day);

    try {
      // Check if cache is valid
      final isCacheValid = await _cacheService.isCacheValid(
        city: city,
        country: country,
        calculationMethod: calculationMethod,
        school: school,
      );

      if (isCacheValid) {
        // Try loading from cache
        final cachedData = await _cacheService.loadPrayerTimes(dateOnly);
        if (cachedData != null) {
          return PrayerTimesResult.success(cachedData);
        }
      }

      // Cache invalid or empty - fetch from API
      final result = await _apiService.fetchPrayerTimesByCity(
        city: city,
        country: country,
        date: dateOnly,
        calculationMethod: calculationMethod,
        school: school,
      );

      // If successful, save to cache
      if (result.isSuccess && result.data != null) {
        await _cacheService.savePrayerTimes(
          prayerTimes: result.data!,
          city: city,
          country: country,
          calculationMethod: calculationMethod,
          school: school,
        );
      }

      return result;
    } catch (e) {
      return PrayerTimesResult.failure('Error fetching prayer times: $e');
    }
  }

  /// Clear cache and force re-fetch on next call
  ///
  /// Should be called when user changes:
  /// - Location
  /// - Calculation method
  /// - Islamic school
  Future<void> clearCache() async {
    await _cacheService.clearCache();
  }

  /// Get cache statistics (for debugging/settings UI)
  Future<Map<String, dynamic>> getCacheInfo() async {
    return await _cacheService.getCacheInfo();
  }

  /// Pre-fetch prayer times for multiple days (e.g., entire month)
  ///
  /// Useful for offline support - cache an entire month in advance.
  /// Optional: Can be called during app idle time or user-triggered.
  Future<void> preFetchMonth({
    required String city,
    required String country,
    required DateTime month,
    int calculationMethod = 3,
    int school = 0,
  }) async {
    try {
      final monthlyData = await _apiService.fetchMonthlyPrayerTimes(
        city: city,
        country: country,
        month: month,
        calculationMethod: calculationMethod,
        school: school,
      );

      // Save each day to cache
      for (final dayData in monthlyData) {
        await _cacheService.savePrayerTimes(
          prayerTimes: dayData,
          city: city,
          country: country,
          calculationMethod: calculationMethod,
          school: school,
        );
      }
    } catch (e) {
      // Silently fail - pre-fetching is optional optimization
      // ignore: avoid_print
      print('Failed to pre-fetch monthly prayer times: $e');
    }
  }
}
