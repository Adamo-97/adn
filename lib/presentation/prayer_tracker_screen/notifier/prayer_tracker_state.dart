part of 'prayer_tracker_notifier.dart';

// All card names, including Sunrise
const List<String> kAllPrayerKeys = <String>[
  'Fajr',
  'Sunrise',
  'Dhuhr',
  'Asr',
  'Maghrib',
  'Isha',
];

enum PrayerBellMode { adhan, pling, mute }

class PrayerCardItem {
  final String name;
  final String time;
  final bool isCompleted;
  final bool isCurrent;
  final bool isAfterCurrent;
  const PrayerCardItem({
    required this.name,
    required this.time,
    required this.isCompleted,
    required this.isCurrent,
    required this.isAfterCurrent,
  });
}

class PrayerTrackerState extends Equatable {
  final PrayerTrackerModel? prayerTrackerModel;
  final DateTime selectedDate;
  final DateTime calendarMonth;
  final Map<String, String> dailyTimes;
  final Map<String, bool> completedByPrayer;
  final String currentPrayer;

  /// UI: calendar panel open/closed (hidden by default)
  final bool calendarOpen;

  /// UI: Qibla panel open/closed
  final bool qiblaOpen;

  /// UI: Which stat button is open ('weekly', 'monthly', 'quad', or null)
  final String? openStatButton;

  int get currentIndexInAll => kAllPrayerKeys.indexOf(currentPrayer);

  /// Get the next prayer after the current prayer (single source of truth).
  /// Wraps around to Fajr if current is Isha (last prayer of the day).
  String get nextPrayer {
    final currentIndex = currentIndexInAll;
    if (currentIndex < 0 || currentIndex >= kAllPrayerKeys.length - 1) {
      return kAllPrayerKeys[0]; // Default to Fajr if current is Isha or invalid
    }
    return kAllPrayerKeys[currentIndex + 1];
  }

  /// Get the time for the next prayer from dailyTimes.
  String get nextPrayerTime => dailyTimes[nextPrayer] ?? '00:00';

  final Map<String, PrayerBellMode> bellByPrayer;

  // Track scroll position for reset on navigation/tab switch
  final double scrollPosition;

  // Forces state change on reset so listeners can react
  final int resetTimestamp;

  /// Build the 6 UI rows for the cards (names, times, flags). Single source of truth.
  List<PrayerCardItem> get cardItems {
    final ci = currentIndexInAll;
    return List<PrayerCardItem>.generate(kAllPrayerKeys.length, (i) {
      final name = kAllPrayerKeys[i];
      return PrayerCardItem(
        name: name,
        time: dailyTimes[name] ?? '00:00',
        isCompleted: completedByPrayer[name] ?? false,
        isCurrent: i == ci,
        isAfterCurrent: i > ci,
      );
    });
  }

  PrayerTrackerState({
    this.prayerTrackerModel,
    DateTime? selectedDate,
    DateTime? calendarMonth,
    Map<String, String>? dailyTimes,
    Map<String, bool>? completedByPrayer,
    String? currentPrayer,
    bool? calendarOpen,
    bool? qiblaOpen,
    this.openStatButton,
    Map<String, PrayerBellMode>? bellByPrayer,
    double? scrollPosition,
    int? resetTimestamp,
  })  : selectedDate = DateTime(
          (selectedDate ?? DateTime.now()).year,
          (selectedDate ?? DateTime.now()).month,
          (selectedDate ?? DateTime.now()).day,
        ),
        calendarMonth = calendarMonth ??
            DateTime(
              (selectedDate ?? DateTime.now()).year,
              (selectedDate ?? DateTime.now()).month,
              1,
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
        currentPrayer = currentPrayer ?? 'Asr',
        calendarOpen = calendarOpen ?? false,
        qiblaOpen = qiblaOpen ?? false,
        bellByPrayer = bellByPrayer ??
            const {
              'Fajr': PrayerBellMode.adhan,
              'Sunrise': PrayerBellMode.mute,
              'Dhuhr': PrayerBellMode.pling,
              'Asr': PrayerBellMode.pling,
              'Maghrib': PrayerBellMode.adhan,
              'Isha': PrayerBellMode.pling,
            },
        scrollPosition = scrollPosition ?? 0.0,
        resetTimestamp = resetTimestamp ?? 0;

  List<PrayerActionModel> get prayerActions =>
      prayerTrackerModel?.prayerActions ?? [];
  List<String> get weekDays => prayerTrackerModel?.weekDays ?? [];
  List<PrayerRowModel> get prayerRows => prayerTrackerModel?.prayerRows ?? [];

  // —— Progress bar statuses (unchanged) ——
  List<String> get progressStatusesRaw {
    return List<String>.generate(kOrderedPrayerKeys.length, (i) {
      final key = kOrderedPrayerKeys[i];
      if (completedByPrayer[key] == true) return 'completed';
      if (currentPrayer == key) return 'current';
      return 'upcoming';
    });
  }

  // —— Nav label shown in the date navigation row ——
  String get navLabel {
    String two(int n) => n.toString().padLeft(2, '0');
    const wd = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ]; // 1=Mon..7=Sun
    final now = DateTime.now();
    final isToday = _sameDay(selectedDate, now);
    final d = wd[(selectedDate.weekday - 1) % 7];
    if (isToday) {
      return '$d, ${two(selectedDate.day)}/${two(selectedDate.month)}/${selectedDate.year}';
    }
    return '$d, ${two(selectedDate.day)}/${two(selectedDate.month)}/${selectedDate.year}';
  }

  // Label when calendar is open: Month Year (e.g., September 2025)
  String get monthLabel {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[calendarMonth.month - 1]} ${calendarMonth.year}';
  }

  // —— Hijri Calendar Support ——
  /// Get Hijri-formatted nav label (e.g., "Monday, 15/09/1446")
  String getHijriNavLabel() {
    return HijriCalendarUtils.formatHijriDateWithWeekday(selectedDate);
  }

  /// Get Hijri-formatted month label (e.g., "Ramadan 1446")
  String getHijriMonthLabel() {
    return HijriCalendarUtils.formatHijriMonthYear(calendarMonth);
  }

  /// Get the Hijri day number for a given Gregorian date
  int getHijriDay(DateTime date) {
    final hijriData = HijriCalendarUtils.gregorianToHijri(date);
    return hijriData['day'] as int;
  }

  /// Get the Hijri month number for the calendar month
  int get hijriCalendarMonth {
    final hijriData = HijriCalendarUtils.gregorianToHijri(calendarMonth);
    return hijriData['month'] as int;
  }

  /// Get Hijri month grid (6x7 grid of Gregorian dates for Hijri month view)
  List<List<DateTime>> get hijriMonthWeeks {
    return HijriCalendarUtils.getHijriMonthGrid(calendarMonth);
  }

  // Grid uses the displayed month (calendarMonth) when open
  List<List<DateTime>> get monthWeeks {
    final firstOfMonth = DateTime(calendarMonth.year, calendarMonth.month, 1);
    final start = _calendarGridStart(firstOfMonth);

    // Generate all 6 rows
    final allWeeks = List<List<DateTime>>.generate(6, (r) {
      return List<DateTime>.generate(7, (c) {
        final idx = r * 7 + c;
        // Add days to start date, ensuring we get midnight of each day
        final resultDate = DateTime(
          start.year,
          start.month,
          start.day + idx,
        );
        return resultDate;
      });
    });

    // Check if the last row contains any dates from the current month
    final lastRow = allWeeks.last;
    final hasCurrentMonthDate =
        lastRow.any((date) => date.month == calendarMonth.month);

    // If last row has no dates from current month, exclude it
    if (!hasCurrentMonthDate) {
      return allWeeks.sublist(0, 5);
    }

    return allWeeks;
  }

  // ——— helpers ———
  DateTime _calendarGridStart(DateTime firstOfMonth) {
    // DateTime.weekday: Monday=1, Tuesday=2, ..., Sunday=7
    // We want Sunday=0, Monday=1, ..., Saturday=6
    // Convert: Sunday(7) -> 0, Monday(1) -> 1, Tuesday(2) -> 2, etc.
    final sundayBasedWeekday =
        firstOfMonth.weekday % 7; // Sunday=0, Mon=1, ..., Sat=6
    return firstOfMonth.subtract(Duration(days: sundayBasedWeekday));
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  PrayerTrackerState copyWith({
    PrayerTrackerModel? prayerTrackerModel,
    DateTime? selectedDate,
    DateTime? calendarMonth,
    Map<String, String>? dailyTimes,
    Map<String, bool>? completedByPrayer,
    String? currentPrayer,
    bool? calendarOpen,
    bool? qiblaOpen,
    String? openStatButton,
    bool clearOpenStatButton = false,
    double? scrollPosition,
    int? resetTimestamp,
    Map<String, PrayerBellMode>? bellByPrayer,
  }) {
    return PrayerTrackerState(
      prayerTrackerModel: prayerTrackerModel ?? this.prayerTrackerModel,
      selectedDate: selectedDate ?? this.selectedDate,
      calendarMonth: calendarMonth ?? this.calendarMonth,
      dailyTimes: dailyTimes ?? this.dailyTimes,
      completedByPrayer: completedByPrayer ?? this.completedByPrayer,
      currentPrayer: currentPrayer ?? this.currentPrayer,
      calendarOpen: calendarOpen ?? this.calendarOpen,
      qiblaOpen: qiblaOpen ?? this.qiblaOpen,
      openStatButton:
          clearOpenStatButton ? null : (openStatButton ?? this.openStatButton),
      bellByPrayer: bellByPrayer ?? this.bellByPrayer,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      resetTimestamp: resetTimestamp ?? this.resetTimestamp,
    );
  }

  @override
  List<Object?> get props => [
        prayerTrackerModel,
        selectedDate,
        calendarMonth,
        dailyTimes,
        completedByPrayer,
        currentPrayer,
        calendarOpen,
        qiblaOpen,
        openStatButton,
        bellByPrayer,
        scrollPosition,
        resetTimestamp,
      ];
}
