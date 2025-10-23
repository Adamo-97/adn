import '../../../core/app_export.dart';
import '../models/salah_guide_menu_model.dart';

part 'salah_guide_menu_state.dart';

final salahGuideMenuNotifier = NotifierProvider.autoDispose<
    SalahGuideMenuNotifier, SalahGuideMenuState>(
  () => SalahGuideMenuNotifier(),
);

class SalahGuideMenuNotifier extends Notifier<SalahGuideMenuState> {
  @override
  SalahGuideMenuState build() {
    final initialState = SalahGuideMenuState(
      salahGuideMenuModel: SalahGuideMenuModel(),
    );
    Future.microtask(() => initialize());
    return initialState;
  }

  void initialize() {
    final prayerGuideItems = [
      PrayerGuideItemModel(
        iconPath: ImageConstant.imgImportantIcon,
        title: 'The Importance',
        subtitle: 'of Prayer',
      ),
      PrayerGuideItemModel(
        iconPath: ImageConstant.imgHowToIcon,
        title: 'How To',
        subtitle: 'Pray',
      ),
      PrayerGuideItemModel(
        iconPath: ImageConstant.imgPrayerTimes,
        title: 'Times of',
        subtitle: 'Required Prayers',
      ),
      PrayerGuideItemModel(
        iconPath: ImageConstant.imgConditionsIcon,
        title: 'Conditions',
        subtitle: 'of Prayer',
      ),
    ];

    final prayerTypes = [
      PrayerTypeModel(
        title: 'Istikharah\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder5,
      ),
      PrayerTypeModel(
        title: 'Forgetfulness\nProstration',
        iconPath: ImageConstant.imgIconPlaceholder6,
      ),
      PrayerTypeModel(
        title: 'Rawatib\nPrayers',
        iconPath: ImageConstant.imgIconPlaceholder7,
      ),
      PrayerTypeModel(
        title: 'Prayer\nof the Ill',
        iconPath: ImageConstant.imgIconPlaceholder8,
      ),
      PrayerTypeModel(
        title: 'Witr\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder9,
      ),
      PrayerTypeModel(
        title: 'Tahajjud\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholoder,
      ),
      PrayerTypeModel(
        title: 'Congregational Prayer',
        iconPath: ImageConstant.imgIconPlaceholder10,
      ),
      PrayerTypeModel(
        title: 'Traveling\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder1,
      ),
      PrayerTypeModel(
        title: 'Janazah\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder11,
      ),
      PrayerTypeModel(
        title: 'Kusuf\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder12,
      ),
      PrayerTypeModel(
        title: 'Eid\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder13,
      ),
      PrayerTypeModel(
        title: 'Jumu\'ah\nPrayer',
        iconPath: ImageConstant.imgIconPlaceholder14,
      ),
    ];

    state = state.copyWith(
      prayerGuideItems: prayerGuideItems,
      prayerTypes: prayerTypes,
    );
  }

  void selectGuideItem(PrayerGuideItemModel item) {
    state = state.copyWith(selectedGuideItem: item);
  }

  void selectPrayerType(PrayerTypeModel prayerType) {
    state = state.copyWith(selectedPrayerType: prayerType);
  }
}
