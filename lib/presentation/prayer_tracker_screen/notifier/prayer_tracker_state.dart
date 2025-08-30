part of 'prayer_tracker_notifier.dart';

class PrayerTrackerState extends Equatable {
  final PrayerTrackerModel? prayerTrackerModel;
  /// The currently selected calendar day (date-only).
  final DateTime selectedDate;

  PrayerTrackerState({
    this.prayerTrackerModel,
    DateTime? selectedDate,
  }) : selectedDate = DateTime(
          (selectedDate ?? DateTime.now()).year,
          (selectedDate ?? DateTime.now()).month,
          (selectedDate ?? DateTime.now()).day,
        );

  List<PrayerActionModel> get prayerActions =>
      prayerTrackerModel?.prayerActions ?? [];

  List<String> get weekDays => prayerTrackerModel?.weekDays ?? [];

  List<PrayerRowModel> get prayerRows => prayerTrackerModel?.prayerRows ?? [];

  PrayerTrackerState copyWith({
    PrayerTrackerModel? prayerTrackerModel,
    DateTime? selectedDate,
  }) {
    return PrayerTrackerState(
      prayerTrackerModel: prayerTrackerModel ?? this.prayerTrackerModel,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [
        prayerTrackerModel,
        selectedDate,
      ];
}
