import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quran_main_model.dart';
import '../models/surah_item_model.dart';
import '../../../core/app_export.dart';

part 'quran_main_state.dart';

final quranMainNotifierProvider =
    NotifierProvider.autoDispose<QuranMainNotifier, QuranMainState>(
  () => QuranMainNotifier(),
);

class QuranMainNotifier extends Notifier<QuranMainState> {
  @override
  QuranMainState build() {
    final initialState = QuranMainState(
      quranMainModel: QuranMainModel(),
      surahModel: SurahItemModel(),
    );
    Future.microtask(() => initialize());
    return initialState;
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

  // Note: In Riverpod 3.x with Notifier, disposal is handled automatically.
  // The searchController will be disposed when the provider is disposed.
}
