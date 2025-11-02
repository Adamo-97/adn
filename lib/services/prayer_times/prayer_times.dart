/// Prayer Times Service
///
/// This library provides a complete solution for fetching and caching Islamic prayer times
/// using the Aladhan API (https://aladhan.com/prayer-times-api).
///
/// Main Features:
/// - Fetch daily prayer times based on city/country
/// - Smart caching with automatic daily refresh (at midnight)
/// - Support for multiple calculation methods and Islamic schools
/// - Cache invalidation on location/settings change
///
/// Usage:
/// ```dart
/// final service = ref.watch(prayerTimesServiceProvider);
/// final result = await service.getPrayerTimes(
///   city: 'Stockholm',
///   country: 'Sweden',
///   calculationMethod: 3,
///   school: 0,
/// );
///
/// if (result.isSuccess) {
///   final times = result.data!;
///   print('Fajr: ${times.fajr}');
/// }
/// ```
library;

export 'models/models.dart';
export 'aladhan_api_service.dart';
export 'prayer_times_cache_service.dart';
export 'prayer_times_service.dart';
export 'prayer_times_provider.dart';
