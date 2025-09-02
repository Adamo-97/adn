import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import './models/prayer_tracker_model.dart';
import 'notifier/prayer_tracker_notifier.dart';

import './widgets/fixed_prayer_header.dart';
import './widgets/prayer_actions.dart';
import './widgets/qibla_panel.dart';
import './widgets/progress_indicators_row.dart';
import './widgets/date_nav_calendar.dart';

class PrayerTrackerInitialPage extends ConsumerStatefulWidget {
  const PrayerTrackerInitialPage({Key? key}) : super(key: key);

  @override
  PrayerTrackerInitialPageState createState() =>
      PrayerTrackerInitialPageState();
}

class PrayerTrackerInitialPageState
    extends ConsumerState<PrayerTrackerInitialPage> {
      static const List<String> _fardPrayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    // Qibla UI local state (can be moved to your notifier later)
  bool _qiblaOpen = false;        // clicked / unclicked
  
  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final double headerBodyHeight = 125.h; // visible part below the status bar
    final double headerTotalHeight = topInset + headerBodyHeight;

    return ColoredBox(
      color: appTheme.gray_900,
      child: Stack(
        children: [
          // Scrollable content UNDER the fixed header
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              25.h,
              headerTotalHeight + 12.h,                  // push content below header
              25.h,
              15.h,           // keep clear of bottom bar
            ),
            child: _buildPrayerContent(context),
          ),

          // Fixed header on top
          FixedPrayerHeader(topInset: topInset, totalHeight: headerTotalHeight)
        ],
      ),
    );
  }

  Widget _buildPrayerContent(BuildContext context) {
    final m = ref.watch(prayerTrackerNotifierProvider); // Riverpod state
    //count the completed prayers
    final completedCount = _fardPrayers.where((p) => m.completedByPrayer[p] == true).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrayerActions(onActionTap: _onPrayerActionTap),
        QiblaPanel(isOpen: _qiblaOpen),
        SizedBox(height: 16.h),
       ProgressIndicatorsRow(
         statuses: m.progressStatusesRaw,
         colors: ProgressColors(
           completed: appTheme.gray_700,  // completed
           current:   appTheme.gray_500,  // current
           upcoming:  appTheme.white_A700,  // upcoming/uncompleted
         ),
        completedCount: completedCount,
        totalFard: _fardPrayers.length, // 5
      ),

        const DateNavCalendar(),
        SizedBox(height: 16.h),
        _buildPrayerCards(context),
      ],
    );
  }

  Widget _buildPrayerCards(BuildContext context) {
    final state   = ref.watch(prayerTrackerNotifierProvider);
    final times   = state.dailyTimes;
    final done    = state.completedByPrayer;
    final current = state.currentPrayer;

    const names = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    final currentIdx = names.indexOf(current);

    return Column(
      children: [
        for (var i = 0; i < names.length; i++) ...[
          _buildPrayerCardRow(
            context,
            name: names[i],
            time: times[names[i]] ?? '00:00',
            isCompleted: done[names[i]] ?? false,
            isCurrent: i == currentIdx,
            isAfterCurrent: i > currentIdx,
          ),
          SizedBox(height: 10.h),
        ]
      ],
    );
  }

  Widget _buildPrayerCardRow(
    BuildContext context, {
    required String name,
    required String time,
    required bool isCompleted,
    required bool isCurrent,
    required bool isAfterCurrent,
  }) {
    // Colors per spec
    const nonCurrentBg = Color(0x1A5C6248); // 10% alpha on #5C6248
    final nameColor = isCurrent ? Colors.white : Colors.white.withValues(alpha :0.5);
    final timeColor = isCurrent ? Colors.white : Colors.white.withValues(alpha :0.5);

    // Strike-through ONLY on name, not time; line color per spec
    final decorationColor = isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.5);
    // Container background: current uses your original card bg; others use 5C6248@10%
    final bgColor = isCurrent ? appTheme.gray_700 : nonCurrentBg;
    // Custom unchecked SVG
    const uncheckedSvgPath = 'assets/images/ic_checkbox_unchecked.svg';

    return Opacity(
      opacity: isAfterCurrent ? 0.5 : 1.0, // visually indicate disabled
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.h),
        ),
        padding: EdgeInsets.all(14.h),
        child: Row(
          children: [
            // Checkbox - custom svg for unchecked, existing check icon for checked
            GestureDetector(
              onTap: isAfterCurrent
                  ? null
                  : () => _onToggleCompleted(name),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 28.h,
                height: 28.h,
                child: isCompleted
                    ? CustomImageView(
                        imagePath: ImageConstant.imgCheckedIcon,
                        height: 24.h,
                        width: 24.h,
                      )
                    : CustomImageView(
                        imagePath: uncheckedSvgPath, // <-- your custom svg
                        height: 24.h,
                        width: 24.h,
                      ),
              ),
            ),
            SizedBox(width: 10.h),

            // Name (strike-through only here)
            Expanded(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                  color: nameColor,
                  decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: decorationColor,
                  decorationThickness: 2,
                ),
              ),
            ),

            SizedBox(width: 12.h),

            // Time (no strike-through)
            Text(
              time,
              style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                color: timeColor,
              ),
            ),

            SizedBox(width: 12.h),

            // Bell - unchanged
            CustomImageView(
              imagePath: ImageConstant.imgNotificationOn,
              height: 26.h,
              width: 24.h,
            ),
          ],
        ),
      ),
    );
  }

  void _onToggleCompleted(String name) {
    ref.read(prayerTrackerNotifierProvider.notifier).togglePrayerCompleted(name);
  }

  Widget _buildDateNavigation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgArrowPrev,
          height: 24.h,
          width: 24.h,
        ),
        Text(
          'Today, 00/00/0000',
          style: TextStyleHelper.instance.title18SemiBoldPoppins
              .copyWith(color: appTheme.orange_200),
        ),
        CustomImageView(
          imagePath: ImageConstant.imgArrowNext,
          height: 24.h,
          width: 24.h,
        ),
      ],
    );
  }

  Widget _buildPrayerCalendar(BuildContext context) {
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

        // Grid rows (bottom rounded), today circled, past disabled/grey
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
                    if (date == null) {
                      return SizedBox(height: 40.h); // empty cell spacer
                    }

                    final isToday = _isSameDay(date, now);
                    final isPast = date.isBefore(DateTime(now.year, now.month, now.day));

                    final textStyle = TextStyleHelper.instance.label10LightPoppins
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

                    // Past days are not tappable; today/future can be tapped
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: isPast
                          ? inner
                          : GestureDetector(
                              onTap: () => _onDateTap(date),
                              behavior: HitTestBehavior.opaque,
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
    );
  }

  /// Builds a month matrix (weeks × 7) starting on Sunday.
  /// Cells outside the current month are `null`.
  List<List<DateTime?>> _buildMonthMatrix(DateTime monthStart, DateTime monthEnd) {
    // Dart weekday: 1=Mon ... 7=Sun. We want Sunday index 0.
    int sundayBasedIndex(int weekday) => weekday % 7;

    final firstCol = sundayBasedIndex(monthStart.weekday);
    final totalDays = monthEnd.day;

    // Fill a flat list with leading nulls, then month days, then trailing nulls to complete weeks.
    final cells = <DateTime?>[];
    for (int i = 0; i < firstCol; i++) cells.add(null);
    for (int d = 1; d <= totalDays; d++) {
      cells.add(DateTime(monthStart.year, monthStart.month, d));
    }
    while (cells.length % 7 != 0) cells.add(null);

    // Chunk into rows of 7
    final rows = <List<DateTime?>>[];
    for (int i = 0; i < cells.length; i += 7) {
      rows.add(cells.sublist(i, i + 7));
    }
    return rows;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Hook to use when a clickable (today/future) date is tapped
  void _onDateTap(DateTime date) {
    ref.read(prayerTrackerNotifierProvider.notifier).selectDate(date);
  }

  void _onPrayerActionTap(PrayerActionModel action) {
    final label = (action.label ?? '').toLowerCase().trim();
    final aid   = (action.id ?? '').toLowerCase().trim();
    final isQibla = label.contains('qibla') || aid.contains('qibla');

    if (isQibla) {
      setState(() => _qiblaOpen = !_qiblaOpen); // show/hide compass + phone row
      return;                                   // DO NOT navigate for Qibla
    }

    // For any other action: reset state BEFORE navigating away.
    setState(() => _qiblaOpen = false);

    final dest = action.navigateTo;
    if (dest == null || dest.isEmpty) return;

    switch (dest) {
      case '576:475':
        NavigatorService.pushNamed(AppRoutes.purificationSelectionScreen);
        break;
      case '508:307':
        NavigatorService.pushNamed(AppRoutes.salahGuideMenuScreen);
        break;
      default:
        break;
    }
  }
}
