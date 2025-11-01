import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/prayer_tracker_initial_page.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/notifier/prayer_tracker_notifier.dart';
import 'package:adam_s_application/core/utils/size_utils.dart';

void main() {
  testWidgets('Prayer page scroll resets after panels close', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Keep provider alive
    container.listen(prayerTrackerNotifierProvider, (p, n) {});

    // Build page inside Sizer + MaterialApp + Provider scope
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: Sizer(
        builder: (context, orientation, deviceType) => MaterialApp(
          home: Scaffold(body: PrayerTrackerInitialPage()),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Scroll down a bit
    final scrollable = find.byType(Scrollable).first;
    await tester.drag(scrollable, const Offset(0, -300));
    await tester.pumpAndSettle();

    // Open qibla panel
    final notifier = container.read(prayerTrackerNotifierProvider.notifier);
    notifier.toggleQibla();
    await tester.pumpAndSettle();

    // Ensure qibla panel is visible by finding its value key
    expect(find.byKey(const ValueKey('qibla-on')), findsOneWidget);

    // Trigger reset
    notifier.resetState();

    // wait for panel close + scroll animation (300ms + 220ms)
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify scroll position is at top
    final state = tester.state<ScrollableState>(scrollable);
    expect(state.position.pixels, 0.0);
  }, timeout: const Timeout(Duration(seconds: 10)));
}
