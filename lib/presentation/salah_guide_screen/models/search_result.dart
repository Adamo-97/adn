import '../../../core/app_export.dart';
import 'salah_guide_card_model.dart';

/// Represents a search result with the matched card and content details
class SearchResult extends Equatable {
  /// The card that matched the search
  final SalahGuideCardModel card;

  /// The section index where the match was found (for scrolling)
  final int? sectionIndex;

  /// The matched text snippet (for highlighting)
  final String? matchedSnippet;

  /// The type of match (title, category, content, dua, steps, etc.)
  final SearchMatchType matchType;

  /// Relevance score (higher = more relevant)
  final double relevanceScore;

  const SearchResult({
    required this.card,
    this.sectionIndex,
    this.matchedSnippet,
    required this.matchType,
    required this.relevanceScore,
  });

  @override
  List<Object?> get props => [
        card,
        sectionIndex,
        matchedSnippet,
        matchType,
        relevanceScore,
      ];

  /// Copy with method for immutability
  SearchResult copyWith({
    SalahGuideCardModel? card,
    int? sectionIndex,
    String? matchedSnippet,
    SearchMatchType? matchType,
    double? relevanceScore,
  }) {
    return SearchResult(
      card: card ?? this.card,
      sectionIndex: sectionIndex ?? this.sectionIndex,
      matchedSnippet: matchedSnippet ?? this.matchedSnippet,
      matchType: matchType ?? this.matchType,
      relevanceScore: relevanceScore ?? this.relevanceScore,
    );
  }
}

/// Types of search matches with different relevance weights
enum SearchMatchType {
  exactTitle(weight: 10.0),
  partialTitle(weight: 8.0),
  category(weight: 7.0),
  synonym(weight: 6.0),
  dua(weight: 5.0),
  steps(weight: 4.5),
  content(weight: 3.0),
  arabicText(weight: 2.5);

  final double weight;
  const SearchMatchType({required this.weight});
}
