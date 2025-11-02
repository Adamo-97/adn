import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'prayer_times_service.dart';
import 'aladhan_api_service.dart';
import 'prayer_times_cache_service.dart';

/// Provider for PrayerTimesService
///
/// Use this provider to access the prayer times service throughout the app.
/// The service manages API calls and caching automatically.
///
/// Example usage:
/// ```dart
/// final service = ref.watch(prayerTimesServiceProvider);
/// final result = await service.getPrayerTimes(
///   city: 'London',
///   country: 'UK',
/// );
/// ```
final prayerTimesServiceProvider = Provider<PrayerTimesService>((ref) {
  return PrayerTimesService(
    apiService: AladhanApiService(),
    cacheService: PrayerTimesCacheService(),
  );
});

/// Provider for AladhanApiService (for testing or direct access)
final aladhanApiServiceProvider = Provider<AladhanApiService>((ref) {
  return AladhanApiService();
});

/// Provider for PrayerTimesCacheService (for testing or direct access)
final prayerTimesCacheServiceProvider =
    Provider<PrayerTimesCacheService>((ref) {
  return PrayerTimesCacheService();
});
