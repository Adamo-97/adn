import 'package:hijri/hijri_calendar.dart';

/// Utility class for Hijri (Islamic) calendar operations
/// Provides conversion between Gregorian and Hijri dates
class HijriCalendarUtils {
  /// Convert Gregorian DateTime to Hijri date components
  static Map<String, dynamic> gregorianToHijri(DateTime gregorianDate) {
    final hijri = HijriCalendar.fromDate(gregorianDate);

    return {
      'day': hijri.hDay,
      'month': hijri.hMonth,
      'year': hijri.hYear,
      'monthName': hijri.getLongMonthName(),
      'monthNameShort': _getShortMonthName(hijri.hMonth),
    };
  }

  /// Get Hijri month names (full)
  static List<String> get hijriMonthNames => [
        'Muharram',
        'Safar',
        'Rabi\' al-Awwal',
        'Rabi\' al-Thani',
        'Jumada al-Awwal',
        'Jumada al-Thani',
        'Rajab',
        'Sha\'ban',
        'Ramadan',
        'Shawwal',
        'Dhu al-Qi\'dah',
        'Dhu al-Hijjah',
      ];

  /// Get Hijri month names (short/abbreviated)
  static List<String> get hijriMonthNamesShort => [
        'Muh',
        'Saf',
        'Rab I',
        'Rab II',
        'Jum I',
        'Jum II',
        'Raj',
        'Sha',
        'Ram',
        'Shaw',
        'Dhu-Q',
        'Dhu-H',
      ];

  /// Get short month name from month number (1-12)
  static String _getShortMonthName(int month) {
    if (month < 1 || month > 12) return '';
    return hijriMonthNamesShort[month - 1];
  }

  /// Get Hijri weekday names (same as Gregorian, starting with Monday)
  static List<String> get hijriWeekDays => [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      ];

  /// Format Hijri date as "Day MonthName Year" (e.g., "15 Ramadan 1446")
  static String formatHijriDate(DateTime gregorianDate) {
    final hijriData = gregorianToHijri(gregorianDate);
    return '${hijriData['day']} ${hijriData['monthName']} ${hijriData['year']}';
  }

  /// Format Hijri date as "Weekday, DD/MM/YYYY" (e.g., "Monday, 15/09/1446")
  static String formatHijriDateWithWeekday(DateTime gregorianDate) {
    final hijriData = gregorianToHijri(gregorianDate);
    final weekday = hijriWeekDays[(gregorianDate.weekday - 1) % 7];

    String two(int n) => n.toString().padLeft(2, '0');

    return '$weekday, ${two(hijriData['day'])}/${two(hijriData['month'])}/${hijriData['year']}';
  }

  /// Format Hijri month and year (e.g., "Ramadan 1446")
  static String formatHijriMonthYear(DateTime gregorianDate) {
    final hijriData = gregorianToHijri(gregorianDate);
    return '${hijriData['monthName']} ${hijriData['year']}';
  }

  /// Get the number of days in a Hijri month
  /// Returns 29 or 30 (Hijri months alternate between 29 and 30 days)
  static int getHijriMonthLength(int year, int month) {
    // Hijri calendar months alternate between 29 and 30 days
    // Odd months (1, 3, 5, 7, 9, 11) have 30 days
    // Even months (2, 4, 6, 8, 10) have 29 days
    // The 12th month (Dhu al-Hijjah) has 29 days in regular years and 30 in leap years

    if (month == 12) {
      // Check if it's a leap year (30-year cycle, years 2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29)
      final leapYears = [2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29];
      final yearInCycle = year % 30;
      return leapYears.contains(yearInCycle) ? 30 : 29;
    }

    // Odd months have 30 days, even months have 29 days
    return month % 2 == 1 ? 30 : 29;
  }

  /// Get Hijri calendar grid for a given Gregorian date's corresponding Hijri month
  /// Returns a 5x7 or 6x7 grid of Gregorian dates that map to the Hijri month
  static List<List<DateTime>> getHijriMonthGrid(DateTime referenceDate) {
    final hijri = HijriCalendar.fromDate(referenceDate);
    final hijriYear = hijri.hYear;
    final hijriMonth = hijri.hMonth;

    // Get the first day of the Hijri month in Gregorian
    final firstHijriDay = HijriCalendar()
      ..hYear = hijriYear
      ..hMonth = hijriMonth
      ..hDay = 1;

    final firstDayOfMonth =
        firstHijriDay.hijriToGregorian(hijriYear, hijriMonth, 1);

    // Calculate grid start (Monday of the week containing the 1st)
    final weekday = firstDayOfMonth.weekday; // 1=Mon, 7=Sun
    final gridStart = firstDayOfMonth.subtract(Duration(days: weekday - 1));

    // Build all 6 rows initially
    final grid = <List<DateTime>>[];
    for (int week = 0; week < 6; week++) {
      final row = <DateTime>[];
      for (int day = 0; day < 7; day++) {
        final date = gridStart.add(Duration(days: week * 7 + day));
        row.add(date);
      }
      grid.add(row);
    }

    // Check if the last row contains any dates from the current Hijri month
    if (grid.isNotEmpty) {
      final lastRow = grid.last;
      final hasCurrentMonthDate = lastRow.any((date) {
        final dateHijri = gregorianToHijri(date);
        return dateHijri['month'] == hijriMonth &&
            dateHijri['year'] == hijriYear;
      });

      // If last row has no dates from current Hijri month, exclude it
      if (!hasCurrentMonthDate) {
        return grid.sublist(0, 5);
      }
    }

    return grid;
  }
}
