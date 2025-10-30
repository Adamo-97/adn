import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adam_s_application/presentation/nearby_mosques_screen/nearby_mosques_screen.dart';
import 'package:adam_s_application/presentation/nearby_mosques_screen/notifier/nearby_mosques_notifier.dart';
import 'package:adam_s_application/core/utils/size_utils.dart';

void main() {
  testWidgets('Nearby mosques shows mock data and expansion/collapse on reset',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Keep provider alive so the autoDispose mock loader can finish
    container.listen(nearbyMosquesNotifierProvider, (p, n) {},
        fireImmediately: true);

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: Sizer(
        builder: (context, orientation, deviceType) => MaterialApp(
          home: const Scaffold(body: NearbyMosquesScreen()),
        ),
      ),
    ));

    // Initially the screen shows a loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for mock loader (500ms) plus a bit of buffer
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // The mock data should be loaded and visible by name
    expect(find.text('Grand Mosque'), findsOneWidget);

    // Tap the first mosque to expand it
    await tester.tap(find.text('Grand Mosque'));
    await tester.pumpAndSettle();

    // Expanded content should include action buttons like 'Search Google'
    // There may be multiple instances in the tree (they remain present but
    // collapsed items have zero height). Verify at least one of them has
    // non-zero layout height (is actually visible).
    final searchElems = find.text('Search Google').evaluate().toList();
    expect(searchElems, isNotEmpty);
    bool anyVisible = false;
    for (final el in searchElems) {
      final rb = el.renderObject as RenderBox?;
      if (rb != null && rb.size.height > 2.0) {
        anyVisible = true;
        break;
      }
    }
    expect(anyVisible, isTrue, reason: 'At least one Search Google button should be visible after expansion');

    // Trigger reset from notifier and verify provider state resets
    final notifier = container.read(nearbyMosquesNotifierProvider.notifier);

    // Confirm the notifier recorded the expanded mosque id after the tap
    final beforeState = container.read(nearbyMosquesNotifierProvider);
    final firstId = beforeState.filteredMosques.first.id;
    expect(beforeState.expandedMosqueId, firstId);

    // Now reset and ensure provider state clears the expansion
    notifier.resetState();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    final afterState = container.read(nearbyMosquesNotifierProvider);
    expect(afterState.expandedMosqueId, isNull);
  }, timeout: const Timeout(Duration(seconds: 10)));
}
