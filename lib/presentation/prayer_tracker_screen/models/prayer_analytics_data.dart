import 'package:equatable/equatable.dart';

/// Model representing a single day's prayer data
class DailyPrayerData extends Equatable {
  final DateTime date;
  final int completedPrayers; // 0-5
  final bool isFuture;

  /// Map of prayer name to completion status
  /// Keys: 'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'
  final Map<String, bool> prayerStatuses;

  const DailyPrayerData({
    required this.date,
    required this.completedPrayers,
    this.isFuture = false,
    Map<String, bool>? prayerStatuses,
  }) : prayerStatuses = prayerStatuses ?? const {};

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Get list of prayer names that were completed
  List<String> get completedPrayerNames {
    return prayerStatuses.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get list of prayer names that were missed
  List<String> get missedPrayerNames {
    return prayerStatuses.entries
        .where((entry) => entry.value == false)
        .map((entry) => entry.key)
        .toList();
  }

  @override
  List<Object?> get props => [date, completedPrayers, isFuture, prayerStatuses];
}

/// Model representing weekly prayer statistics
class WeeklyPrayerStats extends Equatable {
  final DateTime weekStart;
  final DateTime weekEnd;
  final List<DailyPrayerData> dailyData; // 7 days
  final int totalCompleted;
  final int totalPossible; // 35 (7 days × 5 prayers)
  final double completionRate; // 0.0 - 1.0

  const WeeklyPrayerStats({
    required this.weekStart,
    required this.weekEnd,
    required this.dailyData,
    required this.totalCompleted,
    required this.totalPossible,
    required this.completionRate,
  });

  String get dateRange =>
      '${weekStart.day}/${weekStart.month} - ${weekEnd.day}/${weekEnd.month}';

  @override
  List<Object?> get props => [
        weekStart,
        weekEnd,
        dailyData,
        totalCompleted,
        totalPossible,
        completionRate,
      ];
}

/// Model representing monthly prayer statistics
class MonthlyPrayerStats extends Equatable {
  final DateTime monthStart;
  final DateTime monthEnd;
  final List<DailyPrayerData> dailyData;
  final List<WeeklyPrayerStats> weeklyData;
  final int totalCompleted;
  final int totalPossible;
  final double completionRate;
  final int activeDays; // Days with at least 1 prayer

  const MonthlyPrayerStats({
    required this.monthStart,
    required this.monthEnd,
    required this.dailyData,
    required this.weeklyData,
    required this.totalCompleted,
    required this.totalPossible,
    required this.completionRate,
    required this.activeDays,
  });

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
    return '${months[monthStart.month - 1]} ${monthStart.year}';
  }

  @override
  List<Object?> get props => [
        monthStart,
        monthEnd,
        dailyData,
        weeklyData,
        totalCompleted,
        totalPossible,
        completionRate,
        activeDays,
      ];
}

/// Model representing quarterly prayer statistics
class QuarterlyPrayerStats extends Equatable {
  final DateTime quarterStart;
  final DateTime quarterEnd;
  final int quarterNumber; // 1-4
  final List<DailyPrayerData> dailyData;
  final List<WeeklyPrayerStats> weeklyData; // ~13 weeks
  final List<MonthlyPrayerStats> monthlyData; // 3 months
  final int totalCompleted;
  final int totalPossible;
  final double completionRate;

  const QuarterlyPrayerStats({
    required this.quarterStart,
    required this.quarterEnd,
    required this.quarterNumber,
    required this.dailyData,
    required this.weeklyData,
    required this.monthlyData,
    required this.totalCompleted,
    required this.totalPossible,
    required this.completionRate,
  });

  String get quarterLabel {
    const quarterMonths = {
      1: 'Jan - Mar',
      2: 'Apr - Jun',
      3: 'Jul - Sep',
      4: 'Oct - Dec',
    };
    return 'Q$quarterNumber ${quarterStart.year} (${quarterMonths[quarterNumber]})';
  }

  @override
  List<Object?> get props => [
        quarterStart,
        quarterEnd,
        quarterNumber,
        dailyData,
        weeklyData,
        monthlyData,
        totalCompleted,
        totalPossible,
        completionRate,
      ];
}

/// Comprehensive analytics data for all time periods
class PrayerAnalyticsData extends Equatable {
  final WeeklyPrayerStats currentWeek;
  final MonthlyPrayerStats currentMonth;
  final QuarterlyPrayerStats currentQuarter;

  // Historical data for comparisons
  final WeeklyPrayerStats? previousWeek;
  final MonthlyPrayerStats? previousMonth;
  final QuarterlyPrayerStats? previousQuarter;

  // Year-to-date statistics
  final int yearTotalCompleted;
  final int yearTotalPossible;
  final double yearCompletionRate;
  final int currentStreak; // Days in a row with all 5 prayers
  final int bestStreak; // Best streak this year

  const PrayerAnalyticsData({
    required this.currentWeek,
    required this.currentMonth,
    required this.currentQuarter,
    this.previousWeek,
    this.previousMonth,
    this.previousQuarter,
    required this.yearTotalCompleted,
    required this.yearTotalPossible,
    required this.yearCompletionRate,
    required this.currentStreak,
    required this.bestStreak,
  });

  @override
  List<Object?> get props => [
        currentWeek,
        currentMonth,
        currentQuarter,
        previousWeek,
        previousMonth,
        previousQuarter,
        yearTotalCompleted,
        yearTotalPossible,
        yearCompletionRate,
        currentStreak,
        bestStreak,
      ];
}
