part of 'azkhar_categories_notifier.dart';

class AzkharCategoriesState extends Equatable {
  final List<AzkharCategoryModel>? categories;
  final AzkharCategoryModel? selectedCategory;
  final bool isLoading;
  final AzkharCategoriesModel? azkharCategoriesModel;

  AzkharCategoriesState({
    this.categories,
    this.selectedCategory,
    this.isLoading = false,
    this.azkharCategoriesModel,
  });

  @override
  List<Object?> get props => [
        categories,
        selectedCategory,
        isLoading,
        azkharCategoriesModel,
      ];

  AzkharCategoriesState copyWith({
    List<AzkharCategoryModel>? categories,
    AzkharCategoryModel? selectedCategory,
    bool? isLoading,
    AzkharCategoriesModel? azkharCategoriesModel,
  }) {
    return AzkharCategoriesState(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      azkharCategoriesModel:
          azkharCategoriesModel ?? this.azkharCategoriesModel,
    );
  }
}
