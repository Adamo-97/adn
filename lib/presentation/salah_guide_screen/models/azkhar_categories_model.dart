import '../../../core/app_export.dart';

/// This class is used in the [AzkharCategoriesScreen] screen.

// ignore_for_file: must_be_immutable
class AzkharCategoriesModel extends Equatable {
  AzkharCategoriesModel({this.searchText, this.isSearchActive}) {
    searchText = searchText ?? "";
    isSearchActive = isSearchActive ?? false;
  }

  String? searchText;
  bool? isSearchActive;

  AzkharCategoriesModel copyWith({
    String? searchText,
    bool? isSearchActive,
  }) {
    return AzkharCategoriesModel(
      searchText: searchText ?? this.searchText,
      isSearchActive: isSearchActive ?? this.isSearchActive,
    );
  }

  @override
  List<Object?> get props => [searchText, isSearchActive];
}
