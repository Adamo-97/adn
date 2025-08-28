import '../../../core/app_export.dart';

/// This class is used in the [quran_main_screen] screen.

// ignore_for_file: must_be_immutable
class QuranMainModel extends Equatable {
  QuranMainModel({
    this.searchText,
    this.selectedTabIndex,
    this.id,
  }) {
    searchText = searchText ?? '';
    selectedTabIndex = selectedTabIndex ?? 0;
    id = id ?? '';
  }

  String? searchText;
  int? selectedTabIndex;
  String? id;

  QuranMainModel copyWith({
    String? searchText,
    int? selectedTabIndex,
    String? id,
  }) {
    return QuranMainModel(
      searchText: searchText ?? this.searchText,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
        searchText,
        selectedTabIndex,
        id,
      ];
}
