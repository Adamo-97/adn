 part of 'prayer_tracker_notifier.dart';

 class PrayerTrackerState extends Equatable {
   final PrayerTrackerModel? prayerTrackerModel;
   final DateTime selectedDate;
   final Map<String,String> dailyTimes;
   final Map<String, bool> completedByPrayer;
   final String currentPrayer;
  /// UI: calendar panel open/closed (hidden by default)
  final bool calendarOpen;

   PrayerTrackerState({
     this.prayerTrackerModel,
     DateTime? selectedDate,
     Map<String, String>? dailyTimes,
     Map<String, bool>? completedByPrayer,
     String? currentPrayer,
    bool? calendarOpen,
   })  : selectedDate = DateTime(
            (selectedDate ?? DateTime.now()).year,
            (selectedDate ?? DateTime.now()).month,
            (selectedDate ?? DateTime.now()).day,
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
        calendarOpen = calendarOpen ?? false;

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

   // —— Month grid (weeks × 7), Sunday-first; cells outside month are null ——
   List<List<DateTime?>> get monthWeeks {
     final start = DateTime(selectedDate.year, selectedDate.month, 1);
     final end   = DateTime(selectedDate.year, selectedDate.month + 1, 0);
     return _buildMonthMatrix(start, end);
   }

   // ——— helpers ———
   bool _sameDay(DateTime a, DateTime b) =>
       a.year == b.year && a.month == b.month && a.day == b.day;

   List<List<DateTime?>> _buildMonthMatrix(DateTime monthStart, DateTime monthEnd) {
     int sundayIndex(int weekday) => weekday % 7; // Dart: 1=Mon..7=Sun → 0=Sun
     final firstCol = sundayIndex(monthStart.weekday);
     final totalDays = monthEnd.day;

     final cells = <DateTime?>[];
     for (int i = 0; i < firstCol; i++) cells.add(null);
     for (int d = 1; d <= totalDays; d++) {
       cells.add(DateTime(monthStart.year, monthStart.month, d));
     }
     while (cells.length % 7 != 0) cells.add(null);

     final rows = <List<DateTime?>>[];
     for (int i = 0; i < cells.length; i += 7) {
       rows.add(cells.sublist(i, i + 7));
     }
     return rows;
   }

   PrayerTrackerState copyWith({
     PrayerTrackerModel? prayerTrackerModel,
     DateTime? selectedDate,
     Map<String, String>? dailyTimes,
     Map<String, bool>? completedByPrayer,
     String? currentPrayer,
    bool? calendarOpen,
  }) {
     return PrayerTrackerState(
       prayerTrackerModel: prayerTrackerModel ?? this.prayerTrackerModel,
       selectedDate: selectedDate ?? this.selectedDate,
       dailyTimes: dailyTimes ?? this.dailyTimes,
       completedByPrayer: completedByPrayer ?? this.completedByPrayer,
       currentPrayer: currentPrayer ?? this.currentPrayer,
       calendarOpen: calendarOpen ?? this.calendarOpen,
     );
   }

   @override
   List<Object?> get props => [
     prayerTrackerModel,
     selectedDate,
     dailyTimes,
     completedByPrayer,
     currentPrayer,
     calendarOpen,
   ];
 }
