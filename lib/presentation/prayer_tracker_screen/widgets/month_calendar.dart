import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/prayer_tracker_model.dart';
import '../notifier/prayer_tracker_notifier.dart';

class MonthCalendar extends ConsumerWidget {
  const MonthCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final m = state.prayerTrackerModel ?? PrayerTrackerModel();

    // 7 equal columns
    final Map<int, TableColumnWidth> cols = {
      for (int i = 0; i < 7; i++) i: const FlexColumnWidth(1),
    };

    // Build a matrix of DateTime? for the current month (Sunday-first)
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final weeks = _buildMonthMatrix(monthStart, monthEnd); // List<List<DateTime?>>

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header (top rounded)
        Container(
          decoration: BoxDecoration(
            color: appTheme.gray_700,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.h),
              topRight: Radius.circular(10.h),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
          child: Row(
            children: [
              Text(
                'Calendar',
                style: TextStyleHelper.instance.title18SemiBoldPoppins
                    .copyWith(color: appTheme.orange_200),
              ),
              const Spacer(),
              CustomImageView(
                imagePath: ImageConstant.imgArrowNext,
                height: 24.h,
                width: 24.h,
              ),
            ],
          ),
        ),

        // Weekday row
        Container(
          color: appTheme.gray_900_01,
          padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
          child: Table(
            columnWidths: cols,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: List.generate(7, (i) {
                  final day = (m.weekDays != null && i < m.weekDays!.length)
                      ? m.weekDays![i]
                      : const ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'][i];
                  return Center(
                    child: Text(
                      day,
                      style: TextStyleHelper.instance.body12RegularPoppins
                          .copyWith(color: appTheme.white_A700.withOpacity(.5)),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        // Table body (bottom rounded)
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.h),
            bottomRight: Radius.circular(10.h),
          ),
          child: Container(
            color: appTheme.gray_900_01,
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: Table(
              columnWidths: cols,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: List.generate(weeks.length, (r) {
                final row = weeks[r];
                return TableRow(
                  children: List.generate(7, (c) {
                    final date = row[c];
                    if (date == null) return SizedBox(height: 40.h);

                    final isToday = _isSameDay(date, now);
                    final isPast =
                        date.isBefore(DateTime(now.year, now.month, now.day));

                    final textStyle = TextStyleHelper.instance.label10LightPoppins.copyWith(
                      color: isPast ? appTheme.gray_600 : appTheme.white_A700,
                    );

                    final inner = Center(
                      child: isToday
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: appTheme.gray_700,
                                borderRadius: BorderRadius.circular(10.h),
                              ),
                              child: Text('${date.day}', style: textStyle),
                            )
                          : Text('${date.day}', style: textStyle),
                    );

                    return SizedBox(height: 40.h, child: inner);
                  }),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a month matrix (weeks × 7) starting on Sunday. Cells outside month are null.
  List<List<DateTime?>> _buildMonthMatrix(DateTime monthStart, DateTime monthEnd) {
    int sundayBasedIndex(int weekday) => weekday % 7; // 1..7 -> 1..6,0

    final firstCol = sundayBasedIndex(monthStart.weekday);
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

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
