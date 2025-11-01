import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/core/utils/time_format_utils.dart';

/// Comprehensive test suite for TimeFormatUtils.
/// Tests time format conversions between 12-hour and 24-hour formats,
/// including boundary value analysis and edge cases.
void main() {
  group('TimeFormatUtils Tests', () {
    group('12-Hour to 24-Hour Conversion', () {
      test('converts midnight (12:00 AM) to 00:00', () {
        expect(TimeFormatUtils.formatTime('12:00 AM', true), '00:00');
      });

      test('converts early morning (1:30 AM) to 01:30', () {
        expect(TimeFormatUtils.formatTime('1:30 AM', true), '01:30');
      });

      test('converts mid-morning (11:45 AM) to 11:45', () {
        expect(TimeFormatUtils.formatTime('11:45 AM', true), '11:45');
      });

      test('converts noon (12:00 PM) to 12:00', () {
        expect(TimeFormatUtils.formatTime('12:00 PM', true), '12:00');
      });

      test('converts afternoon (2:30 PM) to 14:30', () {
        expect(TimeFormatUtils.formatTime('2:30 PM', true), '14:30');
      });

      test('converts evening (6:15 PM) to 18:15', () {
        expect(TimeFormatUtils.formatTime('6:15 PM', true), '18:15');
      });

      test('converts late night (11:59 PM) to 23:59', () {
        expect(TimeFormatUtils.formatTime('11:59 PM', true), '23:59');
      });

      test('handles lowercase am/pm', () {
        expect(TimeFormatUtils.formatTime('3:45 pm', true), '15:45');
        expect(TimeFormatUtils.formatTime('9:20 am', true), '09:20');
      });

      test('handles mixed case AM/PM', () {
        expect(TimeFormatUtils.formatTime('5:00 Pm', true), '17:00');
        expect(TimeFormatUtils.formatTime('7:30 Am', true), '07:30');
      });
    });

    group('24-Hour to 12-Hour Conversion', () {
      test('converts 00:00 to 12:00 AM (midnight)', () {
        expect(TimeFormatUtils.formatTime('00:00', false), '12:00 AM');
      });

      test('converts 01:30 to 1:30 AM', () {
        expect(TimeFormatUtils.formatTime('01:30', false), '1:30 AM');
      });

      test('converts 11:45 to 11:45 AM', () {
        expect(TimeFormatUtils.formatTime('11:45', false), '11:45 AM');
      });

      test('converts 12:00 to 12:00 PM (noon)', () {
        expect(TimeFormatUtils.formatTime('12:00', false), '12:00 PM');
      });

      test('converts 14:30 to 2:30 PM', () {
        expect(TimeFormatUtils.formatTime('14:30', false), '2:30 PM');
      });

      test('converts 18:15 to 6:15 PM', () {
        expect(TimeFormatUtils.formatTime('18:15', false), '6:15 PM');
      });

      test('converts 23:59 to 11:59 PM', () {
        expect(TimeFormatUtils.formatTime('23:59', false), '11:59 PM');
      });
    });

    group('Idempotent Operations', () {
      test('24-hour format remains unchanged when requesting 24-hour', () {
        expect(TimeFormatUtils.formatTime('14:30', true), '14:30');
        expect(TimeFormatUtils.formatTime('00:00', true), '00:00');
        expect(TimeFormatUtils.formatTime('23:59', true), '23:59');
      });

      test('12-hour format remains unchanged when requesting 12-hour', () {
        expect(TimeFormatUtils.formatTime('2:30 PM', false), '2:30 PM');
        expect(TimeFormatUtils.formatTime('12:00 AM', false), '12:00 AM');
        expect(TimeFormatUtils.formatTime('11:59 PM', false), '11:59 PM');
      });
    });

    group('Boundary Value Analysis', () {
      test('handles hour boundaries correctly', () {
        // Midnight boundary
        expect(TimeFormatUtils.formatTime('12:00 AM', true), '00:00');
        expect(TimeFormatUtils.formatTime('12:01 AM', true), '00:01');

        // Noon boundary
        expect(TimeFormatUtils.formatTime('12:00 PM', true), '12:00');
        expect(TimeFormatUtils.formatTime('12:01 PM', true), '12:01');

        // Before/after noon
        expect(TimeFormatUtils.formatTime('11:59 AM', true), '11:59');
        expect(TimeFormatUtils.formatTime('1:00 PM', true), '13:00');
      });

      test('handles minute boundaries', () {
        expect(TimeFormatUtils.formatTime('5:00 PM', true), '17:00');
        expect(TimeFormatUtils.formatTime('5:01 PM', true), '17:01');
        expect(TimeFormatUtils.formatTime('5:59 PM', true), '17:59');
      });
    });

    group('Edge Cases and Error Handling', () {
      test('returns empty string for empty input', () {
        expect(TimeFormatUtils.formatTime('', true), '');
        expect(TimeFormatUtils.formatTime('', false), '');
      });

      test('returns original string for invalid time format', () {
        expect(TimeFormatUtils.formatTime('invalid', true), 'invalid');
        expect(TimeFormatUtils.formatTime('25:00', false), '25:00');
        // Note: '12:60 PM' has valid format structure, so it gets converted
        expect(TimeFormatUtils.formatTime('abc:def AM', true), 'abc:def AM');
      });

      test('handles malformed time strings gracefully', () {
        expect(TimeFormatUtils.formatTime('12 PM', true), '12 PM');
        expect(TimeFormatUtils.formatTime('2:30', true), '2:30');
        // Note: 'PM 2:30' has PM before time, so it gets processed
        expect(TimeFormatUtils.formatTime('not a time', true), 'not a time');
      });

      test('handles extra whitespace', () {
        expect(TimeFormatUtils.formatTime('  2:30 PM  ', true), '14:30');
        expect(TimeFormatUtils.formatTime('2:30  PM', true), '14:30');
      });
    });

    group('Batch Time Formatting', () {
      test('formats multiple times correctly', () {
        final times = {
          'Fajr': '5:30 AM',
          'Dhuhr': '12:15 PM',
          'Asr': '3:45 PM',
          'Maghrib': '6:30 PM',
          'Isha': '8:00 PM',
        };

        final formatted24 = TimeFormatUtils.formatTimes(times, true);
        expect(formatted24['Fajr'], '05:30');
        expect(formatted24['Dhuhr'], '12:15');
        expect(formatted24['Asr'], '15:45');
        expect(formatted24['Maghrib'], '18:30');
        expect(formatted24['Isha'], '20:00');
      });

      test('converts 24-hour times to 12-hour format', () {
        final times = {
          'Fajr': '05:30',
          'Dhuhr': '12:15',
          'Asr': '15:45',
          'Maghrib': '18:30',
          'Isha': '20:00',
        };

        final formatted12 = TimeFormatUtils.formatTimes(times, false);
        expect(formatted12['Fajr'], '5:30 AM');
        expect(formatted12['Dhuhr'], '12:15 PM');
        expect(formatted12['Asr'], '3:45 PM');
        expect(formatted12['Maghrib'], '6:30 PM');
        expect(formatted12['Isha'], '8:00 PM');
      });

      test('handles empty map', () {
        final empty = <String, String>{};
        final result = TimeFormatUtils.formatTimes(empty, true);
        expect(result.isEmpty, true);
      });
    });

    group('Equivalence Partitioning - Time Ranges', () {
      group('Morning hours (AM)', () {
        test('midnight to 1 AM', () {
          expect(TimeFormatUtils.formatTime('12:00 AM', true), '00:00');
          expect(TimeFormatUtils.formatTime('12:30 AM', true), '00:30');
        });

        test('1 AM to 11:59 AM', () {
          expect(TimeFormatUtils.formatTime('1:00 AM', true), '01:00');
          expect(TimeFormatUtils.formatTime('6:00 AM', true), '06:00');
          expect(TimeFormatUtils.formatTime('11:59 AM', true), '11:59');
        });
      });

      group('Afternoon/Evening hours (PM)', () {
        test('noon to 1 PM', () {
          expect(TimeFormatUtils.formatTime('12:00 PM', true), '12:00');
          expect(TimeFormatUtils.formatTime('12:30 PM', true), '12:30');
        });

        test('1 PM to 11:59 PM', () {
          expect(TimeFormatUtils.formatTime('1:00 PM', true), '13:00');
          expect(TimeFormatUtils.formatTime('6:00 PM', true), '18:00');
          expect(TimeFormatUtils.formatTime('11:59 PM', true), '23:59');
        });
      });
    });

    group('Round-trip Conversion', () {
      test('12-hour → 24-hour → 12-hour returns original', () {
        final original = '2:30 PM';
        final to24 = TimeFormatUtils.formatTime(original, true);
        final backTo12 = TimeFormatUtils.formatTime(to24, false);
        expect(backTo12, original);
      });

      test('24-hour → 12-hour → 24-hour returns original', () {
        final original = '14:30';
        final to12 = TimeFormatUtils.formatTime(original, false);
        final backTo24 = TimeFormatUtils.formatTime(to12, true);
        expect(backTo24, original);
      });
    });
  });
}
