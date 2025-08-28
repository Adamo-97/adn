import 'package:flutter/material.dart';
import '../models/quran_main_model.dart';
import '../models/surah_item_model.dart';
import '../../../core/app_export.dart';

part 'quran_main_state.dart';

final quranMainNotifierProvider =
    StateNotifierProvider.autoDispose<QuranMainNotifier, QuranMainState>(
  (ref) => QuranMainNotifier(
    QuranMainState(
      quranMainModel: QuranMainModel(),
      surahModel: SurahItemModel(),
    ),
  ),
);

class QuranMainNotifier extends StateNotifier<QuranMainState> {
  QuranMainNotifier(QuranMainState state) : super(state) {
    initialize();
  }

  void initialize() {
    state = state.copyWith(
      searchController: TextEditingController(),
      selectedTabIndex: 0,
      surahModel: SurahItemModel(
        surahNumber: '1',
        surahName: 'Al-Fatiha',
        arabicName: '',
        isSelected: true,
      ),
    );
  }

  void updateSearchText(String searchText) {
    state = state.copyWith(searchText: searchText);
  }

  void selectTab(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  void selectSurah(SurahItemModel surah) {
    state = state.copyWith(surahModel: surah);
  }

  @override
  void dispose() {
    state.searchController?.dispose();
    super.dispose();
  }
}
