import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/nearby_mosques_screen/widgets/mosque_card.dart';
import 'package:adam_s_application/presentation/nearby_mosques_screen/models/mosque_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adam_s_application/core/utils/size_utils.dart';

void main() {
  testWidgets('MosqueCard expansion makes action buttons visible',
      (tester) async {
    final mosque = MosqueModel(
      id: '1',
      name: 'Test Mosque',
      address: '123 Test St',
      distance: 1.2,
      imageUrl: null,
    );

    await tester.pumpWidget(ProviderScope(
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                // collapsed
                MosqueCard(mosque: mosque, isExpanded: false),
                // expanded
                MosqueCard(mosque: mosque, isExpanded: true),
              ],
            ),
          ),
        );
      }),
    ));

    await tester.pumpAndSettle();

    // There should be at least one 'Search Google' and at least one must be visible
    final searchFinders = find.text('Search Google');
    expect(searchFinders, findsWidgets);

    // Verify at least one has non-zero layout height
    bool anyVisible = false;
    for (final el in searchFinders.evaluate()) {
      final rb = el.renderObject as RenderBox?;
      if (rb != null && rb.size.height > 2.0) {
        anyVisible = true;
        break;
      }
    }

    expect(anyVisible, isTrue);

    // Verify tapping the collapsed card calls the onTap (using a local flag)
    bool tapped = false;
    await tester.pumpWidget(ProviderScope(
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          home: Scaffold(
            body: MosqueCard(
              mosque: mosque,
              isExpanded: false,
              onTap: () => tapped = true,
            ),
          ),
        );
      }),
    ));

    await tester.tap(find.text('Test Mosque'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });
}
