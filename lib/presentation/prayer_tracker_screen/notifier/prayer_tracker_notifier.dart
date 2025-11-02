import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/prayer_tracker_model.dart';
import '../../../services/prayer_times/prayer_times.dart';
import '../../profile_settings_screen/notifier/profile_settings_notifier.dart';

part 'prayer_tracker_state.dart';

const List<String> kOrderedPrayerKeys = <String>[
  'Fajr',
  'Dhuhr',
  'Asr',
  'Maghrib',
  'Isha',
];

// Riverpod 3.x: Using NotifierProvider with manual Notifier subclass
final prayerTrackerNotifierProvider =
    NotifierProvider.autoDispose<PrayerTrackerNotifier, PrayerTrackerState>(
  () => PrayerTrackerNotifier(),
);

class PrayerTrackerNotifier extends Notifier<PrayerTrackerState> {
  @override
  PrayerTrackerState build() {
    // Initialize state
    final initialState = PrayerTrackerState(
      prayerTrackerModel: PrayerTrackerModel(),
    );

    // Schedule initialization to run after build
    Future.microtask(() => initialize());

    return initialState;
  }

  static const List<String> _prayers = [
    'Fajr',
    'Sunrise',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  int _indexOf(String name) => _prayers.indexOf(name);

  void initialize() {
    List<PrayerActionModel> prayerActions = [
      PrayerActionModel(
        icon: ImageConstant.imgQiblaButton,
        label: 'Qibla',
        id: 'qibla',
      ),
      PrayerActionModel(
        icon: ImageConstant.imgWeeklyStat,
        label: 'Weekly',
        id: 'weekly_stats',
      ),
      PrayerActionModel(
        icon: ImageConstant.imgMonthlyStat,
        label: 'Monthly',
        id: 'monthly_stats',
      ),
      PrayerActionModel(
        icon: ImageConstant.imgQuadStat,
        label: 'Quarterly',
        id: 'quad_stats',
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

  /// Fetch daily prayer times for [date] using the API and caching service
  ///
  /// This method:
  /// 1. Retrieves user's location and calculation settings from profile settings
  /// 2. Calls the prayer times service (which handles caching automatically)
  /// 3. Updates state with fetched times
  /// 4. Computes current prayer based on fetched times
  ///
  /// The service ensures API is called only once per day (or when settings change).
  Future<void> fetchDailyTimes(DateTime date) async {
    try {
      // Get prayer times service
      final prayerTimesService = ref.read(prayerTimesServiceProvider);

      // Get user's settings from profile settings
      final profileSettings = ref.read(profileSettingsNotifier);
      final selectedLocation =
          profileSettings.selectedLocation ?? 'Stockholm, Sweden';

      // Parse location (format: "City, Country")
      final locationParts =
          selectedLocation.split(',').map((s) => s.trim()).toList();
      final city = locationParts.isNotEmpty ? locationParts[0] : 'Stockholm';
      final country = locationParts.length > 1 ? locationParts[1] : 'Sweden';

      // Get calculation settings
      final calculationMethod = profileSettings.selectedCalculationMethod;
      final islamicSchool = profileSettings.selectedIslamicSchool;

      // Fetch prayer times (service handles caching automatically)
      final result = await prayerTimesService.getPrayerTimes(
        city: city,
        country: country,
        date: date,
        calculationMethod: calculationMethod,
        school: islamicSchool,
      );

      if (result.isSuccess && result.data != null) {
        // Success - update state with fetched times
        final times = result.data!.toUiMap();
        state = state.copyWith(dailyTimes: times);

        // Compute current prayer based on real times
        _updateCurrentPrayer();
      } else {
        // Error - keep placeholder times and log error
        // ignore: avoid_print
        print('Failed to fetch prayer times: ${result.error}');

        // Fall back to placeholder times
        final Map<String, String> times = {
          for (final p in _prayers) p: '00:00',
        };
        state = state.copyWith(dailyTimes: times);
      }
    } catch (e) {
      // Catch-all error handler
      // ignore: avoid_print
      print('Exception in fetchDailyTimes: $e');

      // Fall back to placeholder times
      final Map<String, String> times = {
        for (final p in _prayers) p: '00:00',
      };
      state = state.copyWith(dailyTimes: times);
    }
  }

  /// Compute and update the current prayer based on current time and daily times
  ///
  /// Logic:
  /// - Before Fajr: Current is "Isha" (previous day's last prayer)
  /// - Between prayers: Current is the most recent past prayer
  /// - After Isha: Current is "Isha"
  void _updateCurrentPrayer() {
    try {
      final now = DateTime.now();
      final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

      // Convert prayer times to TimeOfDay for comparison
      final prayerTimes = <String, TimeOfDay>{};
      for (final entry in state.dailyTimes.entries) {
        final timeParts = entry.value.split(':');
        if (timeParts.length == 2) {
          final hour = int.tryParse(timeParts[0]) ?? 0;
          final minute = int.tryParse(timeParts[1]) ?? 0;
          prayerTimes[entry.key] = TimeOfDay(hour: hour, minute: minute);
        }
      }

      // Find current prayer (the most recent prayer that has passed)
      String currentPrayer = 'Fajr'; // Default

      for (final prayerName in kOrderedPrayerKeys.reversed) {
        final prayerTime = prayerTimes[prayerName];
        if (prayerTime != null && _isTimeBefore(prayerTime, currentTime)) {
          currentPrayer = prayerName;
          break;
        }
      }

      state = state.copyWith(currentPrayer: currentPrayer);
    } catch (e) {
      // If computation fails, keep current state
      // ignore: avoid_print
      print('Failed to compute current prayer: $e');
    }
  }

  /// Compare two TimeOfDay objects (returns true if time1 <= time2)
  bool _isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) return true;
    if (time1.hour > time2.hour) return false;
    return time1.minute <= time2.minute;
  }

  /// Set the selected calendar day (date-only) and fetch prayer times for that date
  void selectDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    state = state.copyWith(
      selectedDate: d,
      calendarMonth: DateTime(d.year, d.month, 1), // ensure month view matches
      calendarOpen: false, // close calendar after pick
    );
    // Fetch prayer times for the newly selected day
    fetchDailyTimes(d);
  }

  /// Toggle done/undone for a prayer card.
  void togglePrayerCompleted(String name) {
    final currentIdx = _indexOf(state.currentPrayer);
    final targetIdx = _indexOf(name);

    if (targetIdx < 0 || currentIdx < 0 || targetIdx > currentIdx) {
      return; // cannot mark future prayers
    }

    final updated = Map<String, bool>.from(state.completedByPrayer);
    final current = updated[name] ?? false;
    updated[name] = !current;
    state = state.copyWith(completedByPrayer: updated);
    // TODO: persist locally (and sync) if needed.
  }

  void selectPrayerAction(PrayerActionModel action) {
    List<PrayerActionModel> updatedActions = state.prayerActions.map((item) {
      if (item.id == action.id) {
        return item.copyWith(isSelected: !item.isSelected);
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
  void prevDay() =>
      selectDate(state.selectedDate.subtract(const Duration(days: 1)));
  void nextDay() => selectDate(state.selectedDate.add(const Duration(days: 1)));

  // Month navigation (used when calendar is OPEN)
  // Keeps the day-of-month if possible, clamps to last day of month if needed.
  void prevMonth() => _shiftMonth(-1);
  void nextMonth() => _shiftMonth(1);

  void _shiftMonth(int delta) {
    final cm = state.calendarMonth;
    // Move the DISPLAYED month; do NOT change selectedDate here.
    final newMonth = DateTime(
        cm.year, cm.month + delta, 1); // DateTime handles year rollover
    state = state.copyWith(calendarMonth: newMonth);
  }

  PrayerBellMode bellFor(String prayerId) {
    return state.bellByPrayer[prayerId] ?? PrayerBellMode.adhan;
  }

  void cycleBell(String prayerId) {
    final current = bellFor(prayerId);
    final next = switch (current) {
      PrayerBellMode.adhan => PrayerBellMode.pling,
      PrayerBellMode.pling => PrayerBellMode.mute,
      PrayerBellMode.mute => PrayerBellMode.adhan,
    };
    final nextMap = Map<String, PrayerBellMode>.from(state.bellByPrayer)
      ..[prayerId] = next;
    state = state.copyWith(bellByPrayer: nextMap);
  }

  void toggleQibla() {
    state = state.copyWith(
      qiblaOpen: !state.qiblaOpen,
      clearOpenStatButton: true, // Close any open stat buttons
    );
  }

  void toggleStatButton(String buttonId) {
    // If this button is already open, close it; otherwise open it
    final newValue = state.openStatButton == buttonId ? null : buttonId;
    state = state.copyWith(
      qiblaOpen: false, // Close Qibla
      clearOpenStatButton: newValue == null,
      openStatButton: newValue,
    );
  }

  void resetState() {
    state = state.copyWith(
      calendarOpen: false,
      qiblaOpen: false,
      clearOpenStatButton: true,
      selectedDate: DateTime.now(),
      // reset scroll info so UI can react and move scroll to top
      scrollPosition: 0.0,
      resetTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
