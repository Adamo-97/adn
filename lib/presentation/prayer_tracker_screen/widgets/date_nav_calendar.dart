import 'package:flutter/material.dart';

import 'package:adam_s_application/core/app_export.dart';
import '../notifier/prayer_tracker_notifier.dart';
import '../models/prayer_tracker_model.dart';
// Import profile settings to read Hijri calendar preference
import '../../profile_settings_screen/notifier/profile_settings_notifier.dart';
// CustomImageView lives in lib/widgets; from here it's 3 levels up:
import '../../../widgets/custom_image_view.dart';

class DateNavCalendar extends ConsumerWidget {
  const DateNavCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final profileState = ref.watch(profileSettingsNotifier);
    final m = state.prayerTrackerModel ?? PrayerTrackerModel();

    // Check if Hijri calendar is enabled
    final useHijri = profileState.hijriCalendar ?? false;

    // label text + color depend on open/closed
    final isOpen = state.calendarOpen;
    final labelText = isOpen
        ? (useHijri ? state.getHijriMonthLabel() : state.monthLabel)
        : (useHijri ? state.getHijriNavLabel() : state.navLabel);
    final labelColor = isOpen ? appColors.orange_200 : appColors.whiteA700;

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
                color: appColors.gray_700, // olive tint
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
                color: appColors.gray_700, // olive tint
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
                      color: appColors.gray_700.withAlpha((0.3 * 255).round()),
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
                          color: appColors.gray_900,
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
                                        .copyWith(color: appColors.orange_200),
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
                        color:
                            appColors.gray_700.withAlpha((0.3 * 255).round()),
                      ),

                      // Grid rows (bottom rounded) — symmetric 6x7, no empty cells
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.h),
                          bottomRight: Radius.circular(10.h),
                        ),
                        child: Container(
                          color: appColors.gray_900,
                          padding: EdgeInsets.symmetric(horizontal: 12.h),
                          child: Table(
                            columnWidths: cols,
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: List.generate(
                                useHijri
                                    ? state.hijriMonthWeeks.length
                                    : state.monthWeeks.length, (r) {
                              final row = useHijri
                                  ? state.hijriMonthWeeks[r]
                                  : state.monthWeeks[r];

                              // DEBUG row logging removed

                              return TableRow(
                                children: List.generate(7, (c) {
                                  final date = row[c];
                                  final isSelected =
                                      _sameDay(date, state.selectedDate);

                                  // For Hijri mode, check if date is in current Hijri month
                                  // For Gregorian mode, check if date is in current Gregorian month
                                  final isOutOfMonth = useHijri
                                      ? (state.getHijriDay(date) > 0 &&
                                          HijriCalendarUtils.gregorianToHijri(
                                                  date)['month'] !=
                                              state.hijriCalendarMonth)
                                      : date.month != state.calendarMonth.month;

                                  // detailed debug logging removed

                                  // color for day number - muted gray for out-of-month
                                  final dayColor = isOutOfMonth
                                      ? appColors.whiteA700
                                          .withAlpha((0.25 * 255).round())
                                      : appColors.whiteA700;

                                  final textStyle = TextStyleHelper
                                      .instance.body12SemiBoldPoppins
                                      .copyWith(color: dayColor);

                                  // Get the day number to display (Hijri or Gregorian)
                                  final dayNumber = useHijri
                                      ? state.getHijriDay(date)
                                      : date.day;

                                  // fixed cell height → symmetric grid
                                  final child = Center(
                                    child: isSelected
                                        ? Container(
                                            width: 38.h,
                                            height: 38.h,
                                            decoration: BoxDecoration(
                                              color: appColors.orange_200
                                                  .withAlpha(
                                                      (0.15 * 255).round()),
                                              border: Border.all(
                                                color: appColors.orange_200,
                                                width: 1.5.h,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(19.h),
                                            ),
                                            child: Center(
                                              child: Text('$dayNumber',
                                                  style: textStyle.copyWith(
                                                    color: appColors.orange_200,
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                            ),
                                          )
                                        : Text('$dayNumber', style: textStyle),
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
