import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/nearby_mosques_screen/widgets/mosque_action_button.dart';
import 'package:adam_s_application/core/utils/size_utils.dart';

void main() {
  testWidgets('MosqueActionButton renders label and icon and reacts to tap',
      (tester) async {
    bool tapped = false;
    await tester.pumpWidget(Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: MosqueActionButton(
              label: 'Test',
              icon: Icons.search,
              onTap: () => tapped = true,
            ),
          ),
        ),
      ),
    ));

    // label and icon present
    expect(find.text('Test'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);

    // tap works
    await tester.tap(find.text('Test'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });

  testWidgets('MosqueActionButton handles null onTap gracefully',
      (tester) async {
    await tester.pumpWidget(Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: MosqueActionButton(
              label: 'NoTap',
              icon: Icons.info,
              onTap: null,
            ),
          ),
        ),
      ),
    ));

    // tap shouldn't throw
    await tester.tap(find.text('NoTap'));
    await tester.pumpAndSettle();
    expect(find.text('NoTap'), findsOneWidget);
  });
}
