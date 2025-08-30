import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_field_with_icon.dart';
import './models/prayer_tracker_model.dart';
import './widgets/prayer_action_item_widget.dart';
import 'notifier/prayer_tracker_notifier.dart';

class PrayerTrackerInitialPage extends ConsumerStatefulWidget {
  const PrayerTrackerInitialPage({Key? key}) : super(key: key);

  @override
  PrayerTrackerInitialPageState createState() =>
      PrayerTrackerInitialPageState();
}

class PrayerTrackerInitialPageState
    extends ConsumerState<PrayerTrackerInitialPage> {
      static const List<String> _fardPrayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

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
          _buildFixedPrayerHeader(context,
            topInset: topInset,
            totalHeight: headerTotalHeight,
          ),
        ],
      ),
    );
  }

  Widget _buildFixedPrayerHeader(
    BuildContext context, {
    required double topInset,
    required double totalHeight,
  }) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final m = state.prayerTrackerModel ?? PrayerTrackerModel();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: totalHeight,
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.gray_700,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(14.h),
            bottomRight: Radius.circular(14.h),
          ),
        ),
        padding: EdgeInsets.fromLTRB(25.h, topInset + 16.h, 25.h, 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Prayers',
              textAlign: TextAlign.center,
              style: TextStyleHelper.instance.title20BoldPoppins,
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.nextPrayer ?? 'Next Prayer',
                        style: TextStyleHelper.instance.body15RegularPoppins
                            .copyWith(color: appTheme.white_A700),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${m.prayerTime ?? '--:--'} |',
                            style: TextStyleHelper.instance.body12RegularPoppins
                                .copyWith(color: appTheme.orange_200),
                          ),
                          SizedBox(width: 4.h),
                          CustomImageView(
                            imagePath: ImageConstant.imgLocationIcon,
                            height: 8.h,
                            width: 8.h,
                          ),
                          SizedBox(width: 4.h),
                          Flexible(
                            child: Text(
                              m.location ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleHelper.instance.body12RegularPoppins
                                  .copyWith(color: appTheme.orange_200),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgDhuhrIcon,
                  height: 42.h,
                  width: 42.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPrayerActions(context),
        SizedBox(height: 28.h),
        _buildCompassSection(context),
        SizedBox(height: 28.h),
        _buildPhoneInstructions(context),
        SizedBox(height: 16.h),
        _buildProgressIndicators(context),
        SizedBox(height: 8.h),
        _buildPrayerStatusInput(context),
        SizedBox(height: 12.h),
        _buildDateNavigation(context),
        SizedBox(height: 16.h),
        _buildPrayerCalendar(context),
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

  Widget _buildPrayerActions(BuildContext context) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final PrayerTrackerModel m =
        state.prayerTrackerModel ?? PrayerTrackerModel();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 12.h,
        spacing: 12.h,
        children: (m.prayerActions ?? const <PrayerActionModel>[])
            .map(
              (action) => PrayerActionItemWidget(
                action: action,
                onTap: () => _onPrayerActionTap(action),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCompassSection(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: CustomImageView(
        imagePath: ImageConstant.imgCompassIcon,
        height: 202.h,
        width: 194.h,
      ),
    );
  }

  Widget _buildPhoneInstructions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // center the whole row
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgMobileIcon,
          height: 22.h,
          width: 26.h,
        ),
        SizedBox(width: 12.h),
        // Let the text wrap and stay centered
        Flexible(
          child: Text(
            'Please place your phone on a flat surface',
            textAlign: TextAlign.center,
            style: TextStyleHelper.instance.label10LightPoppins,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicators(BuildContext context) {
    final state    = ref.watch(prayerTrackerNotifierProvider);
    final done     = state.completedByPrayer;   // map<String,bool>
    final current  = state.currentPrayer;       // e.g. "Asr"
    final currentIsFard = _fardPrayers.contains(current);

    List<Widget> bars = [];
    for (int i = 0; i < _fardPrayers.length; i++) {
      final name = _fardPrayers[i];
      final isCompleted = done[name] == true;
      final isCurrent   = currentIsFard && (name == current);

      final Color c = isCompleted
          ? appTheme.gray_700           // completed = dark (your existing)
          : (isCurrent
              ? appTheme.gray_500       // current (not completed) = light (your existing)
              : appTheme.white_A700);   // not done = white

      bars.add(
        Expanded(
          child: Container(
            height: 8.h,
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(4.h),
            ),
          ),
        ),
      );
      if (i != _fardPrayers.length - 1) bars.add(SizedBox(width: 10.h));
    }

    return Padding(
      padding: EdgeInsets.all(10.h),
      child: Row(children: bars),
    );
  }

  Widget _buildPrayerStatusInput(BuildContext context) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final completedCount = _fardPrayers.where((p) => state.completedByPrayer[p] == true).length;

    return CustomTextFieldWithIcon(
      leftIcon: ImageConstant.imgCheck,
      hintText: '$completedCount/5 prayers completed today.',
      textStyle: TextStyleHelper.instance.body15RegularPoppins
          .copyWith(color: appTheme.white_A700),
    );
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

  Widget _buildFajrPrayerRow(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.gray_700,
        borderRadius: BorderRadius.circular(20.h),
      ),
      padding: EdgeInsets.all(14.h),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgCheckedIcon,
            height: 24.h,
            width: 24.h,
          ),
          SizedBox(width: 10.h),
          Text(
            'Fajr',
            style: TextStyleHelper.instance.body15RegularPoppins
                .copyWith(color: appTheme.white_A700),
          ),
          SizedBox(width: 16.h),
          Text(
            '00:00',
            style: TextStyleHelper.instance.body15RegularPoppins
                .copyWith(color: appTheme.white_A700),
          ),
          const Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgNotificationOn,
            height: 26.h,
            width: 24.h,
          ),
        ],
      ),
    );
  }

  void _onPrayerActionTap(PrayerActionModel action) {
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
