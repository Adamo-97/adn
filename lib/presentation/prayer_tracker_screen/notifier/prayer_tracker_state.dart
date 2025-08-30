part of 'prayer_tracker_notifier.dart';

class PrayerTrackerState extends Equatable {
  final PrayerTrackerModel? prayerTrackerModel;
  /// The currently selected calendar day (date-only).
  final DateTime selectedDate;
  final Map<String,String> dailyTimes;
  /// Completion status per prayer (true => done).
  final Map<String, bool> completedByPrayer;
  /// Which prayer is current/active (highlight green). TODO: compute from real times.
  final String currentPrayer;

  PrayerTrackerState({
    this.prayerTrackerModel,
    DateTime? selectedDate,
    Map<String, String>? dailyTimes,
    Map<String, bool>? completedByPrayer,
    String? currentPrayer,
  })  : selectedDate = DateTime(
           (selectedDate ?? DateTime.now()).year,
           (selectedDate ?? DateTime.now()).month,
           (selectedDate ?? DateTime.now()).day,
        ),
        dailyTimes = dailyTimes ??
            const {
              'Fajr': '00:00',
              'Sunrise': '00:00',
              'Dhuhr': '00:00',
              'Asr': '00:00',
              'Maghrib': '00:00',
              'Isha': '00:00',
            },
        completedByPrayer = completedByPrayer ??
            {
              'Fajr': false,
              'Sunrise': false,
              'Dhuhr': false,
              'Asr': false,
              'Maghrib': false,
              'Isha': false,
            },
        currentPrayer = currentPrayer ?? 'Fajr'; //TODO: compute from real times

  List<PrayerActionModel> get prayerActions =>
      prayerTrackerModel?.prayerActions ?? [];

  List<String> get weekDays => prayerTrackerModel?.weekDays ?? [];

  List<PrayerRowModel> get prayerRows => prayerTrackerModel?.prayerRows ?? [];

  PrayerTrackerState copyWith({
    PrayerTrackerModel? prayerTrackerModel,
    DateTime? selectedDate,
    Map<String, String>? dailyTimes,
    Map<String, bool>? completedByPrayer,
    String? currentPrayer,
  }) {
    return PrayerTrackerState(
      prayerTrackerModel: prayerTrackerModel ?? this.prayerTrackerModel,
      selectedDate: selectedDate ?? this.selectedDate,
      dailyTimes: dailyTimes ?? this.dailyTimes,
      completedByPrayer: completedByPrayer ?? this.completedByPrayer,
      currentPrayer: currentPrayer ?? this.currentPrayer,
    );
  }

  @override
  List<Object?> get props => [
        prayerTrackerModel,
        selectedDate,
        dailyTimes,
        completedByPrayer,
        currentPrayer,
      ];
}
