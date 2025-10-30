import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/nearby_mosques_screen/widgets/mosque_image_tile.dart';
// No extra imports required for placeholder test
import 'package:adam_s_application/core/utils/size_utils.dart';

// No custom test bundle needed now; asset-backed image tests are omitted
// from unit/widget tests to avoid needing an AssetManifest and native image
// decoding in the test harness.

void main() {
  testWidgets('MosqueImageTile shows placeholder when no imageUrl',
      (tester) async {
    await tester.pumpWidget(Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: MosqueImageTile(
              imageUrl: null,
              isExpanded: false,
            ),
          ),
        ),
      ),
    ));

    expect(find.text('No Image'), findsOneWidget);
  });

  // Note: asset-backed image rendering (Image.asset) requires a valid
  // AssetManifest and native image decoding; covering the placeholder case
  // (no imageUrl) is sufficient in unit/widget tests. Integration tests can
  // validate actual asset rendering if needed.
}
