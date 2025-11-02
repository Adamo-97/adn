import '../../../core/app_export.dart';
import '../models/salah_guide_model.dart';
import '../models/salah_guide_card_model.dart';
import '../models/search_result.dart';
import '../services/salah_guide_search_service.dart';

part 'salah_guide_state.dart';

final salahGuideNotifier =
    NotifierProvider.autoDispose<SalahGuideNotifier, SalahGuideState>(
  () => SalahGuideNotifier(),
);

class SalahGuideNotifier extends Notifier<SalahGuideState> {
  final _searchService = SalahGuideSearchService();

  @override
  SalahGuideState build() {
    final initialState = SalahGuideState(
      salahGuideModel: SalahGuideModel(),
    );
    Future.microtask(() => initialize());
    return initialState;
  }

  void initialize() {
    final categorizedCards = <SalahCategory, List<SalahGuideCardModel>>{
      // Essentials Category
      SalahCategory.essentials: [
        SalahGuideCardModel(
          title: 'Importance of Prayer',
          iconPath: ImageConstant.imgImportantIcon,
          category: SalahCategory.essentials,
        ),
        SalahGuideCardModel(
          title: 'How To Pray',
          iconPath: ImageConstant.imgHowToIcon,
          category: SalahCategory.essentials,
        ),
        SalahGuideCardModel(
          title: 'Prayer Times',
          iconPath: ImageConstant.imgPrayerTimes,
          category: SalahCategory.essentials,
        ),
        SalahGuideCardModel(
          title: 'Conditions of Prayer',
          iconPath: ImageConstant.imgConditionsIcon,
          category: SalahCategory.essentials,
        ),
      ],

      // Optional Prayers Category
      SalahCategory.optionalPrayers: [
        SalahGuideCardModel(
          title: 'Rawatib Prayers',
          iconPath: ImageConstant.imgRawatibPrayersIcon,
          category: SalahCategory.optionalPrayers,
        ),
        SalahGuideCardModel(
          title: 'Witr Prayer',
          iconPath: ImageConstant.imgWitrPrayerIcon,
          category: SalahCategory.optionalPrayers,
        ),
        SalahGuideCardModel(
          title: 'Tahajjud Prayer',
          iconPath: ImageConstant.imgTahajjudPrayerIcon,
          category: SalahCategory.optionalPrayers,
        ),
        SalahGuideCardModel(
          title: 'Istikharah Prayer',
          iconPath: ImageConstant.imgIstikaharahPrayerIcon,
          category: SalahCategory.optionalPrayers,
        ),
      ],

      // Special Situations Category
      SalahCategory.specialSituations: [
        SalahGuideCardModel(
          title: 'Traveling Prayer',
          iconPath: ImageConstant.imgTravelingPrayerIcon,
          category: SalahCategory.specialSituations,
        ),
        SalahGuideCardModel(
          title: 'Prayer of the Ill',
          iconPath: ImageConstant.imgPrayerIllIcon,
          category: SalahCategory.specialSituations,
        ),
        SalahGuideCardModel(
          title: 'Janazah Prayer',
          iconPath: ImageConstant.imgJanazahPrayerIcon,
          category: SalahCategory.specialSituations,
        ),
        SalahGuideCardModel(
          title: 'Kusuf Prayer',
          iconPath: ImageConstant.imgKusufPrayerIcon,
          category: SalahCategory.specialSituations,
        ),
        SalahGuideCardModel(
          title: 'Congregational Prayer',
          iconPath: ImageConstant.imgCongregationalPrayerIcon,
          category: SalahCategory.specialSituations,
        ),
        SalahGuideCardModel(
          title: 'Forgetfulness Prostration',
          iconPath: ImageConstant.imgForgetfulnessProstrationIcon,
          category: SalahCategory.specialSituations,
        ),
        SalahGuideCardModel(
          title: 'Eid Prayer',
          iconPath: ImageConstant.imgEidPrayerIcon,
          category: SalahCategory.specialSituations,
        ),
        SalahGuideCardModel(
          title: 'Jumu\'ah Prayer',
          iconPath: ImageConstant.imgJumuahPrayerIcon,
          category: SalahCategory.specialSituations,
        ),
      ],

      // Purification Category
      SalahCategory.purification: [
        SalahGuideCardModel(
          title: 'Wudu (Ablution)',
          iconPath: ImageConstant.imgWuduIcon,
          category: SalahCategory.purification,
        ),
        SalahGuideCardModel(
          title: 'Ghusl (Full Bath)',
          iconPath: ImageConstant.imgGhuslIcon,
          category: SalahCategory.purification,
        ),
        SalahGuideCardModel(
          title: 'Tayammum',
          iconPath: ImageConstant.imgTayammumIcon,
          category: SalahCategory.purification,
        ),
      ],

      // Rituals Category (Hajj & Umrah)
      SalahCategory.rituals: [
        SalahGuideCardModel(
          title: 'Historical Overview',
          iconPath: ImageConstant.imgHistoricalOverview,
          category: SalahCategory.rituals,
        ),
        SalahGuideCardModel(
          title: 'Hajj Guide',
          iconPath: ImageConstant.imgKabaaIcon,
          category: SalahCategory.rituals,
        ),
        SalahGuideCardModel(
          title: 'Umrah Guide',
          iconPath: ImageConstant.imgKabaaIcon,
          category: SalahCategory.rituals,
        ),
      ],
    };

    state = state.copyWith(
      categorizedCards: categorizedCards,
      isLoading: false,
    );

    // Initialize search service with all cards
    final allCards = categorizedCards.values.expand((list) => list).toList();
    _searchService.initialize(allCards);
  }

  /// Perform search with debouncing
  Future<void> search(String query) async {
    // Clear results if query is empty
    if (query.trim().isEmpty) {
      state = state.copyWith(
        searchQuery: '',
        searchResults: [],
        isSearching: false,
      );
      return;
    }

    // Set searching state
    state = state.copyWith(
      searchQuery: query,
      isSearching: true,
    );

    // Get all cards
    final allCards =
        state.categorizedCards.values.expand((list) => list).toList();

    // Perform search
    final results = await _searchService.search(query, allCards);

    // Update state with results
    state = state.copyWith(
      searchResults: results,
      isSearching: false,
    );
  }

  /// Clear search results
  void clearSearch() {
    state = state.copyWith(
      searchQuery: '',
      searchResults: [],
      isSearching: false,
    );
  }

  void selectCard(SalahGuideCardModel card) {
    state = state.copyWith(
      selectedCard: card,
    );
  }

  /// Reset state to initial when navigating away
  void resetState() {
    state = state.copyWith(
      selectedCard: null,
      scrollPosition: 0.0,
      resetTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
