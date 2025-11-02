# Salah Guide Search Engine - Quick Reference

## Overview

A sophisticated multi-layered search system for Islamic prayer content with intelligent relevance scoring, synonym matching, and content-type detection.

## Key Features

- ✅ **8 Match Types** with weighted scores (2.5-10.0)
- ✅ **50+ Synonym Mappings** (prayer/salah/namaz, etc.)
- ✅ **Content Caching** for fast searches (<50ms)
- ✅ **Smart Filtering** (threshold 1.5, top 15 results)
- ✅ **Scroll-to-Section** with highlight animation
- ✅ **Special Character Handling** (apostrophes, quotes, diacritics)

## Architecture

```text
Search Input (debounced 300ms)
    ↓
SalahGuideNotifier (state management)
    ↓
SalahGuideSearchService (core engine)
    ├─ Stage 1: Title Matching (exact/partial)
    ├─ Stage 2: Category Matching
    ├─ Stage 3: Synonym Expansion
    └─ Stage 4: Content Scanning (section-level)
    ↓
SearchResult[] (sorted by relevance)
    ↓
UI Rendering (color-coded cards)
```

## Match Types & Weights

| Type | Weight | Description | Example |
|------|--------|-------------|---------|
| `exactTitle` | 10.0 | Exact card title match | "wudu" → "Wudu" |
| `partialTitle` | 8.0 | All query words in title | "how wudu" → "How to Perform Wudu" |
| `category` | 7.0 | Category name match | "purification" → cards in category |
| `synonym` | 6.0 | Synonym mapping | "ablution" → "Wudu" |
| `dua` | 5.0 | Supplication content | "dua" → sections with duas |
| `steps` | 4.5 | Step-by-step guides | "steps" → numbered lists |
| `content` | 3.0 | General text match | "intention" → mentions in text |
| `arabicText` | 2.5 | Arabic text segments | Query matches Arabic content |

## Key Files

| File | Purpose | Lines |
|------|---------|-------|
| `salah_guide_search_service.dart` | Core search engine | 501 |
| `search_result.dart` | Data models | 100 |
| `salah_guide_screen.dart` | UI integration | 551 |
| `salah_guide_search_service_test.dart` | Unit tests | 16 tests |

## Usage Example

```dart
// Initialize
final service = SalahGuideSearchService();
await service.initialize(allCards);

// Search
final results = await service.search("dua qunut", allCards);

// Process
for (final result in results) {
  print('${result.card.title} - Score: ${result.relevanceScore}');
  print('Section: ${result.sectionIndex}, Type: ${result.matchType}');
}
```

## Search Algorithm

### 4-Stage Pipeline

1. **Title Matching**: Exact → Partial match
2. **Category Matching**: Check card categories
3. **Synonym Expansion**: Map alternative terms
4. **Content Scanning**: Section-level text search

### Text Normalization

```dart
"Jumu'ah" → "jumuah"  // Remove apostrophes
"WUDU"   → "wudu"     // Lowercase
"prayer!" → "prayer"  // Remove punctuation
```

### Relevance Scoring

```text
Score = matchType.weight × matchRatio × contentBoost

Example (Dua with Arabic):
5.0 (dua weight) × 1.0 (full match) × 1.5 (dua boost) × 1.3 (Arabic boost)
= 9.75 final score
```

## Content Type Detection

### Dua Detection (3-Priority System)

1. **Priority 1**: Section title contains "dua", "supplication", "recite"
2. **Priority 2**: Has Arabic text + query contains "dua"
3. **Priority 3**: Keyword matching fallback

### Score Boosting

- Dua matches: **×1.5 base boost**
- With Arabic text: **×1.3 additional boost**
- Total potential: **×1.95 boost** for Arabic duas

## Filtering

```dart
// Relevance Threshold: 1.5 (filters weak matches)
results.where((r) => r.relevanceScore >= 1.5)

// Result Limit: 15 (prevents overwhelming)
results.sublist(0, 15)
```

## Performance

- **Average Search**: <50ms (with cached content)
- **Content Caching**: One-time JSON parsing
- **Debounced Input**: 300ms delay reduces CPU usage
- **Early Termination**: Stop on exact match
- **Memory**: Single service instance, shared cache

## Synonyms

Common mappings:

```dart
'prayer'  → ['salah', 'salat', 'namaz', 'pray']
'wudu'    → ['ablution', 'wudhu', 'wudoo']
'dua'     → ['supplication', 'prayer', 'du\'a', 'duaa']
'sunnah'  → ['optional', 'nafl', 'voluntary']
'witr'    → ['witir', 'witer']
'tahajjud'→ ['qiyam', 'night prayer']
'jumu\'ah'→ ['friday', 'jumua', 'jumuah']
```

## UI Integration

### Color-Coded Badges

- **Green**: Title matches (exact/partial)
- **Purple**: Dua content
- **Orange**: Step-by-step guides
- **Teal**: Arabic text
- **Blue**: General content

### Scroll-to-Section

```dart
Navigator.push(
  InfoPageScreen(
    cardTitle: result.card.title,
    initialSectionIndex: result.sectionIndex, // Scroll target
  ),
);

// Highlight animation: Fade from 15% → 0% over 1.5s
```

## Testing

```bash
# Run all tests (397 total)
flutter test

# Run search tests only
flutter test test/presentation/salah_guide_screen/services/

# With coverage
flutter test --coverage
```

### Test Coverage

- ✅ Empty query handling
- ✅ Exact/partial title matching
- ✅ Apostrophe variations (jumu'ah/jumuah)
- ✅ Case-insensitive search
- ✅ Synonym matching (ablution → wudu)
- ✅ Relevance sorting (descending)
- ✅ Threshold filtering (≥1.5)
- ✅ Result limiting (≤15)
- ✅ Section-level content search
- ✅ Multi-word queries

## Common Operations

### Add New Synonyms

```dart
// In salah_guide_search_service.dart
static final Map<String, List<String>> _searchSynonyms = {
  'charity': ['sadaqah', 'zakat', 'donation'],
};
```

### Add New Match Type

```dart
// 1. Add enum value
enum SearchMatchType {
  hadith(weight: 5.5);
}

// 2. Update detection logic
if (_isHadithSection(section)) {
  matchType = SearchMatchType.hadith;
}

// 3. Update UI colors
case SearchMatchType.hadith:
  return Colors.brown;
```

### Adjust Relevance Weights

```dart
// Change enum weights
enum SearchMatchType {
  dua(weight: 7.0),  // Increase from 5.0 to boost dua priority
}
```

## Troubleshooting

### No Results

```dart
// Check content cache
print('Cache size: ${_contentIndex.length}');
if (_contentIndex.isEmpty) await service.initialize(allCards);

// Lower threshold temporarily
const relevanceThreshold = 0.5; // Was 1.5
```

### Slow Performance (>500ms)

```dart
// Profile search
final stopwatch = Stopwatch()..start();
await service.search(query, allCards);
print('Search: ${stopwatch.elapsedMilliseconds}ms');

// Optimize: Ensure cache loaded, reduce card count
```

### Apostrophes Not Matching

```dart
// Verify normalization
print(_normalizeText("jumu'ah")); // Should: "jumuah"

// Check regex pattern
RegExp(r"['\'`''""]") // All apostrophe types
```

## Key Metrics

- **Total Code**: 1,168 lines (service + models + tests)
- **Test Coverage**: 16 unit tests, 100% passing
- **Average Search Time**: <50ms
- **Synonym Mappings**: 50+
- **Match Types**: 8
- **Supported Special Chars**: Apostrophes, quotes, diacritics

## Best Practices

### For Developers

1. Always use `_normalizeText()` before comparing text
2. Cache content in `_contentIndex` to avoid repeated parsing
3. Use weighted scoring to prioritize important matches
4. Filter results (threshold + limit) for UX quality
5. Test with real user queries

### For Content Authors

1. Use consistent terminology in titles/sections
2. Include Arabic text for duas
3. Add section titles for better matching
4. Use natural keywords users might search
5. Structure content logically (title → body → examples)

## References

- **Full Documentation**: `docs/Search_Engine_Documentation.md`
- **Source Code**: `lib/presentation/salah_guide_screen/services/`
- **Tests**: `test/presentation/salah_guide_screen/services/`
- **Project Guidelines**: `.github/copilot-instructions.md`

---

**Version**: 1.0.0  
**Last Updated**: November 2, 2025
