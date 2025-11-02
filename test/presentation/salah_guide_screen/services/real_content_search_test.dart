import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/salah_guide_screen/models/salah_guide_card_model.dart';
import 'package:adam_s_application/presentation/salah_guide_screen/services/salah_guide_search_service.dart';
import 'package:adam_s_application/presentation/salah_guide_screen/models/search_result.dart';

/// REAL CONTENT SEARCH TESTS
///
/// These tests use actual JSON files to verify search behavior with real content.
/// Previous tests only used card titles without content, missing critical bugs.
void main() {
  // Initialize Flutter bindings ONCE for all tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Real Content Search Tests', () {
    late SalahGuideSearchService searchService;
    late List<SalahGuideCardModel> allCards;

    setUp(() async {
      searchService = SalahGuideSearchService();

      // Create cards matching actual JSON files
      allCards = [
        SalahGuideCardModel(
          title: 'Istikharah Prayer',
          category: SalahCategory.optionalPrayers,
          iconPath: 'assets/images/salah_guide/istikharah.svg',
        ),
        SalahGuideCardModel(
          title: 'Historical Overview',
          category: SalahCategory.essentials,
          iconPath: 'assets/images/salah_guide/history.svg',
        ),
        SalahGuideCardModel(
          title: 'How to Pray',
          category: SalahCategory.essentials,
          iconPath: 'assets/images/salah_guide/pray.svg',
        ),
        SalahGuideCardModel(
          title: 'Witr Prayer',
          category: SalahCategory.optionalPrayers,
          iconPath: 'assets/images/salah_guide/witr.svg',
        ),
        SalahGuideCardModel(
          title: 'Tahajjud Prayer',
          category: SalahCategory.optionalPrayers,
          iconPath: 'assets/images/salah_guide/tahajjud.svg',
        ),
      ];

      // Initialize to load actual JSON content
      await searchService.initialize(allCards);
    });

    test(
        'CRITICAL: "o allah I ask your choice" should find Istikharah as top result',
        () async {
      final results =
          await searchService.search('o allah I ask your choice', allCards);

      // Debugging output
      print('\n=== SEARCH RESULTS FOR: "o allah I ask your choice" ===');
      print('Total results: ${results.length}');
      for (int i = 0; i < results.length && i < 5; i++) {
        final r = results[i];
        print(
            '${i + 1}. ${r.card.title} - Score: ${r.relevanceScore.toStringAsFixed(2)} - Type: ${r.matchType}');
        print(
            '   Section: ${r.sectionIndex}, Snippet: ${r.matchedSnippet?.substring(0, r.matchedSnippet!.length.clamp(0, 100))}...');
      }
      print('=========================================\n');

      // Assertions
      expect(results, isNotEmpty,
          reason: 'Should find results for Istikharah dua phrase');

      // Istikharah should be the top result (or at least top 3)
      final topThree = results.take(3).toList();
      final hasIstikharah = topThree.any((r) {
        final title = r.card.title?.toLowerCase() ?? '';
        return title.contains('istikharah') || title.contains('istikhara');
      });

      expect(hasIstikharah, isTrue,
          reason:
              'Istikharah Prayer should be in top 3 results for its own dua text');

      // The TOP result should ideally be Istikharah
      final topResult = results.first;
      final topTitle = topResult.card.title?.toLowerCase() ?? '';
      expect(topTitle.contains('istikharah') || topTitle.contains('istikhara'),
          isTrue,
          reason:
              'Istikharah Prayer should be THE top result for "o allah I ask your choice"');
    });

    test(
        'CRITICAL: Historical Overview should NOT appear for Istikharah-specific dua',
        () async {
      final results =
          await searchService.search('o allah I ask your choice', allCards);

      // Historical Overview should NOT be in results (doesn't contain this phrase)
      final hasHistorical = results.any(
          (r) => r.card.title?.toLowerCase().contains('historical') ?? false);

      expect(hasHistorical, isFalse,
          reason:
              'Historical Overview does not contain "o allah I ask your choice" and should not match');
    });

    test('Search for "dua" should prioritize actual dua sections', () async {
      final results = await searchService.search('dua', allCards);

      print('\n=== SEARCH RESULTS FOR: "dua" ===');
      for (int i = 0; i < results.length && i < 10; i++) {
        final r = results[i];
        print(
            '${i + 1}. ${r.card.title} - Score: ${r.relevanceScore.toStringAsFixed(2)} - Type: ${r.matchType}');
      }
      print('================================\n');

      expect(results, isNotEmpty);

      // Check that dua match types have high scores
      final duaMatches =
          results.where((r) => r.matchType == SearchMatchType.dua);
      expect(duaMatches, isNotEmpty, reason: 'Should find dua-type matches');

      // Dua matches should have scores >= 5.0 (base dua weight)
      for (final duaMatch in duaMatches) {
        expect(duaMatch.relevanceScore, greaterThanOrEqualTo(5.0),
            reason: 'Dua matches should have high relevance scores');
      }
    });

    test('Search for "istikharah dua" should find Istikharah Prayer', () async {
      final results = await searchService.search('istikharah dua', allCards);

      print('\n=== SEARCH RESULTS FOR: "istikharah dua" ===');
      for (int i = 0; i < results.length && i < 5; i++) {
        final r = results[i];
        print(
            '${i + 1}. ${r.card.title} - Score: ${r.relevanceScore.toStringAsFixed(2)} - Type: ${r.matchType}');
      }
      print('==========================================\n');

      expect(results, isNotEmpty);

      // Istikharah should be top result
      final topResult = results.first;
      final topTitle = topResult.card.title?.toLowerCase() ?? '';
      expect(topTitle.contains('istikharah') || topTitle.contains('istikhara'),
          isTrue,
          reason:
              'Istikharah Prayer should be top result for "istikharah dua"');
    });

    test('Multi-word dua phrases should match with high relevance', () async {
      // Test various dua phrases
      final queries = [
        'o allah I ask your choice',
        'allah guide me',
        'seeking guidance',
      ];

      for (final query in queries) {
        final results = await searchService.search(query, allCards);

        print('\n=== SEARCH: "$query" ===');
        print('Results: ${results.length}');
        if (results.isNotEmpty) {
          print(
              'Top: ${results.first.card.title} - ${results.first.relevanceScore.toStringAsFixed(2)}');
        }

        // Should find at least one result for dua-related queries
        expect(results.length, greaterThan(0),
            reason: 'Should find results for dua phrase: "$query"');
      }
    });

    test('Relevance threshold filters out weak matches', () async {
      final results = await searchService.search('the', allCards);

      // All results should have relevance >= 2.5 (new stricter threshold)
      for (final result in results) {
        expect(result.relevanceScore, greaterThanOrEqualTo(2.5),
            reason:
                'All results should meet minimum relevance threshold of 2.5');
      }
    });

    test('Result limit caps at 8 results to avoid overwhelming', () async {
      final results = await searchService.search('prayer', allCards);

      expect(results.length, lessThanOrEqualTo(8),
          reason:
              'Results should be capped at 8 to prevent overwhelming users');
    });

    test('Section-level granularity provides precise navigation', () async {
      final results =
          await searchService.search('o allah I ask your choice', allCards);

      // Results with content matches should have section indexes
      final contentMatches = results.where((r) =>
          r.matchType != SearchMatchType.exactTitle &&
          r.matchType != SearchMatchType.partialTitle);

      for (final match in contentMatches) {
        expect(match.sectionIndex, isNotNull,
            reason:
                'Content matches should include section index for scrolling');
      }
    });
  });
}
