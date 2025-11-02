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

  group('PrayerTrackerNotifier - extra', () {
    test('togglePrayerCompleted enforces business rules', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Keep provider alive by maintaining a listener
      final subscription = container.listen(
        prayerTrackerNotifierProvider,
        (_, __) {},
      );

      final notifier = container.read(prayerTrackerNotifierProvider.notifier);

      // Wait for initialization to complete
      await Future.delayed(Duration(milliseconds: 150));

      final stateBefore = container.read(prayerTrackerNotifierProvider);
      final current = stateBefore.currentPrayer;

      // Try to toggle a future prayer (should be ignored)
      notifier.togglePrayerCompleted('Isha');
      final afterAttempt = container.read(prayerTrackerNotifierProvider);
      // If Isha is after current it should remain unchanged (default false)
      expect(afterAttempt.completedByPrayer['Isha'], isNot(true));

      // Toggle a non-future (current or past) prayer - use currentPrayer itself
      notifier.togglePrayerCompleted(current);
      final afterToggle = container.read(prayerTrackerNotifierProvider);
      expect(afterToggle.completedByPrayer[current], isTrue);

      // Toggling again flips it back
      notifier.togglePrayerCompleted(current);
      final afterToggle2 = container.read(prayerTrackerNotifierProvider);
      expect(afterToggle2.completedByPrayer[current], isFalse);

      // Wait for any pending async operations
      await Future.delayed(Duration(milliseconds: 100));
      subscription.close();
    });

    test('selectDate updates selectedDate and calendarMonth', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Keep provider alive by maintaining a listener
      final subscription = container.listen(
        prayerTrackerNotifierProvider,
        (_, __) {},
      );

      final notifier = container.read(prayerTrackerNotifierProvider.notifier);

      // Wait for initialization to complete
      await Future.delayed(Duration(milliseconds: 150));

      final now = DateTime.now();
      final target = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 3));

      notifier.selectDate(target);
      final s = container.read(prayerTrackerNotifierProvider);
      expect(s.selectedDate.year, target.year);
      expect(s.selectedDate.month, target.month);
      expect(s.selectedDate.day, target.day);
      expect(s.calendarMonth.month, target.month);

      // Wait for any pending async operations
      await Future.delayed(Duration(milliseconds: 100));
      subscription.close();
    });

    test('cycleBell rotates through bell modes', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Keep provider alive by maintaining a listener
      final subscription = container.listen(
        prayerTrackerNotifierProvider,
        (_, __) {},
      );

      final notifier = container.read(prayerTrackerNotifierProvider.notifier);

      // Wait for initialization to complete
      await Future.delayed(Duration(milliseconds: 150));

      final state = container.read(prayerTrackerNotifierProvider);
      final key = state.bellByPrayer.keys.first;
      final first = notifier.bellFor(key);

      notifier.cycleBell(key);
      final second =
          container.read(prayerTrackerNotifierProvider).bellByPrayer[key];
      expect(second != first, isTrue);

      // Cycle twice more to return to original
      notifier.cycleBell(key);
      notifier.cycleBell(key);
      final third =
          container.read(prayerTrackerNotifierProvider).bellByPrayer[key];
      expect(third, equals(first));

      // Wait for any pending async operations
      await Future.delayed(Duration(milliseconds: 100));
      subscription.close();
    });
  });
}
