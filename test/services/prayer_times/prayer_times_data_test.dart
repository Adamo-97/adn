import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/services/prayer_times/models/models.dart';

void main() {
  group('PrayerTimesData Tests', () {
    late PrayerTimesData testData;

    setUp(() {
      testData = PrayerTimesData(
        date: DateTime(2025, 1, 1),
        fajr: '05:30',
        sunrise: '07:45',
        dhuhr: '12:15',
        asr: '14:30',
        maghrib: '17:00',
        isha: '18:45',
      );
    });

    test('getTimeByName returns correct times', () {
      expect(testData.getTimeByName('Fajr'), '05:30');
      expect(testData.getTimeByName('fajr'), '05:30'); // Case-insensitive
      expect(testData.getTimeByName('Dhuhr'), '12:15');
      expect(testData.getTimeByName('Isha'), '18:45');
    });

    test('getTimeByName returns 00:00 for invalid prayer name', () {
      expect(testData.getTimeByName('InvalidPrayer'), '00:00');
    });

    test('toJson creates correct JSON map', () {
      final json = testData.toJson();

      expect(json['fajr'], '05:30');
      expect(json['sunrise'], '07:45');
      expect(json['dhuhr'], '12:15');
      expect(json['asr'], '14:30');
      expect(json['maghrib'], '17:00');
      expect(json['isha'], '18:45');
      expect(json['date'], '2025-01-01T00:00:00.000');
    });

    test('fromJson creates correct PrayerTimesData', () {
      final json = {
        'date': '2025-01-01T00:00:00.000',
        'fajr': '05:30',
        'sunrise': '07:45',
        'dhuhr': '12:15',
        'asr': '14:30',
        'maghrib': '17:00',
        'isha': '18:45',
      };

      final data = PrayerTimesData.fromJson(json);

      expect(data.date, DateTime(2025, 1, 1));
      expect(data.fajr, '05:30');
      expect(data.sunrise, '07:45');
      expect(data.dhuhr, '12:15');
      expect(data.asr, '14:30');
      expect(data.maghrib, '17:00');
      expect(data.isha, '18:45');
    });

    test('fromApiResponse parses API response correctly', () {
      final apiResponse = {
        'timings': {
          'Fajr': '05:30 (CET)',
          'Sunrise': '07:45 (CET)',
          'Dhuhr': '12:15 (CET)',
          'Asr': '14:30 (CET)',
          'Maghrib': '17:00 (CET)',
          'Isha': '18:45 (CET)',
        },
        'date': {
          'gregorian': {
            'date': '01-01-2025',
          }
        }
      };

      final data = PrayerTimesData.fromApiResponse(apiResponse);

      expect(data.date, DateTime(2025, 1, 1));
      expect(data.fajr, '05:30');
      expect(data.sunrise, '07:45');
      expect(data.dhuhr, '12:15');
      expect(data.asr, '14:30');
      expect(data.maghrib, '17:00');
      expect(data.isha, '18:45');
    });

    test('toUiMap returns correct map format', () {
      final uiMap = testData.toUiMap();

      expect(uiMap, {
        'Fajr': '05:30',
        'Sunrise': '07:45',
        'Dhuhr': '12:15',
        'Asr': '14:30',
        'Maghrib': '17:00',
        'Isha': '18:45',
      });
    });

    test('copyWith creates new instance with updated values', () {
      final updated = testData.copyWith(
        fajr: '06:00',
        isha: '19:00',
      );

      expect(updated.fajr, '06:00');
      expect(updated.isha, '19:00');
      expect(updated.dhuhr, '12:15'); // Unchanged
      expect(updated, isNot(same(testData))); // Different instance
    });

    test('Equatable props work correctly', () {
      final data1 = PrayerTimesData(
        date: DateTime(2025, 1, 1),
        fajr: '05:30',
        sunrise: '07:45',
        dhuhr: '12:15',
        asr: '14:30',
        maghrib: '17:00',
        isha: '18:45',
      );

      final data2 = PrayerTimesData(
        date: DateTime(2025, 1, 1),
        fajr: '05:30',
        sunrise: '07:45',
        dhuhr: '12:15',
        asr: '14:30',
        maghrib: '17:00',
        isha: '18:45',
      );

      expect(data1, equals(data2));
    });
  });

  group('PrayerTimesResult Tests', () {
    test('success result has correct properties', () {
      final data = PrayerTimesData(
        date: DateTime(2025, 1, 1),
        fajr: '05:30',
        sunrise: '07:45',
        dhuhr: '12:15',
        asr: '14:30',
        maghrib: '17:00',
        isha: '18:45',
      );

      final result = PrayerTimesResult.success(data);

      expect(result.isSuccess, isTrue);
      expect(result.data, equals(data));
      expect(result.error, isNull);
    });

    test('failure result has correct properties', () {
      const errorMsg = 'API request failed';
      final result = PrayerTimesResult.failure(errorMsg);

      expect(result.isSuccess, isFalse);
      expect(result.data, isNull);
      expect(result.error, errorMsg);
    });
  });
}
