part of 'prayer_tracker_notifier.dart';

class PrayerTrackerState extends Equatable {
  final PrayerTrackerModel? prayerTrackerModel;
  final bool isLoading;

  const PrayerTrackerState({
    this.prayerTrackerModel,
    this.isLoading = false,
  });

  List<PrayerActionModel> get prayerActions =>
      prayerTrackerModel?.prayerActions ?? [];

  List<String> get weekDays => prayerTrackerModel?.weekDays ?? [];

  List<PrayerRowModel> get prayerRows => prayerTrackerModel?.prayerRows ?? [];

  @override
  List<Object?> get props => [
        prayerTrackerModel,
        isLoading,
      ];

  PrayerTrackerState copyWith({
    PrayerTrackerModel? prayerTrackerModel,
    bool? isLoading,
  }) {
    return PrayerTrackerState(
      prayerTrackerModel: prayerTrackerModel ?? this.prayerTrackerModel,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
