import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_tracker_notifier.dart';
import 'package:adam_s_application/services/prayer_times/prayer_times.dart';

// Mock classes
class MockPrayerTimesService extends Mock implements PrayerTimesService {}

void main() {
  late MockPrayerTimesService mockPrayerTimesService;
  late ProviderContainer container;

  setUp(() {
    mockPrayerTimesService = MockPrayerTimesService();
  });

  tearDown(() {
    container.dispose();
  });

  group('Prayer Tracker - Day Navigation Tests', () {
    testWidgets('prevDay should decrement date by 1 day and fetch prayer times',
        (tester) async {
      // Arrange
      final initialDate = DateTime(2025, 11, 15);
      final expectedDate = DateTime(2025, 11, 14);

      container = ProviderContainer(
        overrides: [
          prayerTimesServiceProvider.overrideWith((ref) => mockPrayerTimesService),
        ],
      );

      when(() => mockPrayerTimesService.getPrayerTimes(
            city: any(named: 'city'),
            country: any(named: 'country'),
            date: any(named: 'date'),
            calculationMethod: any(named: 'calculationMethod'),
            school: any(named: 'school'),
          )).thenAnswer((_) async => PrayerTimesResult.success(
            PrayerTimesData(
              date: expectedDate,
              fajr: const TimeOfDay(hour: 5, minute: 30),
              sunrise: const TimeOfDay(hour: 7, minute: 0),
              dhuhr: const TimeOfDay(hour: 12, minute: 30),
              asr: const TimeOfDay(hour: 15, minute: 0),
              maghrib: const TimeOfDay(hour: 18, minute: 0),
              isha: const TimeOfDay(hour: 20, minute: 0),
            ),
          ));

      final notifier = container.read(prayerTrackerNotifierProvider.notifier);
      notifier.selectDate(initialDate);
      await Future.microtask(() {});

      // Act
      notifier.prevDay();
      await Future.microtask(() {});

      // Assert
      final state = container.read(prayerTrackerNotifierProvider);
      expect(state.selectedDate.year, expectedDate.year);
      expect(state.selectedDate.month, expectedDate.month);
      expect(state.selectedDate.day, expectedDate.day);

      // Verify API was called with correct date
      verify(() => mockPrayerTimesService.getPrayerTimes(
            city: any(named: 'city'),
            country: any(named: 'country'),
            date: expectedDate,
            calculationMethod: any(named: 'calculationMethod'),
            school: any(named: 'school'),
          )).called(1);
    });

    testWidgets('nextDay should increment date by 1 day and fetch prayer times',
        (tester) async {
      // Arrange
      final initialDate = DateTime(2025, 11, 15);
      final expectedDate = DateTime(2025, 11, 16);

      container = ProviderContainer(
        overrides: [
          prayerTimesServiceProvider.overrideWith((ref) => mockPrayerTimesService),
        ],
      );

      when(() => mockPrayerTimesService.getPrayerTimes(
            city: any(named: 'city'),
            country: any(named: 'country'),
            date: any(named: 'date'),
            calculationMethod: any(named: 'calculationMethod'),
            school: any(named: 'school'),
          )).thenAnswer((_) async => PrayerTimesResult.success(
            PrayerTimesData(
              date: expectedDate,
              fajr: const TimeOfDay(hour: 5, minute: 30),
              sunrise: const TimeOfDay(hour: 7, minute: 0),
              dhuhr: const TimeOfDay(hour: 12, minute: 30),
              asr: const TimeOfDay(hour: 15, minute: 0),
              maghrib: const TimeOfDay(hour: 18, minute: 0),
              isha: const TimeOfDay(hour: 20, minute: 0),
            ),
          ));

      final notifier = container.read(prayerTrackerNotifierProvider.notifier);
      notifier.selectDate(initialDate);
      await Future.microtask(() {});

      // Act
      notifier.nextDay();
      await Future.microtask(() {});

      // Assert
      final state = container.read(prayerTrackerNotifierProvider);
      expect(state.selectedDate.year, expectedDate.year);
      expect(state.selectedDate.month, expectedDate.month);
      expect(state.selectedDate.day, expectedDate.day);

      verify(() => mockPrayerTimesService.getPrayerTimes(
            city: any(named: 'city'),
            country: any(named: 'country'),
            date: expectedDate,
            calculationMethod: any(named: 'calculationMethod'),
            school: any(named: 'school'),
          )).called(1);
    });

    testWidgets('prevDay at month boundary should correctly change month',
        (tester) async {
      // Arrange - Start at Nov 1, 2025
      final initialDate = DateTime(2025, 11, 1);
      final expectedDate = DateTime(2025, 10, 31); // Oct 31

      container = ProviderContainer(
        overrides: [
          prayerTimesServiceProvider.overrideWith((ref) => mockPrayerTimesService),
        ],
      );

      when(() => mockPrayerTimesService.getPrayerTimes(
            city: any(named: 'city'),
            country: any(named: 'country'),
            date: any(named: 'date'),
            calculationMethod: any(named: 'calculationMethod'),
            school: any(named: 'school'),
          )).thenAnswer((_) async => PrayerTimesResult.success(
            PrayerTimesData(
              date: expectedDate,
              fajr: const TimeOfDay(hour: 5, minute: 30),
              sunrise: const TimeOfDay(hour: 7, minute: 0),
              dhuhr: const TimeOfDay(hour: 12, minute: 30),
              asr: const TimeOfDay(hour: 15, minute: 0),
              maghrib: const TimeOfDay(hour: 18, minute: 0),
              isha: const TimeOfDay(hour: 20, minute: 0),
            ),
          ));

      final notifier = container.read(prayerTrackerNotifierProvider.notifier);
      notifier.selectDate(initialDate);
      await Future.microtask(() {});

      // Act
      notifier.prevDay();
      await Future.microtask(() {});

      // Assert
      final state = container.read(prayerTrackerNotifierProvider);
      expect(state.selectedDate.month, 10); // October
      expect(state.selectedDate.day, 31);
    });
  });

  group('Prayer Tracker - API Fetch Verification Tests', () {
    testWidgets('selectDate should always trigger API fetch', (tester) async {
      // Arrange
      final date1 = DateTime(2025, 11, 10);
      final date2 = DateTime(2025, 11, 15);
      final date3 = DateTime(2025, 12, 25);

      container = ProviderContainer(
        overrides: [
          prayerTimesServiceProvider.overrideWith((ref) => mockPrayerTimesService),
        ],
      );

      when(() => mockPrayerTimesService.getPrayerTimes(
            city: any(named: 'city'),
            country: any(named: 'country'),
            date: any(named: 'date'),
            calculationMethod: any(named: 'calculationMethod'),
            school: any(named: 'school'),
          )).thenAnswer((_) async => PrayerTimesResult.success(
            PrayerTimesData(
              date: DateTime.now(),
              fajr: const TimeOfDay(hour: 5, minute: 30),
              sunrise: const TimeOfDay(hour: 7, minute: 0),
              dhuhr: const TimeOfDay(hour: 12, minute: 30),
              asr: const TimeOfDay(hour: 15, minute: 0),
              maghrib: const TimeOfDay(hour: 18, minute: 0),
              isha: const TimeOfDay(hour: 20, minute: 0),
            ),
          ));

      final notifier = container.read(prayerTrackerNotifierProvider.notifier);

      // Act - Select multiple dates
      notifier.selectDate(date1);
      await Future.microtask(() {});

      notifier.selectDate(date2);
      await Future.microtask(() {});

      notifier.selectDate(date3);
      await Future.microtask(() {});

      // Assert - API should be called for each date selection (plus initial call)
      verify(() => mockPrayerTimesService.getPrayerTimes(
            city: any(named: 'city'),
            country: any(named: 'country'),
            date: any(named: 'date'),
            calculationMethod: any(named: 'calculationMethod'),
            school: any(named: 'school'),
          )).called(greaterThanOrEqualTo(3));
    });
  });
}
