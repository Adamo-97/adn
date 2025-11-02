import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_tracker_notifier.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  // Initialize test environment before all tests
  setUpAll(() {
    initializeTestEnvironment();
  });

  // Clean up after all tests
  tearDownAll(() {
    resetTestEnvironment();
  });

  group('PrayerTrackerNotifier', () {
    test('toggleQibla and resetState behave as expected', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(prayerTrackerNotifierProvider.notifier);

      // Wait for initialization to complete
      await Future.delayed(Duration(milliseconds: 100));

      // initial state: qibla closed
      expect(container.read(prayerTrackerNotifierProvider).qiblaOpen, isFalse);

      // toggle open
      notifier.toggleQibla();
      expect(container.read(prayerTrackerNotifierProvider).qiblaOpen, isTrue);

      // reset state should close qibla and set resetTimestamp
      notifier.resetState();
      final s = container.read(prayerTrackerNotifierProvider);
      expect(s.qiblaOpen, isFalse);
      expect(s.resetTimestamp, isNonZero);

      // Wait for any pending async operations
      await Future.delayed(Duration(milliseconds: 100));
    });

    test('toggleStatButton opens and closes correctly', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(prayerTrackerNotifierProvider.notifier);

      // Wait for initialization to complete
      await Future.delayed(Duration(milliseconds: 100));

      // initial
      expect(
          container.read(prayerTrackerNotifierProvider).openStatButton, isNull);

      notifier.toggleStatButton('weekly');
      expect(container.read(prayerTrackerNotifierProvider).openStatButton,
          'weekly');

      // toggling same should close
      notifier.toggleStatButton('weekly');
      expect(
          container.read(prayerTrackerNotifierProvider).openStatButton, isNull);

      // Wait for any pending async operations
      await Future.delayed(Duration(milliseconds: 100));
    });
  });
}
