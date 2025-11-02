import 'package:equatable/equatable.dart';

/// Represents a single day's prayer times
///
/// Contains all five obligatory prayer times plus Sunrise time.
/// Times are stored in 24-hour format (HH:mm).
class PrayerTimesData extends Equatable {
  /// Date for these prayer times (date-only, time component ignored)
  final DateTime date;

  /// Fajr (Dawn) prayer time in 24-hour format (HH:mm)
  final String fajr;

  /// Sunrise time in 24-hour format (HH:mm) - not a prayer, but important for timing
  final String sunrise;

  /// Dhuhr (Noon) prayer time in 24-hour format (HH:mm)
  final String dhuhr;

  /// Asr (Afternoon) prayer time in 24-hour format (HH:mm)
  final String asr;

  /// Maghrib (Sunset) prayer time in 24-hour format (HH:mm)
  final String maghrib;

  /// Isha (Night) prayer time in 24-hour format (HH:mm)
  final String isha;

  const PrayerTimesData({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  /// Get prayer time by name (case-insensitive)
  ///
  /// Supported names: Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha
  /// Returns "00:00" if prayer name not recognized
  String getTimeByName(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return fajr;
      case 'sunrise':
        return sunrise;
      case 'dhuhr':
        return dhuhr;
      case 'asr':
        return asr;
      case 'maghrib':
        return maghrib;
      case 'isha':
        return isha;
      default:
        return '00:00';
    }
  }

  /// Convert to map for caching
  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'fajr': fajr,
        'sunrise': sunrise,
        'dhuhr': dhuhr,
        'asr': asr,
        'maghrib': maghrib,
        'isha': isha,
      };

  /// Create from cached JSON map
  factory PrayerTimesData.fromJson(Map<String, dynamic> json) {
    return PrayerTimesData(
      date: DateTime.parse(json['date'] as String),
      fajr: json['fajr'] as String,
      sunrise: json['sunrise'] as String,
      dhuhr: json['dhuhr'] as String,
      asr: json['asr'] as String,
      maghrib: json['maghrib'] as String,
      isha: json['isha'] as String,
    );
  }

  /// Create from Aladhan API response
  ///
  /// Expects the 'timings' object from the API response:
  /// ```json
  /// {
  ///   "timings": {
  ///     "Fajr": "05:30 (CET)",
  ///     "Sunrise": "07:45 (CET)",
  ///     ...
  ///   },
  ///   "date": { "gregorian": { "date": "01-01-2025" } }
  /// }
  /// ```
  factory PrayerTimesData.fromApiResponse(Map<String, dynamic> response) {
    final timings = response['timings'] as Map<String, dynamic>;
    final dateInfo = response['date']['gregorian'] as Map<String, dynamic>;

    // Parse date from API format: "DD-MM-YYYY"
    final dateParts = (dateInfo['date'] as String).split('-');
    final date = DateTime(
      int.parse(dateParts[2]), // year
      int.parse(dateParts[1]), // month
      int.parse(dateParts[0]), // day
    );

    /// Extract time string and remove timezone suffix (e.g., "05:30 (CET)" -> "05:30")
    String cleanTime(String timeWithZone) {
      return timeWithZone.split(' ').first;
    }

    return PrayerTimesData(
      date: date,
      fajr: cleanTime(timings['Fajr'] as String),
      sunrise: cleanTime(timings['Sunrise'] as String),
      dhuhr: cleanTime(timings['Dhuhr'] as String),
      asr: cleanTime(timings['Asr'] as String),
      maghrib: cleanTime(timings['Maghrib'] as String),
      isha: cleanTime(timings['Isha'] as String),
    );
  }

  /// Convert to map format expected by UI (prayer name -> time string)
  Map<String, String> toUiMap() => {
        'Fajr': fajr,
        'Sunrise': sunrise,
        'Dhuhr': dhuhr,
        'Asr': asr,
        'Maghrib': maghrib,
        'Isha': isha,
      };

  @override
  List<Object?> get props => [date, fajr, sunrise, dhuhr, asr, maghrib, isha];

  PrayerTimesData copyWith({
    DateTime? date,
    String? fajr,
    String? sunrise,
    String? dhuhr,
    String? asr,
    String? maghrib,
    String? isha,
  }) {
    return PrayerTimesData(
      date: date ?? this.date,
      fajr: fajr ?? this.fajr,
      sunrise: sunrise ?? this.sunrise,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
    );
  }
}

/// Result wrapper for prayer times API calls
///
/// Provides success/failure states with optional error messages
class PrayerTimesResult {
  final PrayerTimesData? data;
  final String? error;
  final bool isSuccess;

  const PrayerTimesResult.success(this.data)
      : error = null,
        isSuccess = true;

  const PrayerTimesResult.failure(this.error)
      : data = null,
        isSuccess = false;
}
