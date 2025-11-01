import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adam_s_application/presentation/nearby_mosques_screen/notifier/nearby_mosques_notifier.dart';

void main() {
  group('NearbyMosquesNotifier', () {
    test('loads mock data and supports toggles and reset', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Ensure the autoDispose provider is kept alive during the test by
      // adding a listener. Without this, the provider may be disposed
      // before its delayed mock loader completes.
      container.listen(
        nearbyMosquesNotifierProvider,
        (previous, next) {},
        fireImmediately: true,
      );

  // initial state should be loading (initial factory sets isLoading=true)
  final initial = container.read(nearbyMosquesNotifierProvider);
  expect(initial.isLoading, isTrue);

      // Wait for mock data loader (500ms)
      await Future.delayed(const Duration(milliseconds: 600));

      final loaded = container.read(nearbyMosquesNotifierProvider);
      expect(loaded.isLoading, isFalse);
      expect(loaded.mosques, isNotEmpty);

      final notifier = container.read(nearbyMosquesNotifierProvider.notifier);
      // toggle map expansion
      final before = container.read(nearbyMosquesNotifierProvider).isMapExpanded;
      notifier.toggleMapExpansion();
      expect(container.read(nearbyMosquesNotifierProvider).isMapExpanded, !before);

      // expand a mosque
  final firstId = loaded.mosques.first.id;
      notifier.toggleMosqueExpansion(firstId);
      expect(container.read(nearbyMosquesNotifierProvider).expandedMosqueId, firstId);

      // collapse
      notifier.toggleMosqueExpansion(firstId);
      expect(container.read(nearbyMosquesNotifierProvider).expandedMosqueId, isNull);

      // reset state
      notifier.resetState();
      final reset = container.read(nearbyMosquesNotifierProvider);
      expect(reset.searchQuery, isEmpty);
      expect(reset.expandedMosqueId, isNull);
      expect(reset.isMapExpanded, isFalse);
      expect(reset.resetTimestamp, isNonZero);
    });
  });
}
