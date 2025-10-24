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
    final categorizedCards = <SalahCategory, List<SalahGuideCardModel>>{
      // Essentials Category
      SalahCategory.essentials: [
        SalahGuideCardModel(
          title: 'Importance of Prayer',
          iconPath: ImageConstant.imgImportantIcon,
          category: SalahCategory.essentials,
        ),
        SalahGuideCardModel(
          title: 'How To Pray',
          iconPath: ImageConstant.imgHowToIcon,
          category: SalahCategory.essentials,
        ),
        SalahGuideCardModel(
          title: 'Prayer Times',
          iconPath: ImageConstant.imgPrayerTimes,
          category: SalahCategory.essentials,
        ),
        SalahGuideCardModel(
          title: 'Conditions of Prayer',
          iconPath: ImageConstant.imgConditionsIcon,
          category: SalahCategory.essentials,
        ),
      ],

      // Optional Prayers Category
      SalahCategory.optionalPrayers: [
        SalahGuideCardModel(
          title: 'Rawatib Prayers',
          iconPath: ImageConstant.imgIconPlaceholder7,
          category: SalahCategory.optionalPrayers,
        ),
        SalahGuideCardModel(
          title: 'Witr Prayer',
          iconPath: ImageConstant.imgIconPlaceholder9,
          category: SalahCategory.optionalPrayers,
        ),
        SalahGuideCardModel(
          title: 'Tahajjud Prayer',
          iconPath: ImageConstant.imgIconPlaceholoder,
          category: SalahCategory.optionalPrayers,
        ),
        SalahGuideCardModel(
          title: 'Istikharah Prayer',
          iconPath: ImageConstant.imgIconPlaceholder5,
          category: SalahCategory.optionalPrayers,
        ),
      ],

      // Special Situations Category
      SalahCategory.specialSituations: [
        SalahGuideCardModel(
          title: 'Traveling Prayer',
          iconPath: ImageConstant.imgIconPlaceholder11,
          category: SalahCategory.specialSituations,
        ),
        SalahGuideCardModel(
          title: 'Prayer of the Ill',
          iconPath: ImageConstant.imgIconPlaceholder8,
          category: SalahCategory.specialSituations,
        ),
        SalahGuideCardModel(
          title: 'Janazah Prayer',
          iconPath: ImageConstant.imgIconPlaceholder12,
          category: SalahCategory.specialSituations,
        ),
        SalahGuideCardModel(
          title: 'Congregational Prayer',
          iconPath: ImageConstant.imgIconPlaceholder10,
          category: SalahCategory.specialSituations,
        ),
        SalahGuideCardModel(
          title: 'Forgetfulness Prostration',
          iconPath: ImageConstant.imgIconPlaceholder6,
          category: SalahCategory.specialSituations,
        ),
        SalahGuideCardModel(
          title: 'Eid Prayer',
          iconPath: ImageConstant.imgIconPlaceholder13,
          category: SalahCategory.specialSituations,
        ),
        SalahGuideCardModel(
          title: 'Jumu\'ah Prayer',
          iconPath: ImageConstant.imgIconPlaceholder14,
          category: SalahCategory.specialSituations,
        ),
      ],

      // Purification Category
      SalahCategory.purification: [
        SalahGuideCardModel(
          title: 'Wudu (Ablution)',
          iconPath: ImageConstant.imgWuduIcon,
          category: SalahCategory.purification,
        ),
        SalahGuideCardModel(
          title: 'Ghusl (Full Bath)',
          iconPath: ImageConstant.imgGhuslIcon,
          category: SalahCategory.purification,
        ),
        SalahGuideCardModel(
          title: 'Tayammum',
          iconPath: ImageConstant.imgTayammumIcon,
          category: SalahCategory.purification,
        ),
      ],
    };

    state = state.copyWith(
      categorizedCards: categorizedCards,
      isLoading: false,
    );
  }

  void selectCard(SalahGuideCardModel card) {
    state = state.copyWith(
      selectedCard: card,
    );
  }
}
