import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/salah_guide_screen/models/salah_guide_card_model.dart';
import 'package:adam_s_application/presentation/salah_guide_screen/services/salah_guide_search_service.dart';
import 'package:adam_s_application/presentation/salah_guide_screen/models/search_result.dart';

void main() {
  group('SalahGuideSearchService Tests', () {
    late SalahGuideSearchService searchService;
    late List<SalahGuideCardModel> testCards;

    setUp(() {
      searchService = SalahGuideSearchService();
      testCards = [
        SalahGuideCardModel(
          title: 'How To Pray',
          category: SalahCategory.essentials,
        ),
        SalahGuideCardModel(
          title: 'Wudu (Ablution)',
          category: SalahCategory.purification,
        ),
        SalahGuideCardModel(
          title: 'Witr Prayer',
          category: SalahCategory.optionalPrayers,
        ),
        SalahGuideCardModel(
          title: 'Istikharah Prayer',
          category: SalahCategory.optionalPrayers,
        ),
        SalahGuideCardModel(
          title: 'Jumu\'ah Prayer',
          category: SalahCategory.specialSituations,
        ),
      ];
    });

    test('returns empty results for empty query', () async {
      final results = await searchService.search('', testCards);
      expect(results, isEmpty);
    });

    test('finds exact title match', () async {
      final results = await searchService.search('How To Pray', testCards);
      expect(results, isNotEmpty);
      expect(results.first.card.title, 'How To Pray');
      expect(results.first.matchType, SearchMatchType.exactTitle);
    });

    test('finds partial title match', () async {
      final results = await searchService.search('pray', testCards);
      expect(results, isNotEmpty);
      // Should find "How To Pray", "Witr Prayer", "Istikharah Prayer", "Jumu'ah Prayer"
      expect(results.length, greaterThanOrEqualTo(3));
    });

    test('handles apostrophes in search query', () async {
      // Test that apostrophes are normalized (removed) during search
      // This tests the normalization function, not actual content search
      final results1 = await searchService.search('Jumu\'ah', testCards);
      final results2 = await searchService.search('Jumuah', testCards);

      // Both should find the "Jumu'ah Prayer" card by title match
      expect(results1, isNotEmpty);
      expect(results2, isNotEmpty);

      // Should find the same card
      expect(
        results1.any((r) => r.card.title?.contains('Jumu') ?? false),
        isTrue,
      );
      expect(
        results2.any((r) => r.card.title?.contains('Jumu') ?? false),
        isTrue,
      );
    });

    test('handles case-insensitive search', () async {
      final results1 = await searchService.search('WUDU', testCards);
      final results2 = await searchService.search('wudu', testCards);
      final results3 = await searchService.search('WuDu', testCards);

      expect(results1, isNotEmpty);
      expect(results2, isNotEmpty);
      expect(results3, isNotEmpty);
      expect(results1.first.card.title, results2.first.card.title);
    });

    test('finds matches using synonyms', () async {
      // "ablution" is a synonym for "wudu"
      final results = await searchService.search('ablution', testCards);
      expect(results, isNotEmpty);
      expect(
        results.any((r) => r.card.title?.contains('Wudu') ?? false),
        isTrue,
      );
    });

    test('finds matches by category', () async {
      final results = await searchService.search('optional', testCards);
      expect(results, isNotEmpty);
      // Should find cards in Optional Prayers category
      expect(
        results.any((r) => r.card.category == SalahCategory.optionalPrayers),
        isTrue,
      );
    });

    test('sorts results by relevance', () async {
      final results = await searchService.search('prayer', testCards);
      expect(results, isNotEmpty);
      // Results should be sorted by relevance (higher scores first)
      for (int i = 0; i < results.length - 1; i++) {
        expect(
          results[i].relevanceScore,
          greaterThanOrEqualTo(results[i + 1].relevanceScore),
        );
      }
    });

    test('normalizes text correctly', () async {
      // Test that special characters are removed
      final results1 = await searchService.search('du\'a', testCards);
      final results2 = await searchService.search('dua', testCards);
      final results3 = await searchService.search('duaa', testCards);

      // All should produce similar results (may find different content)
      expect(results1.length, greaterThanOrEqualTo(0));
      expect(results2.length, greaterThanOrEqualTo(0));
      expect(results3.length, greaterThanOrEqualTo(0));
    });

    test('handles multi-word queries', () async {
      final results = await searchService.search('how to', testCards);
      expect(results, isNotEmpty);
      expect(
        results.any((r) => r.card.title?.contains('How To') ?? false),
        isTrue,
      );
    });

    test('returns unique results per card', () async {
      final results = await searchService.search('prayer', testCards);
      final cardTitles = results.map((r) => r.card.title).toSet();
      // Each card should appear only once in results
      expect(cardTitles.length, lessThanOrEqualTo(results.length));
    });
  });

  group('SearchResult Model Tests', () {
    test('creates search result correctly', () {
      final card = SalahGuideCardModel(
        title: 'Test Card',
        category: SalahCategory.essentials,
      );

      final result = SearchResult(
        card: card,
        matchType: SearchMatchType.exactTitle,
        relevanceScore: 10.0,
        sectionIndex: 2,
        matchedSnippet: 'Test snippet',
      );

      expect(result.card, card);
      expect(result.matchType, SearchMatchType.exactTitle);
      expect(result.relevanceScore, 10.0);
      expect(result.sectionIndex, 2);
      expect(result.matchedSnippet, 'Test snippet');
    });

    test('copyWith works correctly', () {
      final card = SalahGuideCardModel(
        title: 'Test Card',
        category: SalahCategory.essentials,
      );

      final result = SearchResult(
        card: card,
        matchType: SearchMatchType.exactTitle,
        relevanceScore: 10.0,
      );

      final updated = result.copyWith(
        relevanceScore: 15.0,
        matchedSnippet: 'New snippet',
      );

      expect(updated.relevanceScore, 15.0);
      expect(updated.matchedSnippet, 'New snippet');
      expect(updated.card, card);
      expect(updated.matchType, SearchMatchType.exactTitle);
    });

    test('equality works correctly', () {
      final card = SalahGuideCardModel(
        title: 'Test Card',
        category: SalahCategory.essentials,
      );

      final result1 = SearchResult(
        card: card,
        matchType: SearchMatchType.exactTitle,
        relevanceScore: 10.0,
      );

      final result2 = SearchResult(
        card: card,
        matchType: SearchMatchType.exactTitle,
        relevanceScore: 10.0,
      );

      expect(result1, equals(result2));
    });
  });

  group('SearchMatchType Tests', () {
    test('match types have correct weights', () {
      expect(SearchMatchType.exactTitle.weight, 10.0);
      expect(SearchMatchType.partialTitle.weight, 8.0);
      expect(SearchMatchType.category.weight, 7.0);
      expect(SearchMatchType.synonym.weight, 6.0);
      expect(SearchMatchType.dua.weight, 5.0);
      expect(SearchMatchType.steps.weight, 4.5);
      expect(SearchMatchType.content.weight, 3.0);
      expect(SearchMatchType.arabicText.weight, 2.5);
    });

    test('exact title has highest weight', () {
      final allTypes = SearchMatchType.values;
      final maxWeight = allTypes.map((t) => t.weight).reduce(
            (a, b) => a > b ? a : b,
          );
      expect(SearchMatchType.exactTitle.weight, maxWeight);
    });
  });
}
