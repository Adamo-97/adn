import 'package:flutter/material.dart';

import 'package:adam_s_application/core/app_export.dart';
import '../notifier/prayer_tracker_notifier.dart';
import '../models/prayer_tracker_model.dart';
// CustomImageView lives in lib/widgets; from here it's 3 levels up:
import '../../../widgets/custom_image_view.dart';

class DateNavCalendar extends ConsumerWidget {
  const DateNavCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final m = state.prayerTrackerModel ?? PrayerTrackerModel();

    // label text + color depend on open/closed
    final isOpen = state.calendarOpen;
    final labelText = isOpen ? state.monthLabel : state.navLabel;
    final labelColor = isOpen ? appTheme.orange_200 : appTheme.white_A700;

    // 7 equal columns
    final Map<int, TableColumnWidth> cols = {
      for (int i = 0; i < 7; i++) i: const FlexColumnWidth(1),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // === NAV ROW === arrows change day (closed) or month (open); label toggles calendar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                final n = ref.read(prayerTrackerNotifierProvider.notifier);
                isOpen ? n.prevMonth() : n.prevDay();
              },
              child: CustomImageView(
                // if this is an SVG, use svgPath:
                imagePath: ImageConstant.imgArrowPrev,
                height: 24.h,
                width: 24.h,
                color: appTheme.gray_700, // olive tint
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => ref
                  .read(prayerTrackerNotifierProvider.notifier)
                  .toggleCalendar(),
              child: Text(
                labelText,
                style: TextStyleHelper.instance.title18SemiBoldPoppins
                    .copyWith(color: labelColor),
              ),
            ),
            GestureDetector(
              onTap: () {
                final n = ref.read(prayerTrackerNotifierProvider.notifier);
                isOpen ? n.nextMonth() : n.nextDay();
              },
              child: CustomImageView(
                imagePath: ImageConstant.imgArrowNext, // or svgPath
                height: 24.h,
                width: 24.h,
                color: appTheme.gray_700, // olive tint
              ),
            ),
          ],
        ),

        // Spacing between nav row and calendar
        SizedBox(height: 16.h),

        // === CALENDAR (smooth show/hide) ===
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, anim) => SizeTransition(
            sizeFactor: anim,
            axisAlignment: -1.0,
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: !isOpen
              ? const SizedBox.shrink(key: ValueKey('cal-off'))
              : Container(
                  key: const ValueKey('cal-on'),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: appTheme.gray_700.withOpacity(0.3),
                      width: 1.h,
                    ),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header (top rounded)
                      Container(
                        decoration: BoxDecoration(
                          color: appTheme.gray_900,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.h),
                            topRight: Radius.circular(10.h),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 12.h),
                        child: Table(
                          columnWidths: cols,
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              children: List.generate(7, (i) {
                                final day = (i < m.weekDays.length)
                                    ? m.weekDays[i]
                                    : const [
                                        'Su',
                                        'Mo',
                                        'Tu',
                                        'We',
                                        'Th',
                                        'Fr',
                                        'Sa'
                                      ][i];
                                return Center(
                                  child: Text(
                                    day,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyleHelper
                                        .instance.body15RegularPoppins
                                        .copyWith(color: appTheme.orange_200),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),

                      // Divider under header
                      Container(
                        height: 1.h,
                        color: appTheme.gray_700.withOpacity(0.3),
                      ),

                      // Grid rows (bottom rounded) — symmetric 6x7, no empty cells
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.h),
                          bottomRight: Radius.circular(10.h),
                        ),
                        child: Container(
                          color: appTheme.gray_900,
                          padding: EdgeInsets.symmetric(horizontal: 12.h),
                          child: Table(
                            columnWidths: cols,
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children:
                                List.generate(state.monthWeeks.length, (r) {
                              final row = state.monthWeeks[r];

                              // DEBUG: Print entire row for debugging
                              if (r == 4) {
                                debugPrint(
                                    'DEBUG Row 4 dates: ${row.map((d) => '${d.month}/${d.day}').join(', ')}');
                              }

                              return TableRow(
                                children: List.generate(7, (c) {
                                  final date = row[c];
                                  final isSelected =
                                      _sameDay(date, state.selectedDate);
                                  final isOutOfMonth =
                                      date.month != state.calendarMonth.month;

                                  // DEBUG: Print date info for the 26th
                                  if (date.day == 26 && r == 4) {
                                    debugPrint(
                                        'DEBUG Calendar: Row $r, Col $c: ${date.year}/${date.month}/${date.day} '
                                        '| isSelected: $isSelected | selectedDate: ${state.selectedDate} '
                                        '| calendarMonth: ${state.calendarMonth.month}');
                                  }

                                  // color for day number - muted gray for out-of-month
                                  final dayColor = isOutOfMonth
                                      ? appTheme.white_A700.withOpacity(0.25)
                                      : appTheme.white_A700;

                                  final textStyle = TextStyleHelper
                                      .instance.body12SemiBoldPoppins
                                      .copyWith(color: dayColor);

                                  // fixed cell height → symmetric grid
                                  final child = Center(
                                    child: isSelected
                                        ? Container(
                                            width: 38.h,
                                            height: 38.h,
                                            decoration: BoxDecoration(
                                              color: appTheme.orange_200
                                                  .withOpacity(0.15),
                                              border: Border.all(
                                                color: appTheme.orange_200,
                                                width: 1.5.h,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(19.h),
                                            ),
                                            child: Center(
                                              child: Text('${date.day}',
                                                  style: textStyle.copyWith(
                                                    color: appTheme.orange_200,
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                            ),
                                          )
                                        : Text('${date.day}', style: textStyle),
                                  );

                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        final n = ref.read(
                                            prayerTrackerNotifierProvider
                                                .notifier);
                                        n.selectDate(
                                            date); // update selected day
                                        n.setCalendarOpen(
                                            false); // hide calendar after pick
                                      },
                                      child: SizedBox(
                                          height: 40.h,
                                          child: child), // uniform height
                                    ),
                                  );
                                }),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  // local helper (widget)
  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
