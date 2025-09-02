
import '../../../core/app_export.dart';
import '../models/prayer_tracker_model.dart';

part 'prayer_tracker_state.dart';

const List<String> kOrderedPrayerKeys = <String>[
  'Fajr','Dhuhr','Asr','Maghrib','Isha',
];

final prayerTrackerNotifierProvider = StateNotifierProvider.autoDispose<
    PrayerTrackerNotifier, PrayerTrackerState>(
  (ref) => PrayerTrackerNotifier(
    PrayerTrackerState(
      prayerTrackerModel: PrayerTrackerModel(),
    ),
  ),
);

class PrayerTrackerNotifier extends StateNotifier<PrayerTrackerState> {
  PrayerTrackerNotifier(PrayerTrackerState state) : super(state) {
    initialize();
  }

  static const List<String> _prayers = [
    'Fajr','Sunrise','Dhuhr','Asr','Maghrib','Isha',
  ];

  int _indexOf(String name) => _prayers.indexOf(name);

  void initialize() {
    List<PrayerActionModel> prayerActions = [
      PrayerActionModel(
        icon: ImageConstant.imgQiblaButton,
        label: 'Qibla',
      ),
      PrayerActionModel(
        icon: ImageConstant.imgWhuduGroup,
        label: 'Purification',
        navigateTo: '576:475',
      ),
      PrayerActionModel(
        icon: ImageConstant.imgHowToPrayGroup,
        label: 'Salah Guide',
        navigateTo: '508:307',
      ),
      PrayerActionModel(
        icon: ImageConstant.imgAfterPrayGroup,
        label: 'Rituals',
      ),
    ];

    List<String> weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    List<PrayerRowModel> prayerRows = [
      PrayerRowModel(
        values: ['0', '0', '0', '0', '0', '0', '0'],
        isFirstRow: true,
      ),
      PrayerRowModel(
        values: ['0', '0', '0', '0', '0', '0', '0'],
      ),
      PrayerRowModel(
        values: ['0', '0', '0', '0', '0', '0', '0'],
      ),
      PrayerRowModel(
        values: ['0', '0', '0', '0', '0', '0', '0'],
        isLastRow: true,
      ),
    ];

    state = state.copyWith(
      prayerTrackerModel: PrayerTrackerModel(
        prayerActions: prayerActions,
        weekDays: weekDays,
        prayerRows: prayerRows,
      ),
    );

    fetchDailyTimes(state.selectedDate);
    // TODO: compute currentPrayer from real times; for now, keep default or pick from dailyTimes
    // state = state.copyWith(currentPrayer: _computeCurrentPrayerFromTimes(state.dailyTimes, state.selectedDate));

  }

  /// Fetch daily times for [date]. Currently a placeholder returning "00:00".
  /// TODO: Replace with real API call and map into the 6 prayer keys.
  Future<void> fetchDailyTimes(DateTime date) async {
    // TODO: after real API: recompute currentPrayer
    // state = state.copyWith(currentPrayer: _computeCurrentPrayerFromTimes(times, date));
    // Example shape (replace with actual API integration):
    // final result = await api.getPrayerTimes(lat, lng, date, method: ...);
    // final times = {
    //   'Fajr': result.fajr,
    //   'Sunrise': result.sunrise,
    //   'Dhuhr': result.dhuhr,
    //   'Asr': result.asr,
    //   'Maghrib': result.maghrib,
    //   'Isha': result.isha,
    // };
    final Map<String, String> times = {
      for (final p in _prayers) p: '00:00',
    };
    state = state.copyWith(dailyTimes: times);
  }

  /// Set the selected calendar day (date-only).
  void selectDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    state = state.copyWith(
      selectedDate: d,
      calendarMonth: DateTime(d.year, d.month, 1), // ensure month view matches
      calendarOpen: false, // close calendar after pick
    );
    // Kick off fetching times for the newly selected day (placeholder today).
    fetchDailyTimes(d); // TODO: implement with real API
  }

  /// Toggle done/undone for a prayer card.
  void togglePrayerCompleted(String name) {
    final currentIdx = _indexOf(state.currentPrayer);
    final targetIdx = _indexOf(name);

  if(targetIdx <0 || currentIdx <0 || targetIdx > currentIdx) return; // cannot mark future prayers

    final updated = Map<String, bool>.from(state.completedByPrayer);
    final current = updated[name] ?? false;
    updated[name] = !current;
    state = state.copyWith(completedByPrayer: updated);
    // TODO: persist locally (and sync) if needed.
  }

  void selectPrayerAction(PrayerActionModel action) {
    List<PrayerActionModel> updatedActions = state.prayerActions.map((item) {
      if (item.id == action.id) {
        return item.copyWith(isSelected: !(item.isSelected ?? false));
      }
      return item;
    }).toList();

    state = state.copyWith(
      prayerTrackerModel: state.prayerTrackerModel?.copyWith(
        prayerActions: updatedActions,
      ),
    );
  }

  /// Toggle calendar panel visibility
  void toggleCalendar() {
    final opening = !state.calendarOpen;
    if (opening) {
      final s = state.selectedDate;
      state = state.copyWith(
        calendarOpen: true,
        calendarMonth: DateTime(s.year, s.month, 1),
      );
    } else {
      state = state.copyWith(calendarOpen: false);
    }
  }

  void setCalendarOpen(bool open) {
    if (state.calendarOpen == open) return;
    state = state.copyWith(calendarOpen: open);
  }

  // Day navigation (used when calendar is CLOSED)
  void prevDay() => selectDate(state.selectedDate.subtract(const Duration(days: 1)));
  void nextDay() => selectDate(state.selectedDate.add(const Duration(days: 1)));

  // Month navigation (used when calendar is OPEN)
  // Keeps the day-of-month if possible, clamps to last day of month if needed.
  void prevMonth() => _shiftMonth(-1);
  void nextMonth() => _shiftMonth(1);

  void _shiftMonth(int delta) {
    final cm = state.calendarMonth;
    // Move the DISPLAYED month; do NOT change selectedDate here.
    final newMonth = DateTime(cm.year, cm.month + delta, 1); // DateTime handles year rollover
    state = state.copyWith(calendarMonth: newMonth);
  }

}

