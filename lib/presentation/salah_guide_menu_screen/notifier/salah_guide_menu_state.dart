part of 'salah_guide_menu_notifier.dart';

class SalahGuideMenuState extends Equatable {
  final SalahGuideMenuModel? salahGuideMenuModel;
  final List<PrayerGuideItemModel>? prayerGuideItems;
  final List<PrayerTypeModel>? prayerTypes;
  final PrayerGuideItemModel? selectedGuideItem;
  final PrayerTypeModel? selectedPrayerType;

  const SalahGuideMenuState({
    this.salahGuideMenuModel,
    this.prayerGuideItems,
    this.prayerTypes,
    this.selectedGuideItem,
    this.selectedPrayerType,
  });

  @override
  List<Object?> get props => [
        salahGuideMenuModel,
        prayerGuideItems,
        prayerTypes,
        selectedGuideItem,
        selectedPrayerType,
      ];

  SalahGuideMenuState copyWith({
    SalahGuideMenuModel? salahGuideMenuModel,
    List<PrayerGuideItemModel>? prayerGuideItems,
    List<PrayerTypeModel>? prayerTypes,
    PrayerGuideItemModel? selectedGuideItem,
    PrayerTypeModel? selectedPrayerType,
  }) {
    return SalahGuideMenuState(
      salahGuideMenuModel: salahGuideMenuModel ?? this.salahGuideMenuModel,
      prayerGuideItems: prayerGuideItems ?? this.prayerGuideItems,
      prayerTypes: prayerTypes ?? this.prayerTypes,
      selectedGuideItem: selectedGuideItem ?? this.selectedGuideItem,
      selectedPrayerType: selectedPrayerType ?? this.selectedPrayerType,
    );
  }
}
