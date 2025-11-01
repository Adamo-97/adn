/// Utility class for formatting time strings based on user preferences.
/// Provides conversion between 12-hour (AM/PM) and 24-hour time formats.
class TimeFormatUtils {
  /// Formats a time string based on the user's preference for 24-hour format.
  ///
  /// Converts between 12-hour format (e.g., "2:30 PM", "11:45 AM") and
  /// 24-hour format (e.g., "14:30", "11:45").
  ///
  /// [timeString] - The time string to format (supports both formats)
  /// [use24Hour] - If true, returns 24-hour format; if false, returns 12-hour format with AM/PM
  ///
  /// Returns the formatted time string. If input is invalid, returns the original string.
  static String formatTime(String timeString, bool use24Hour) {
    if (timeString.isEmpty) return timeString;

    try {
      // Check if time string contains AM/PM (12-hour format)
      final has12HourFormat = timeString.toUpperCase().contains('AM') ||
          timeString.toUpperCase().contains('PM');

      if (use24Hour) {
        // Convert to 24-hour format
        if (has12HourFormat) {
          return _convert12To24Hour(timeString);
        }
        // Already in 24-hour format
        return timeString;
      } else {
        // Convert to 12-hour format
        if (!has12HourFormat) {
          return _convert24To12Hour(timeString);
        }
        // Already in 12-hour format
        return timeString;
      }
    } catch (e) {
      // If parsing fails, return original string
      return timeString;
    }
  }

  /// Converts 12-hour format time (e.g., "2:30 PM") to 24-hour format (e.g., "14:30")
  static String _convert12To24Hour(String time12) {
    // Remove extra spaces and convert to uppercase
    final cleaned = time12.trim().toUpperCase();
    final isPM = cleaned.contains('PM');
    final isAM = cleaned.contains('AM');

    if (!isPM && !isAM) return time12;

    // Extract time part (remove AM/PM)
    final timePart = cleaned.replaceAll(RegExp(r'\s*(AM|PM)'), '').trim();
    final parts = timePart.split(':');

    if (parts.length != 2) return time12;

    final hourValue = int.tryParse(parts[0]);
    final minuteValue = int.tryParse(parts[1]);

    // Validate parsed values
    if (hourValue == null || minuteValue == null) return time12;
    if (hourValue < 1 || hourValue > 12) return time12;
    if (minuteValue < 0 || minuteValue > 59) return time12;

    int hour = hourValue;
    final minute = parts[1];

    // Convert to 24-hour format
    if (isPM && hour != 12) {
      hour += 12;
    } else if (isAM && hour == 12) {
      hour = 0;
    }

    return '${hour.toString().padLeft(2, '0')}:$minute';
  }

  /// Converts 24-hour format time (e.g., "14:30") to 12-hour format (e.g., "2:30 PM")
  static String _convert24To12Hour(String time24) {
    final parts = time24.trim().split(':');
    if (parts.length != 2) return time24;

    final hourValue = int.tryParse(parts[0]);
    final minuteValue = int.tryParse(parts[1]);

    // Validate parsed values
    if (hourValue == null || minuteValue == null) return time24;
    if (hourValue < 0 || hourValue > 23) return time24;
    if (minuteValue < 0 || minuteValue > 59) return time24;

    int hour = hourValue;
    final minute = parts[1];

    final isPM = hour >= 12;
    final period = isPM ? 'PM' : 'AM';

    // Convert to 12-hour format
    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    return '$hour:$minute $period';
  }

  /// Batch converts multiple time strings to the specified format.
  ///
  /// Useful for converting all prayer times at once.
  static Map<String, String> formatTimes(
      Map<String, String> times, bool use24Hour) {
    return times
        .map((key, value) => MapEntry(key, formatTime(value, use24Hour)));
  }
}
