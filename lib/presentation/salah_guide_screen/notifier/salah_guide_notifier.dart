import '../../../core/app_export.dart';
import '../models/salah_guide_model.dart';
import '../models/salah_guide_card_model.dart';

part 'salah_guide_state.dart';

final salahGuideNotifier =
    NotifierProvider.autoDispose<SalahGuideNotifier, SalahGuideState>(
  () => SalahGuideNotifier(),
);

class SalahGuideNotifier extends Notifier<SalahGuideState> {
  @override
  SalahGuideState build() {
    final initialState = SalahGuideState(
      salahGuideModel: SalahGuideModel(),
    );
    Future.microtask(() => initialize());
    return initialState;
  }

  void initialize() {
    final cards = [
      // Prayer guide cards from salah_guide_menu_screen (keeping exact titles and icons)
      SalahGuideCardModel(
        title: 'The Importance\nof Prayer',
        iconPath: ImageConstant.imgImportantIcon,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'How To\nPray',
        iconPath: ImageConstant.imgHowToIcon,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Times of\nRequired Prayers',
        iconPath: ImageConstant.imgPrayerTimes,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Conditions\nof Prayer',
        iconPath: ImageConstant.imgConditionsIcon,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),

      // Specific prayer types (keeping exact titles from menu screen)
      SalahGuideCardModel(
        title: 'Istikharah\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder5,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Forgetfulness\nProstration',
        iconPath: ImageConstant.imgIconPlaceholder6,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Rawatib\nPrayers',
        iconPath: ImageConstant.imgIconPlaceholder7,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Prayer\nof the Ill',
        iconPath: ImageConstant.imgIconPlaceholder8,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Witr\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder9,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Tahajjud\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholoder,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Congregational Prayer',
        iconPath: ImageConstant.imgIconPlaceholder10,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Traveling\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder1,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Janazah\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder11,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Kusuf\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder12,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Eid\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder13,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Jumu\'ah\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder14,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
    ];

    state = state.copyWith(
      cards: cards,
      isLoading: false,
    );
  }

  void selectCard(SalahGuideCardModel card) {
    state = state.copyWith(
      selectedCard: card,
    );
  }
}
