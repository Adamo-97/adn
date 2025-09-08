import '../../../core/app_export.dart';
import '../models/azkhar_categories_model.dart';
import '../models/azkhar_category_model.dart';

part 'azkhar_categories_state.dart';

final azkharCategoriesNotifier = StateNotifierProvider.autoDispose<
    AzkharCategoriesNotifier, AzkharCategoriesState>(
  (ref) => AzkharCategoriesNotifier(
    AzkharCategoriesState(
      azkharCategoriesModel: AzkharCategoriesModel(),
    ),
  ),
);

class AzkharCategoriesNotifier extends StateNotifier<AzkharCategoriesState> {
  AzkharCategoriesNotifier(AzkharCategoriesState state) : super(state) {
    initialize();
  }

  void initialize() {
    final categories = [
      AzkharCategoryModel(
        title: 'Morning\nAzkar',
        iconPath: ImageConstant.imgSearchWhiteA700,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      AzkharCategoryModel(
        title: 'Upon \nWaking',
        iconPath: ImageConstant.imgIconPlaceholder,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      AzkharCategoryModel(
        title: 'Evening \nAzkar\t',
        iconPath: ImageConstant.imgIconPlaceholderWhiteA700,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      AzkharCategoryModel(
        title: 'After \nPrayer\t',
        iconPath: ImageConstant.imgIconPlaceholderWhiteA70030x30,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      AzkharCategoryModel(
        title: 'Before\nSleep\t',
        iconPath: ImageConstant.imgIconPlaceholder30x30,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      AzkharCategoryModel(
        title: 'Travel\nAzkar\t',
        iconPath: ImageConstant.imgIconPlaceholder1,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      AzkharCategoryModel(
        title: 'Home Entry/Exit\t',
        iconPath: ImageConstant.imgIconPlaceholder2,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      AzkharCategoryModel(
        title: 'Seeking Refuge',
        iconPath: ImageConstant.imgIconPlaceholder3,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      AzkharCategoryModel(
        title: 'Seeking Forgiveness',
        iconPath: ImageConstant.imgIconPlaceholder4,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      AzkharCategoryModel(
        title: 'General \nZikr\t',
        iconPath: ImageConstant.imgIconPplaceholder,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
    ];

    state = state.copyWith(
      categories: categories,
      isLoading: false,
    );
  }

  void selectCategory(AzkharCategoryModel category) {
    state = state.copyWith(
      selectedCategory: category,
    );
  }
}
