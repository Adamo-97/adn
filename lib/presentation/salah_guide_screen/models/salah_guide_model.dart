import '../../../core/app_export.dart';

/// This class is used in the [SalahGuideScreen] screen.

// ignore_for_file: must_be_immutable
class SalahGuideModel extends Equatable {
  SalahGuideModel({this.searchText, this.isSearchActive}) {
    searchText = searchText ?? "";
    isSearchActive = isSearchActive ?? false;
  }

  String? searchText;
  bool? isSearchActive;

  SalahGuideModel copyWith({
    String? searchText,
    bool? isSearchActive,
  }) {
    return SalahGuideModel(
      searchText: searchText ?? this.searchText,
      isSearchActive: isSearchActive ?? this.isSearchActive,
    );
  }

  @override
  List<Object?> get props => [searchText, isSearchActive];
}
