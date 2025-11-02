import 'dart:convert';
import 'package:flutter/services.dart';
import '../../info_page_screen/models/info_page_section.dart';
import '../models/salah_guide_card_model.dart';
import '../models/search_result.dart';

/// Service for searching through Salah Guide content with advanced matching
class SalahGuideSearchService {
  /// Cached content index for fast searching
  final Map<String, List<InfoPageSection>> _contentIndex = {};

  /// Synonyms and alternative terms for better search results
  static final Map<String, List<String>> _searchSynonyms = {
    // Prayer types
    'prayer': ['salah', 'salat', 'namaz', 'pray'],
    'salah': ['prayer', 'salat', 'namaz'],
    'optional': ['sunnah', 'nafl', 'voluntary', 'recommended'],
    'sunnah': ['optional', 'nafl', 'voluntary', 'recommended'],

    // Prayer names
    'witr': ['witir', 'witer'],
    'tahajjud': ['qiyam', 'night prayer', 'late night'],
    'istikharah': ['istikhara', 'seeking guidance'],
    'janazah': ['funeral', 'janaza'],
    'jumu\'ah': ['friday', 'jumua', 'jumuah'],
    'eid': ['festival', 'celebration'],
    'kusuf': ['eclipse', 'solar eclipse', 'lunar eclipse'],
    'rawatib': ['sunnah prayers', 'regular sunnah'],

    // Purification
    'wudu': ['ablution', 'wudhu', 'wudoo'],
    'ghusl': ['bath', 'full bath', 'ritual bath'],
    'tayammum': ['dry ablution', 'substitute'],

    // Content types
    'dua': ['supplication', 'prayer', 'du\'a', 'duaa'],
    'steps': ['how to', 'guide', 'instructions', 'procedure'],
    'conditions': ['requirements', 'prerequisites', 'rules'],
    'time': ['times', 'timing', 'schedule', 'when'],

    // Hajj & Umrah
    'hajj': ['pilgrimage', 'haj'],
    'umrah': ['minor pilgrimage', 'umra'],
    'kabah': ['kaaba', 'ka\'bah', 'kaabah'],
    'tawaf': ['circumambulation', 'circling'],

    // Situations
    'travel': ['traveling', 'journey', 'trip'],
    'ill': ['sick', 'illness', 'disease'],
    'forget': ['forgetfulness', 'forgot', 'mistake'],
  };

  /// Keywords that indicate specific content types
  static final Map<String, List<String>> _contentTypeKeywords = {
    'dua': ['dua', 'supplication', 'prayer', 'recite', 'say'],
    'steps': [
      'step',
      'how to',
      'guide',
      'perform',
      'procedure',
      'begin',
      'start'
    ],
    'conditions': ['condition', 'requirement', 'must', 'prerequisite', 'rule'],
    'time': ['time', 'timing', 'when', 'schedule', 'fajr', 'dhuhr', 'asr'],
  };

  /// Initialize the service and load all content
  Future<void> initialize(List<SalahGuideCardModel> allCards) async {
    _contentIndex.clear();

    for (final card in allCards) {
      if (card.title == null) continue;

      try {
        final jsonPath = _getJsonPath(card.title!);
        final content = await _loadJsonContent(jsonPath);
        _contentIndex[card.title!] = content;
      } catch (e) {
        // Content file doesn't exist or failed to load - skip
        continue;
      }
    }
  }

  /// Search through all cards and content with advanced matching
  Future<List<SearchResult>> search(
    String query,
    List<SalahGuideCardModel> allCards,
  ) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final normalizedQuery = _normalizeText(query);
    final queryWords = normalizedQuery.split(' ').where((w) => w.length > 2).toList(); // Ignore short words like "i", "a"
    var results = <SearchResult>[];

    // Ensure content is loaded
    if (_contentIndex.isEmpty) {
      await initialize(allCards);
    }

    for (final card in allCards) {
      if (card.title == null) continue;

      final matches = <SearchResult>[];

      // 1. Search in card title
      final titleMatches = _searchInTitle(card, normalizedQuery, queryWords);
      matches.addAll(titleMatches);

      // 2. Search in category
      final categoryMatch =
          _searchInCategory(card, normalizedQuery, queryWords);
      if (categoryMatch != null) {
        matches.add(categoryMatch);
      }

      // 3. Search in synonyms
      final synonymMatches = _searchInSynonyms(card, normalizedQuery);
      matches.addAll(synonymMatches);

      // 4. Search in content
      final content = _contentIndex[card.title!];
      if (content != null) {
        final contentMatches =
            _searchInContent(card, content, normalizedQuery, queryWords);
        matches.addAll(contentMatches);
      }

      // Add unique matches with highest relevance score
      if (matches.isNotEmpty) {
        // Group by section index and keep highest score
        final uniqueMatches = <int?, SearchResult>{};
        for (final match in matches) {
          final existing = uniqueMatches[match.sectionIndex];
          if (existing == null ||
              match.relevanceScore > existing.relevanceScore) {
            uniqueMatches[match.sectionIndex] = match;
          }
        }
        results.addAll(uniqueMatches.values);
      }
    }

    // Sort by relevance score (descending) and limit results
    results.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    // Filter out low-relevance results (stricter threshold to reduce noise)
    const relevanceThreshold = 2.5;
    results = results
        .where((r) => r.relevanceScore >= relevanceThreshold)
        .toList();

    // Limit to top 8 most relevant results to avoid overwhelming users
    if (results.length > 8) {
      results = results.sublist(0, 8);
    }

    return results;
  }

  /// Search in card title
  List<SearchResult> _searchInTitle(
    SalahGuideCardModel card,
    String normalizedQuery,
    List<String> queryWords,
  ) {
    final results = <SearchResult>[];
    final normalizedTitle = _normalizeText(card.title!);

    // Exact title match
    if (normalizedTitle == normalizedQuery) {
      results.add(SearchResult(
        card: card,
        matchType: SearchMatchType.exactTitle,
        relevanceScore: SearchMatchType.exactTitle.weight,
        matchedSnippet: card.title,
      ));
      return results;
    }

    // Partial title match - all query words in title
    final titleWords = normalizedTitle.split(' ');
    final matchedWords =
        queryWords.where((qw) => titleWords.any((tw) => tw.contains(qw)));

    if (matchedWords.length == queryWords.length) {
      final score = SearchMatchType.partialTitle.weight *
          (matchedWords.length / queryWords.length);
      results.add(SearchResult(
        card: card,
        matchType: SearchMatchType.partialTitle,
        relevanceScore: score,
        matchedSnippet: card.title,
      ));
    }

    return results;
  }

  /// Search in category name
  SearchResult? _searchInCategory(
    SalahGuideCardModel card,
    String normalizedQuery,
    List<String> queryWords,
  ) {
    if (card.category == null) return null;

    final categoryName = _normalizeText(card.category!.title);
    final categoryWords = categoryName.split(' ');

    // Check if query matches category
    final matchedWords =
        queryWords.where((qw) => categoryWords.any((cw) => cw.contains(qw)));

    if (matchedWords.isNotEmpty) {
      final score = SearchMatchType.category.weight *
          (matchedWords.length / queryWords.length);
      return SearchResult(
        card: card,
        matchType: SearchMatchType.category,
        relevanceScore: score,
        matchedSnippet: card.category!.title,
      );
    }

    return null;
  }

  /// Search using synonyms for better matching
  List<SearchResult> _searchInSynonyms(
    SalahGuideCardModel card,
    String normalizedQuery,
  ) {
    final results = <SearchResult>[];
    final normalizedTitle = _normalizeText(card.title!);

    // Check if query matches any synonyms of words in the title
    for (final entry in _searchSynonyms.entries) {
      final keyword = entry.key;
      final synonyms = entry.value;

      // If title contains keyword and query contains synonym
      if (normalizedTitle.contains(keyword) &&
          synonyms.any((syn) => normalizedQuery.contains(syn))) {
        results.add(SearchResult(
          card: card,
          matchType: SearchMatchType.synonym,
          relevanceScore: SearchMatchType.synonym.weight * 0.9,
          matchedSnippet: card.title,
        ));
        break;
      }

      // If title contains synonym and query contains keyword
      if (synonyms.any((syn) => normalizedTitle.contains(syn)) &&
          normalizedQuery.contains(keyword)) {
        results.add(SearchResult(
          card: card,
          matchType: SearchMatchType.synonym,
          relevanceScore: SearchMatchType.synonym.weight * 0.9,
          matchedSnippet: card.title,
        ));
        break;
      }
    }

    return results;
  }

  /// Search in page content with section-level granularity
  List<SearchResult> _searchInContent(
    SalahGuideCardModel card,
    List<InfoPageSection> sections,
    String normalizedQuery,
    List<String> queryWords,
  ) {
    final results = <SearchResult>[];

    for (int i = 0; i < sections.length; i++) {
      final section = sections[i];
      final sectionText = _extractSectionText(section);
      final normalizedSectionText = _normalizeText(sectionText);

      // Check for exact phrase match first (huge boost)
      final hasExactPhrase = normalizedSectionText.contains(normalizedQuery);
      
      // Search in section text
      final matchedWords =
          queryWords.where((qw) => normalizedSectionText.contains(qw)).toList();

      // Skip if no matches at all
      if (matchedWords.isEmpty && !hasExactPhrase) {
        continue;
      }

      // Calculate phrase proximity score (0.0 to 1.0)
      // This prevents results with scattered word matches from ranking high
      double proximityScore = 0.0;
      if (hasExactPhrase) {
        proximityScore = 1.0; // Perfect match
      } else if (matchedWords.length >= 3) {
        // Check if at least 3 words appear within reasonable proximity
        // For multi-word queries, we want words to appear close together
        final firstMatchPos = normalizedSectionText.indexOf(matchedWords.first);
        final lastMatchPos = normalizedSectionText.indexOf(matchedWords.last);
        final distance = (lastMatchPos - firstMatchPos).abs();
        
        // If matched words span less than 100 characters, it's a good proximity
        if (distance < 100) {
          proximityScore = 0.8;
        } else if (distance < 200) {
          proximityScore = 0.5;
        } else {
          proximityScore = 0.2;
        }
      } else {
        // For 1-2 word matches, accept them but with lower score
        proximityScore = 0.4;
      }

      // Require minimum proximity for multi-word queries
      // Skip scattered matches that don't form meaningful phrases
      final isMultiWordQuery = queryWords.length >= 3;
      if (isMultiWordQuery && proximityScore < 0.5 && !hasExactPhrase) {
        continue;
      }
      
      // Detect content type
      final contentType = _detectContentType(section, normalizedQuery);

      final matchRatio = hasExactPhrase ? 1.0 : (matchedWords.length / queryWords.length);

      // Calculate relevance based on content type and match ratio
      double relevanceScore;
      SearchMatchType matchType;

      if (contentType == 'dua') {
        matchType = SearchMatchType.dua;
        // Boost score significantly for dua matches
        relevanceScore = SearchMatchType.dua.weight * matchRatio * 1.5;
        
        // Apply proximity factor
        relevanceScore *= (0.5 + (proximityScore * 0.5)); // 50%-100% of score based on proximity
        
        // Extra boost if the section has Arabic text (actual dua content)
        if (section.formattedText != null &&
            section.formattedText!.any((seg) => seg.type == 'arabic_text')) {
          relevanceScore *= 1.3;
        }
        
        // HUGE boost for exact phrase match in dua
        if (hasExactPhrase) {
          relevanceScore *= 2.5;
        }
      } else if (contentType == 'steps') {
        matchType = SearchMatchType.steps;
        relevanceScore = SearchMatchType.steps.weight * matchRatio;
        relevanceScore *= (0.5 + (proximityScore * 0.5));
        if (hasExactPhrase) relevanceScore *= 2.0;
      } else if (section.formattedText != null &&
          section.formattedText!.any((seg) =>
              seg.type == 'arabic_text' || seg.type == 'quran_verse')) {
        matchType = SearchMatchType.arabicText;
        relevanceScore = SearchMatchType.arabicText.weight * matchRatio;
        relevanceScore *= (0.5 + (proximityScore * 0.5));
        if (hasExactPhrase) relevanceScore *= 2.0;
      } else {
        matchType = SearchMatchType.content;
        relevanceScore = SearchMatchType.content.weight * matchRatio;
        relevanceScore *= (0.5 + (proximityScore * 0.5));
        if (hasExactPhrase) relevanceScore *= 1.5;
      }

      // Extract snippet around match
      final snippet = _extractSnippet(sectionText, queryWords);

      results.add(SearchResult(
        card: card,
        sectionIndex: i,
        matchType: matchType,
        relevanceScore: relevanceScore,
        matchedSnippet: snippet,
      ));
    }

    return results;
  }

  /// Detect content type based on keywords and structure
  String? _detectContentType(InfoPageSection section, String normalizedQuery) {
    final sectionText = _normalizeText(_extractSectionText(section));
    final sectionTitle = section.text != null && section.type == SectionType.sectionTitle
        ? _normalizeText(section.text!)
        : '';

    // Priority 1: Check section title for explicit dua indicators
    if (sectionTitle.contains('dua') ||
        sectionTitle.contains('supplication') ||
        sectionTitle.contains('recite')) {
      return 'dua';
    }

    // Priority 2: Detect supplication content by prayer phrases
    // Check for common Islamic supplication indicators
    final isSupplication = sectionText.contains('o allah') ||
        (sectionText.contains('allah') && 
         (sectionText.contains('i ask') || 
          sectionText.contains('grant me') ||
          sectionText.contains('guide me') ||
          sectionText.contains('forgive me') ||
          sectionText.contains('bless me') ||
          sectionText.contains('your mercy') ||
          sectionText.contains('your knowledge') ||
          sectionText.contains('you are able') ||
          sectionText.contains('you know')));
    
    if (isSupplication) {
      return 'dua';
    }

    // Priority 3: Check if section has Arabic text (likely dua or Quran)
    if (section.formattedText != null &&
        section.formattedText!.any((seg) => seg.type == 'arabic_text')) {
      // If query is asking for dua and we have Arabic, it's likely a dua
      if (normalizedQuery.contains('dua') ||
          normalizedQuery.contains('supplication')) {
        return 'dua';
      }
    }

    // Priority 4: Check if query or section matches content type keywords
    for (final entry in _contentTypeKeywords.entries) {
      final contentType = entry.key;
      final keywords = entry.value;

      // For dua searches, prioritize sections with Arabic
      if (contentType == 'dua' && normalizedQuery.contains('dua')) {
        if (section.formattedText != null &&
            section.formattedText!.any((seg) => seg.type == 'arabic_text')) {
          return 'dua';
        }
      }

      if (keywords.any(
          (kw) => normalizedQuery.contains(kw) || sectionText.contains(kw))) {
        return contentType;
      }
    }

    // Check if it's a list (likely steps)
    if (section.type == SectionType.list) {
      return 'steps';
    }

    return null;
  }

  /// Extract all text from a section (including formatted text)
  String _extractSectionText(InfoPageSection section) {
    final buffer = StringBuffer();

    // Add section text
    if (section.text != null && section.text!.isNotEmpty) {
      buffer.write(section.text);
      buffer.write(' ');
    }

    // Add formatted text segments
    if (section.formattedText != null) {
      for (final segment in section.formattedText!) {
        buffer.write(segment.text);
        buffer.write(' ');
      }
    }

    // Add list items
    if (section.items != null) {
      for (final item in section.items!) {
        if (item is String) {
          buffer.write(item);
          buffer.write(' ');
        } else if (item is ListItemData) {
          if (item.plainText != null) {
            buffer.write(item.plainText);
            buffer.write(' ');
          }
          if (item.formattedText != null) {
            for (final segment in item.formattedText!) {
              buffer.write(segment.text);
              buffer.write(' ');
            }
          }
        }
      }
    }

    return buffer.toString();
  }

  /// Extract a relevant snippet around the matched words
  String _extractSnippet(String text, List<String> queryWords) {
    const snippetLength = 100;

    // Find first match position
    final normalizedText = _normalizeText(text);
    int matchPos = -1;

    for (final word in queryWords) {
      matchPos = normalizedText.indexOf(word);
      if (matchPos != -1) break;
    }

    if (matchPos == -1) {
      return text.substring(0, text.length.clamp(0, snippetLength));
    }

    // Extract context around match
    final start = (matchPos - snippetLength ~/ 2).clamp(0, text.length);
    final end = (matchPos + snippetLength ~/ 2).clamp(0, text.length);

    String snippet = text.substring(start, end);

    // Add ellipsis
    if (start > 0) snippet = '...$snippet';
    if (end < text.length) snippet = '$snippet...';

    return snippet.trim();
  }

  /// Normalize text for comparison (lowercase, remove punctuation and special characters)
  /// This handles apostrophes, quotes, diacritics, and other special characters
  /// to make search more forgiving and user-friendly
  String _normalizeText(String text) {
    return text
        .toLowerCase()
        // Remove all types of apostrophes and quotes
        .replaceAll(RegExp(r"['\'`''""]"), '')
        // Remove diacritics and special punctuation (but keep Arabic and alphanumeric)
        .replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), ' ')
        // Collapse multiple spaces into one
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Get JSON file path from card title
  String _getJsonPath(String title) {
    // Special mappings for titles that don't match JSON filenames
    const titleToFilename = {
      'Importance of Prayer': 'prayer_introduction',
      'Traveling Prayer': 'prayer_while_traveling',
      'Wudu (Ablution)': 'wudu_guide',
      'Ghusl (Full Bath)': 'ghusl_guide',
      'Tayammum': 'substitute_ablution',
    };

    // Check if there's a special mapping
    if (titleToFilename.containsKey(title)) {
      return 'assets/data/info_pages/en/${titleToFilename[title]}.json';
    }

    // Otherwise convert title to snake_case filename
    final filename = title
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), '_');

    return 'assets/data/info_pages/en/$filename.json';
  }

  /// Load JSON content from asset file
  Future<List<InfoPageSection>> _loadJsonContent(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final sectionsJson = jsonData['sections'] as List<dynamic>;

    return sectionsJson
        .map((json) => InfoPageSection.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
