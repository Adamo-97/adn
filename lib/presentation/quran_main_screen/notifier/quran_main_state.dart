part of 'quran_main_notifier.dart';

class QuranMainState extends Equatable {
  final TextEditingController? searchController;
  final String? searchText;
  final int? selectedTabIndex;
  final bool isLoading;
  final QuranMainModel? quranMainModel;
  final SurahItemModel? surahModel;

  const QuranMainState({
    this.searchController,
    this.searchText,
    this.selectedTabIndex,
    this.isLoading = false,
    this.quranMainModel,
    this.surahModel,
  });

  @override
  List<Object?> get props => [
        searchController,
        searchText,
        selectedTabIndex,
        isLoading,
        quranMainModel,
        surahModel,
      ];

  QuranMainState copyWith({
    TextEditingController? searchController,
    String? searchText,
    int? selectedTabIndex,
    bool? isLoading,
    QuranMainModel? quranMainModel,
    SurahItemModel? surahModel,
  }) {
    return QuranMainState(
      searchController: searchController ?? this.searchController,
      searchText: searchText ?? this.searchText,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isLoading: isLoading ?? this.isLoading,
      quranMainModel: quranMainModel ?? this.quranMainModel,
      surahModel: surahModel ?? this.surahModel,
    );
  }
}
