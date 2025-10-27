import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adam_s_application/presentation/prayer_tracker_screen/models/prayer_analytics_data.dart';

/// Provider for prayer analytics data - single source of truth
/// Not using autoDispose because this is a global data source used across multiple screens
final prayerAnalyticsProvider =
    NotifierProvider<PrayerAnalyticsNotifier, PrayerAnalyticsData?>(
        () => PrayerAnalyticsNotifier());

class PrayerAnalyticsNotifier extends Notifier<PrayerAnalyticsData?> {
  @override
  PrayerAnalyticsData? build() {
    // Initialize with null, then load data
    Future.microtask(() => _loadAnalyticsData());
    return null;
  }

  /// Loads and calculates all analytics data
  Future<void> _loadAnalyticsData() async {
    try {
      // TODO: Replace with actual data fetching from backend/database
      final data = await _generateMockData();
      // Check if provider is still mounted before updating state
      if (ref.mounted) {
        state = data;
      }
    } catch (error) {
      // On error, keep current state or set to null
      if (ref.mounted) {
        state = null;
      }
    }
  }

  /// Refreshes analytics data (call after prayer completion)
  Future<void> refresh() async {
    await _loadAnalyticsData();
  }

  /// Gets data for a specific week offset (0 = current, -1 = previous, etc.)
  WeeklyPrayerStats getWeekData(int weekOffset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentWeekStart = today.subtract(Duration(days: today.weekday % 7));
    final weekStart = currentWeekStart.add(Duration(days: weekOffset * 7));
    final weekEnd = weekStart.add(const Duration(days: 6));

    // Generate daily data for this week
    final dailyData = List.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      final isFuture = date.isAfter(today);
      final completed = _getMockPrayerCount(date, isFuture);

      return DailyPrayerData(
        date: date,
        completedPrayers: completed,
        isFuture: isFuture,
      );
    });

    final totalCompleted = dailyData.fold<int>(
      0,
      (sum, day) => sum + day.completedPrayers,
    );
    const totalPossible = 35; // 7 days × 5 prayers
    final completionRate = totalCompleted / totalPossible;

    return WeeklyPrayerStats(
      weekStart: weekStart,
      weekEnd: weekEnd,
      dailyData: dailyData,
      totalCompleted: totalCompleted,
      totalPossible: totalPossible,
      completionRate: completionRate,
    );
  }

  /// Gets data for a specific month offset (0 = current, -1 = previous, etc.)
  MonthlyPrayerStats getMonthData(int monthOffset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetMonth = DateTime(now.year, now.month + monthOffset, 1);
    final monthEnd = DateTime(targetMonth.year, targetMonth.month + 1, 0);

    // Generate daily data for this month
    final dailyData = <DailyPrayerData>[];
    for (int day = 1; day <= monthEnd.day; day++) {
      final date = DateTime(targetMonth.year, targetMonth.month, day);
      final isFuture = date.isAfter(today);
      final completed = _getMockPrayerCount(date, isFuture);

      dailyData.add(DailyPrayerData(
        date: date,
        completedPrayers: completed,
        isFuture: isFuture,
      ));
    }

    // Generate weekly data for this month
    final weeklyData = <WeeklyPrayerStats>[];
    DateTime currentWeekStart = targetMonth.subtract(
      Duration(days: targetMonth.weekday % 7),
    );

    while (currentWeekStart.isBefore(monthEnd) ||
        currentWeekStart.isAtSameMomentAs(monthEnd)) {
      final weekEnd = currentWeekStart.add(const Duration(days: 6));
      final weekDailyData = <DailyPrayerData>[];

      for (int i = 0; i < 7; i++) {
        final date = currentWeekStart.add(Duration(days: i));
        if (date.month == targetMonth.month) {
          final isFuture = date.isAfter(today);
          final completed = _getMockPrayerCount(date, isFuture);
          weekDailyData.add(DailyPrayerData(
            date: date,
            completedPrayers: completed,
            isFuture: isFuture,
          ));
        }
      }

      if (weekDailyData.isNotEmpty) {
        final weekCompleted = weekDailyData.fold<int>(
          0,
          (sum, day) => sum + day.completedPrayers,
        );
        final weekPossible = weekDailyData.length * 5;

        weeklyData.add(WeeklyPrayerStats(
          weekStart: currentWeekStart,
          weekEnd: weekEnd,
          dailyData: weekDailyData,
          totalCompleted: weekCompleted,
          totalPossible: weekPossible,
          completionRate: weekCompleted / weekPossible,
        ));
      }

      currentWeekStart = currentWeekStart.add(const Duration(days: 7));
      if (weeklyData.length >= 6) break; // Max 6 weeks
    }

    final totalCompleted = dailyData.fold<int>(
      0,
      (sum, day) => sum + day.completedPrayers,
    );
    final totalPossible = dailyData.length * 5;
    final completionRate = totalCompleted / totalPossible;
    final activeDays =
        dailyData.where((day) => day.completedPrayers > 0).length;

    return MonthlyPrayerStats(
      monthStart: targetMonth,
      monthEnd: monthEnd,
      dailyData: dailyData,
      weeklyData: weeklyData,
      totalCompleted: totalCompleted,
      totalPossible: totalPossible,
      completionRate: completionRate,
      activeDays: activeDays,
    );
  }

  /// Gets data for a specific quarter offset (0 = current, -1 = previous, etc.)
  QuarterlyPrayerStats getQuarterData(int quarterOffset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentQuarter = ((now.month - 1) ~/ 3) + 1;
    final targetQuarter = currentQuarter + quarterOffset;

    // Calculate actual quarter and year
    int year = now.year;
    int quarter = targetQuarter;

    while (quarter < 1) {
      quarter += 4;
      year -= 1;
    }
    while (quarter > 4) {
      quarter -= 4;
      year += 1;
    }

    // Calculate quarter start and end dates
    final quarterStartMonth = ((quarter - 1) * 3) + 1;
    final quarterStart = DateTime(year, quarterStartMonth, 1);
    final quarterEnd = DateTime(year, quarterStartMonth + 3, 0);

    // Generate daily data for this quarter
    final dailyData = <DailyPrayerData>[];
    DateTime currentDate = quarterStart;
    while (currentDate.isBefore(quarterEnd) ||
        currentDate.isAtSameMomentAs(quarterEnd)) {
      final isFuture = currentDate.isAfter(today);
      final completed = _getMockPrayerCount(currentDate, isFuture);

      dailyData.add(DailyPrayerData(
        date: currentDate,
        completedPrayers: completed,
        isFuture: isFuture,
      ));

      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Generate monthly data for this quarter
    final monthlyData = <MonthlyPrayerStats>[];
    for (int monthOffset = 0; monthOffset < 3; monthOffset++) {
      final month = DateTime(year, quarterStartMonth + monthOffset, 1);
      final monthData = getMonthData(
        (month.year - now.year) * 12 + month.month - now.month,
      );
      monthlyData.add(monthData);
    }

    // Generate weekly data (~13 weeks)
    final weeklyData = <WeeklyPrayerStats>[];
    DateTime currentWeekStart = quarterStart.subtract(
      Duration(days: quarterStart.weekday % 7),
    );

    while (currentWeekStart.isBefore(quarterEnd)) {
      final weekEnd = currentWeekStart.add(const Duration(days: 6));
      final weekDailyData = <DailyPrayerData>[];

      for (int i = 0; i < 7; i++) {
        final date = currentWeekStart.add(Duration(days: i));
        if ((date.isAfter(quarterStart) ||
                date.isAtSameMomentAs(quarterStart)) &&
            date.isBefore(quarterEnd.add(const Duration(days: 1)))) {
          final isFuture = date.isAfter(today);
          final completed = _getMockPrayerCount(date, isFuture);
          weekDailyData.add(DailyPrayerData(
            date: date,
            completedPrayers: completed,
            isFuture: isFuture,
          ));
        }
      }

      if (weekDailyData.isNotEmpty) {
        final weekCompleted = weekDailyData.fold<int>(
          0,
          (sum, day) => sum + day.completedPrayers,
        );
        final weekPossible = weekDailyData.length * 5;

        weeklyData.add(WeeklyPrayerStats(
          weekStart: currentWeekStart,
          weekEnd: weekEnd,
          dailyData: weekDailyData,
          totalCompleted: weekCompleted,
          totalPossible: weekPossible,
          completionRate: weekCompleted / weekPossible,
        ));
      }

      currentWeekStart = currentWeekStart.add(const Duration(days: 7));
    }

    final totalCompleted = dailyData.fold<int>(
      0,
      (sum, day) => sum + day.completedPrayers,
    );
    final totalPossible = dailyData.length * 5;
    final completionRate = totalCompleted / totalPossible;

    return QuarterlyPrayerStats(
      quarterStart: quarterStart,
      quarterEnd: quarterEnd,
      quarterNumber: quarter,
      dailyData: dailyData,
      weeklyData: weeklyData,
      monthlyData: monthlyData,
      totalCompleted: totalCompleted,
      totalPossible: totalPossible,
      completionRate: completionRate,
    );
  }

  /// Mock data generator - TODO: Replace with actual data from backend
  int _getMockPrayerCount(DateTime date, bool isFuture) {
    if (isFuture) return 0;
    // Generate consistent mock data based on date
    return (3 + (date.day % 3)).clamp(0, 5);
  }

  /// Generates mock comprehensive analytics data
  Future<PrayerAnalyticsData> _generateMockData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final currentWeek = getWeekData(0);
    final currentMonth = getMonthData(0);
    final currentQuarter = getQuarterData(0);

    final previousWeek = getWeekData(-1);
    final previousMonth = getMonthData(-1);
    final previousQuarter = getQuarterData(-1);

    // Calculate year-to-date statistics
    final now = DateTime.now();
    final yearStart = DateTime(now.year, 1, 1);
    final today = DateTime(now.year, now.month, now.day);

    int yearTotal = 0;
    int yearPossible = 0;
    DateTime currentDate = yearStart;

    while (currentDate.isBefore(today) || currentDate.isAtSameMomentAs(today)) {
      final completed = _getMockPrayerCount(currentDate, false);
      yearTotal += completed;
      yearPossible += 5;
      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Calculate streaks
    int currentStreak = 0;
    int bestStreak = 0;
    int tempStreak = 0;

    currentDate = today;
    while (currentDate.isAfter(yearStart) ||
        currentDate.isAtSameMomentAs(yearStart)) {
      final completed = _getMockPrayerCount(currentDate, false);
      if (completed == 5) {
        tempStreak++;
        if (currentDate.isAtSameMomentAs(today)) {
          currentStreak = tempStreak;
        }
        if (tempStreak > bestStreak) {
          bestStreak = tempStreak;
        }
      } else {
        tempStreak = 0;
      }
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    return PrayerAnalyticsData(
      currentWeek: currentWeek,
      currentMonth: currentMonth,
      currentQuarter: currentQuarter,
      previousWeek: previousWeek,
      previousMonth: previousMonth,
      previousQuarter: previousQuarter,
      yearTotalCompleted: yearTotal,
      yearTotalPossible: yearPossible,
      yearCompletionRate: yearTotal / yearPossible,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
    );
  }
}
