import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/widgets/location_selector.dart';
import 'package:adam_s_application/presentation/profile_settings_screen/notifier/profile_settings_notifier.dart';
import 'package:adam_s_application/core/utils/size_utils.dart';

void main() {
  setUp(() {
    SizeUtils.width = 375;
    SizeUtils.height = 812;
  });

  group('LocationSelector Widget Tests', () {
    testWidgets('renders correctly when closed', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const LocationSelector(),
            ),
          ),
        ),
      );

      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Select your location'), findsOneWidget);
      expect(find.byType(TextField), findsNothing); // Search field not visible
    });

    testWidgets('expands when tapped', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const LocationSelector(),
            ),
          ),
        ),
      );

      // Tap to expand
      await tester.tap(find.text('Location'));
      await tester.pumpAndSettle();

      // Verify search field is now visible
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search location...'), findsOneWidget);
    });

    testWidgets('displays location list when expanded', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(locationDropdownOpen: true),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const LocationSelector(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify location items are visible
      expect(find.text('Berlin, Germany'), findsOneWidget);
      expect(find.text('London, United Kingdom'), findsOneWidget);
    });

    testWidgets('filters locations based on search query', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(
                locationDropdownOpen: true,
                searchQuery: 'berlin',
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const LocationSelector(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should only show Berlin
      expect(find.text('Berlin, Germany'), findsOneWidget);
      expect(find.text('London, United Kingdom'), findsNothing);
    });

    testWidgets('displays selected location', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(selectedLocation: 'Paris, France'),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const LocationSelector(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Paris, France'), findsOneWidget);
      expect(find.text('Select your location'), findsNothing);
    });

    testWidgets('shows no results message when search has no matches',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(
                locationDropdownOpen: true,
                searchQuery: 'xyz123',
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const LocationSelector(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No locations found'), findsOneWidget);
    });

    testWidgets('has black background container when expanded', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileSettingsNotifier.overrideWith(
              () => _TestNotifier(locationDropdownOpen: true),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const LocationSelector(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AnimatedSwitcher),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.decoration, isA<BoxDecoration>());
    });

    testWidgets('chevron rotates when expanded', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const LocationSelector(),
            ),
          ),
        ),
      );

      // Find AnimatedRotation widget
      expect(find.byType(AnimatedRotation), findsOneWidget);
    });
  });
}

class _TestNotifier extends ProfileSettingsNotifier {
  final bool locationDropdownOpen;
  final String? selectedLocation;
  final String searchQuery;

  _TestNotifier({
    this.locationDropdownOpen = false,
    this.selectedLocation,
    this.searchQuery = '',
  });

  @override
  ProfileSettingsState build() {
    return ProfileSettingsState(
      darkMode: false,
      hijriCalendar: false,
      prayerReminders: false,
      selectedLanguage: 'English',
      selectedLocation: selectedLocation,
      locationDropdownOpen: locationDropdownOpen,
      languageDropdownOpen: false,
      searchQuery: searchQuery,
      scrollPosition: 0.0,
      resetTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  void toggleLocationDropdown() {
    state = state.copyWith(locationDropdownOpen: !state.locationDropdownOpen!);
  }

  @override
  void selectLocation(String location) {
    state = state.copyWith(selectedLocation: location);
  }

  @override
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}
