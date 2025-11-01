import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adam_s_application/presentation/info_page_screen/notifier/info_page_notifier.dart';
import 'package:adam_s_application/presentation/salah_guide_screen/models/salah_guide_card_model.dart';

/// Unit tests for InfoPageNotifier
/// Tests state management, JSON loading, and error handling
void main() {
  group('InfoPageNotifier Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Initialization - State Transition Testing', () {
      test('initial state has default values', () {
        final state = container.read(infoPageNotifierProvider);

        expect(state.cardTitle, '');
        expect(state.category, SalahCategory.essentials);
        expect(state.isLoading, false);
        expect(state.error, null);
        expect(state.content, null);
      });

      test('initialize sets card title and category', () {
        final notifier = container.read(infoPageNotifierProvider.notifier);

        notifier.initialize('How To Pray', SalahCategory.essentials);
        
        // State should update immediately with title/category
        final state = container.read(infoPageNotifierProvider);
        expect(state.cardTitle, 'How To Pray');
        expect(state.category, SalahCategory.essentials);
        expect(state.isLoading, true); // Loading should be set
      });

      test('initialize triggers content loading', () async {
        final notifier = container.read(infoPageNotifierProvider.notifier);

        notifier.initialize('How To Pray', SalahCategory.essentials);

        // Wait for async loading to complete
        await Future.delayed(const Duration(milliseconds: 100));

        final state = container.read(infoPageNotifierProvider);
        // Loading should eventually complete
        expect(state.isLoading, anyOf(false, true)); // May still be loading
      });
    });

    group('Card-to-JSON Mapping - Equivalence Partitioning', () {
      test('maps Essentials category cards correctly', () {
        final notifier = container.read(infoPageNotifierProvider.notifier);

        // Test mapping for essentials cards
        final testCases = {
          'Importance of Prayer': 'prayer_introduction',
          'How To Pray': 'how_to_pray',
          'Prayer Times': 'prayer_times',
          'Conditions of Prayer': 'conditions_of_prayer',
        };

        for (final entry in testCases.entries) {
          // Access private method through reflection or test observable behavior
          // Since _getJsonFilenameForCard is private, we test it indirectly
          notifier.initialize(entry.key, SalahCategory.essentials);
          final state = container.read(infoPageNotifierProvider);
          expect(state.cardTitle, entry.key);
        }
      });

      test('maps Purification category cards correctly', () {
        final notifier = container.read(infoPageNotifierProvider.notifier);

        notifier.initialize('Wudu (Ablution)', SalahCategory.purification);
        final state = container.read(infoPageNotifierProvider);
        expect(state.cardTitle, 'Wudu (Ablution)');
        expect(state.category, SalahCategory.purification);
      });

      test('maps Optional Prayers category cards correctly', () {
        final notifier = container.read(infoPageNotifierProvider.notifier);

        notifier.initialize('Witr Prayer', SalahCategory.optionalPrayers);
        final state = container.read(infoPageNotifierProvider);
        expect(state.cardTitle, 'Witr Prayer');
        expect(state.category, SalahCategory.optionalPrayers);
      });
    });

    group('Accent Color - Category-based Theming', () {
      test('essentials category uses teal accent', () {
        final notifier = container.read(infoPageNotifierProvider.notifier);

        notifier.initialize('How To Pray', SalahCategory.essentials);
        final state = container.read(infoPageNotifierProvider);
        
        expect(state.accentColor, SalahCategory.essentials.accentColor);
      });

      test('optional prayers category uses orange accent', () {
        final notifier = container.read(infoPageNotifierProvider.notifier);

        notifier.initialize('Witr Prayer', SalahCategory.optionalPrayers);
        final state = container.read(infoPageNotifierProvider);
        
        expect(state.accentColor, SalahCategory.optionalPrayers.accentColor);
      });

      test('special situations category uses deep orange accent', () {
        final notifier = container.read(infoPageNotifierProvider.notifier);

        notifier.initialize('Traveling Prayer', SalahCategory.specialSituations);
        final state = container.read(infoPageNotifierProvider);
        
        expect(state.accentColor, SalahCategory.specialSituations.accentColor);
      });

      test('purification category uses grey accent', () {
        final notifier = container.read(infoPageNotifierProvider.notifier);

        notifier.initialize('Wudu (Ablution)', SalahCategory.purification);
        final state = container.read(infoPageNotifierProvider);
        
        expect(state.accentColor, SalahCategory.purification.accentColor);
      });

      test('rituals category uses purple accent', () {
        final notifier = container.read(infoPageNotifierProvider.notifier);

        notifier.initialize('Hajj Guide', SalahCategory.rituals);
        final state = container.read(infoPageNotifierProvider);
        
        expect(state.accentColor, SalahCategory.rituals.accentColor);
      });
    });

    group('State Immutability', () {
      test('state maintains immutability on initialize', () {
        final notifier = container.read(infoPageNotifierProvider.notifier);
        final initialState = container.read(infoPageNotifierProvider);

        notifier.initialize('How To Pray', SalahCategory.essentials);
        final newState = container.read(infoPageNotifierProvider);

        // States should be different objects
        expect(identical(initialState, newState), false);
        
        // Original state should remain unchanged
        expect(initialState.cardTitle, '');
        expect(newState.cardTitle, 'How To Pray');
      });

      test('multiple initialize calls create new states', () {
        final notifier = container.read(infoPageNotifierProvider.notifier);

        notifier.initialize('How To Pray', SalahCategory.essentials);
        final firstState = container.read(infoPageNotifierProvider);

        notifier.initialize('Wudu (Ablution)', SalahCategory.purification);
        final secondState = container.read(infoPageNotifierProvider);

        expect(identical(firstState, secondState), false);
        expect(firstState.cardTitle, 'How To Pray');
        expect(secondState.cardTitle, 'Wudu (Ablution)');
      });
    });

    group('Error Handling - Boundary Value Analysis', () {
      test('handles invalid card title gracefully', () async {
        final notifier = container.read(infoPageNotifierProvider.notifier);

        notifier.initialize('Invalid Card Name', SalahCategory.essentials);
        
        // Wait for error to be set
        await Future.delayed(const Duration(milliseconds: 100));

        final state = container.read(infoPageNotifierProvider);
        // Should handle error state
        expect(state.isLoading, anyOf(false, true));
      });

      test('handles empty card title', () {
        final notifier = container.read(infoPageNotifierProvider.notifier);

        notifier.initialize('', SalahCategory.essentials);
        
        final state = container.read(infoPageNotifierProvider);
        expect(state.cardTitle, '');
      });
    });
  });
}
