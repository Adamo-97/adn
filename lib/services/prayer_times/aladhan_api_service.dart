import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/models.dart';

/// Service for fetching prayer times from Aladhan API
///
/// Provides methods to retrieve prayer times based on city/country location.
/// API Documentation: https://aladhan.com/prayer-times-api
class AladhanApiService {
  static const String _baseUrl = 'http://api.aladhan.com/v1';

  /// Fetch prayer times for a specific date and location
  ///
  /// Parameters:
  /// - [city]: City name (e.g., "Stockholm")
  /// - [country]: Country name or ISO code (e.g., "Sweden" or "SE")
  /// - [date]: Date for which to fetch prayer times (date-only, time ignored)
  /// - [calculationMethod]: Calculation method ID (0-16, default: 3 - Muslim World League)
  /// - [school]: Islamic school for Asr calculation (0: Standard, 1: Hanafi)
  ///
  /// Returns [PrayerTimesResult] with data on success or error message on failure.
  ///
  /// API Endpoint: GET /timingsByCity
  /// Example: http://api.aladhan.com/v1/timingsByCity?city=Stockholm&country=Sweden&method=3&school=0
  Future<PrayerTimesResult> fetchPrayerTimesByCity({
    required String city,
    required String country,
    required DateTime date,
    int calculationMethod = 3,
    int school = 0,
  }) async {
    try {
      // Format date as DD-MM-YYYY (required by API)
      final String formattedDate =
          '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';

      // Construct API URL with query parameters
      final uri = Uri.parse('$_baseUrl/timingsByCity').replace(
        queryParameters: {
          'city': city,
          'country': country,
          'date': formattedDate,
          'method': calculationMethod.toString(),
          'school': school.toString(),
        },
      );

      // Make HTTP GET request with timeout
      final response = await http.get(uri).timeout(
            const Duration(seconds: 10),
            onTimeout: () => http.Response('Request timeout', 408),
          );

      // Handle HTTP errors
      if (response.statusCode != 200) {
        return PrayerTimesResult.failure(
          'API request failed with status ${response.statusCode}: ${response.body}',
        );
      }

      // Parse JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Validate API response structure
      if (jsonResponse['code'] != 200 || jsonResponse['status'] != 'OK') {
        return PrayerTimesResult.failure(
          'API returned error: ${jsonResponse['status']}',
        );
      }

      // Extract prayer times data from response
      final data = jsonResponse['data'] as Map<String, dynamic>;
      final prayerTimes = PrayerTimesData.fromApiResponse(data);

      return PrayerTimesResult.success(prayerTimes);
    } catch (e) {
      // Catch all errors (network, parsing, etc.)
      return PrayerTimesResult.failure(
        'Failed to fetch prayer times: ${e.toString()}',
      );
    }
  }

  /// Fetch prayer times for current month by city
  ///
  /// Returns a list of [PrayerTimesData] for each day in the specified month.
  /// Useful for pre-caching an entire month's prayer times.
  ///
  /// Parameters same as [fetchPrayerTimesByCity] except date is used for month/year only.
  ///
  /// API Endpoint: GET /calendarByCity
  Future<List<PrayerTimesData>> fetchMonthlyPrayerTimes({
    required String city,
    required String country,
    required DateTime month,
    int calculationMethod = 3,
    int school = 0,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/calendarByCity').replace(
        queryParameters: {
          'city': city,
          'country': country,
          'month': month.month.toString(),
          'year': month.year.toString(),
          'method': calculationMethod.toString(),
          'school': school.toString(),
        },
      );

      final response = await http.get(uri).timeout(
            const Duration(seconds: 15),
            onTimeout: () => http.Response('Request timeout', 408),
          );

      if (response.statusCode != 200) {
        throw Exception('API request failed: ${response.statusCode}');
      }

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['code'] != 200) {
        throw Exception('API error: ${jsonResponse['status']}');
      }

      final List<dynamic> dataList = jsonResponse['data'] as List<dynamic>;
      return dataList
          .map((dayData) =>
              PrayerTimesData.fromApiResponse(dayData as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch monthly prayer times: $e');
    }
  }
}
