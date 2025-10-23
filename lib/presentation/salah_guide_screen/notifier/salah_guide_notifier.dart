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
      SalahGuideCardModel(
        title: 'Wudu',
        iconPath: ImageConstant.imgSearchWhiteA700,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Ghusl',
        iconPath: ImageConstant.imgIconPlaceholder,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'How to Pray',
        iconPath: ImageConstant.imgIconPlaceholderWhiteA700,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Tayammum',
        iconPath: ImageConstant.imgIconPlaceholderWhiteA70030x30,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Prayer Times',
        iconPath: ImageConstant.imgIconPlaceholder30x30,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Qibla Direction',
        iconPath: ImageConstant.imgIconPlaceholder1,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Prayer Rulings',
        iconPath: ImageConstant.imgIconPlaceholder2,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Sujood Types',
        iconPath: ImageConstant.imgIconPlaceholder3,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Missed Prayers',
        iconPath: ImageConstant.imgIconPlaceholder4,
        backgroundColor: appTheme.gray_700,
        borderColor: appTheme.gray_500,
      ),
      SalahGuideCardModel(
        title: 'Friday Prayer',
        iconPath: ImageConstant.imgIconPplaceholder,
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
