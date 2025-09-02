import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final now = DateTime.now();

    // 7 equal columns
    final Map<int, TableColumnWidth> cols = {
      for (int i = 0; i < 7; i++) i: const FlexColumnWidth(1),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Date navigation row — arrows change day; label toggles calendar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => ref.read(prayerTrackerNotifierProvider.notifier).prevDay(),
              child: CustomImageView(
                imagePath: ImageConstant.imgArrowPrev, // if this is an SVG, use svgPath:
                height: 24.h,
                width: 24.h,
                color: appTheme.gray_700, // olive tint
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => ref.read(prayerTrackerNotifierProvider.notifier).toggleCalendar(),
              child: Text(
                state.navLabel, // single source of truth from state
                style: TextStyleHelper.instance.title18SemiBoldPoppins
                    .copyWith(color: appTheme.orange_200),
              ),
            ),
            GestureDetector(
              onTap: () => ref.read(prayerTrackerNotifierProvider.notifier).nextDay(),
              child: CustomImageView(
                imagePath: ImageConstant.imgArrowNext, // if SVG, use svgPath:
                height: 24.h,
                width: 24.h,
                color: appTheme.gray_700, // olive tint
              ),
            ),
          ],
        ),
        // Smooth show/hide calendar (hidden by default)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, anim) => SizeTransition(
            sizeFactor: anim,
            axisAlignment: -1.0,
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: !state.calendarOpen
              ? const SizedBox.shrink(key: ValueKey('cal-off'))
              : Column(
                  key: const ValueKey('cal-on'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16.h),

                    // Header (top rounded)
                    Container(
                      decoration: BoxDecoration(
                        color: appTheme.gray_700,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.h),
                          topRight: Radius.circular(10.h),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.h),
                      child: Table(
                        columnWidths: cols,
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: List.generate(7, (i) {
                              final day = (m.weekDays != null && i < m.weekDays!.length)
                                  ? m.weekDays![i]
                                  : const ['Su','Mo','Tu','We','Th','Fr','Sa'][i];
                              return Center(
                                child: Text(
                                  day,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyleHelper.instance.body15RegularPoppins
                                      .copyWith(color: appTheme.orange_200),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    // Grid rows (bottom rounded), today circled, past grey
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
                          children: List.generate(state.monthWeeks.length, (r) {
                            final row = state.monthWeeks[r];
                            return TableRow(
                              children: List.generate(7, (c) {
                                final date = row[c];
                                if (date == null) {
                                  return SizedBox(height: 40.h); // empty cell
                                }

                                final isToday = (date.year == now.year &&
                                    date.month == now.month &&
                                    date.day == now.day);
                                final todayMid = DateTime(now.year, now.month, now.day);
                                final isPast = date.isBefore(todayMid);

                                final textStyle = TextStyleHelper.instance
                                    .label10LightPoppins
                                    .copyWith(
                                      color: isPast ? appTheme.gray_600 : appTheme.white_A700,
                                    );

                                final inner = Center(
                                  child: isToday
                                      ? Container(
                                          width: 36.h,
                                          height: 36.h,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: appTheme.gray_700, width: 3.h),
                                            borderRadius: BorderRadius.circular(18.h),
                                          ),
                                          child: Center(child: Text('${date.day}', style: textStyle)),
                                        )
                                      : Text('${date.day}', style: textStyle),
                                );

                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: isPast
                                      ? inner
                                      : GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => ref
                                              .read(prayerTrackerNotifierProvider.notifier)
                                              .selectDate(date),
                                          child: inner,
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
      ],
    );
  }
}
