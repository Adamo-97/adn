 part of 'prayer_tracker_notifier.dart';

// All card names, including Sunrise 
const List<String> kAllPrayerKeys = <String>[
  'Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha',
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
   final Map<String,String> dailyTimes;
   final Map<String, bool> completedByPrayer;
   final String currentPrayer;
  /// UI: calendar panel open/closed (hidden by default)
  final bool calendarOpen;

  int get currentIndexInAll => kAllPrayerKeys.indexOf(currentPrayer);

  final Map<String, PrayerBellMode> bellByPrayer;

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
    Map<String, PrayerBellMode>? bellByPrayer,
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
         dailyTimes = dailyTimes ?? const {
           'Fajr': '00:00',
           'Sunrise': '00:00',
           'Dhuhr': '00:00',
           'Asr': '00:00',
           'Maghrib': '00:00',
           'Isha': '00:00',
         },
         completedByPrayer = completedByPrayer ?? {
           'Fajr': false,
           'Sunrise': false,
           'Dhuhr': false,
           'Asr': false,
           'Maghrib': false,
           'Isha': false,
         },
        currentPrayer = currentPrayer ?? 'Asr',
        calendarOpen = calendarOpen ?? false,
        bellByPrayer = bellByPrayer ?? const {
          'Fajr': PrayerBellMode.adhan,
          'Sunrise': PrayerBellMode.mute,
          'Dhuhr': PrayerBellMode.pling,
          'Asr': PrayerBellMode.pling,
          'Maghrib': PrayerBellMode.adhan,
          'Isha': PrayerBellMode.pling,
        };

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
    const wd = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']; // 1=Mon..7=Sun
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
      'January','February','March','April','May','June',
      'July','August','September','October','November','December'
    ];
    return '${months[calendarMonth.month - 1]} ${calendarMonth.year}';
  }

  // Grid uses the displayed month (calendarMonth) when open
  List<List<DateTime>> get monthWeeks {
    final firstOfMonth = DateTime(calendarMonth.year, calendarMonth.month, 1);
    final start = _calendarGridStart(firstOfMonth);
    final daysInMonth = DateTime(firstOfMonth.year, firstOfMonth.month + 1, 0).day;
    final offset = firstOfMonth.weekday % 7;
    final totalCells = offset + daysInMonth;
    final rows = ((totalCells + 6) ~/ 7).clamp(4, 6);

    return List<List<DateTime>>.generate(rows, (r) {
      return List<DateTime>.generate(7, (c) {
        final idx = r * 7 + c;
        final d = start.add(Duration(days: idx));
        return DateTime(d.year, d.month, d.day);
      });
    });
  }

   // ——— helpers ———
  DateTime _calendarGridStart(DateTime firstOfMonth) {
    final sundayIndex = firstOfMonth.weekday % 7; // 0..6
    return firstOfMonth.subtract(Duration(days: sundayIndex));
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
       bellByPrayer: bellByPrayer ?? this.bellByPrayer,
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
     bellByPrayer,
   ];
 }
