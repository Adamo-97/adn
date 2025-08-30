import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_field_with_icon.dart';
import './models/prayer_tracker_model.dart';
import './widgets/prayer_action_item_widget.dart';
import './widgets/prayer_row_widget.dart';
import 'notifier/prayer_tracker_notifier.dart';

class PrayerTrackerInitialPage extends ConsumerStatefulWidget {
  const PrayerTrackerInitialPage({Key? key}) : super(key: key);

  @override
  PrayerTrackerInitialPageState createState() =>
      PrayerTrackerInitialPageState();
}

class PrayerTrackerInitialPageState
    extends ConsumerState<PrayerTrackerInitialPage> {
  static const double _bottomBarHeightApprox = 76; // matches CustomBottomBar

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: appTheme.gray_900,
      child: SingleChildScrollView(
        // keep content clear of the bottom bar
        padding: EdgeInsets.fromLTRB(25.h, 0, 25.h, (_bottomBarHeightApprox + 12).h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPrayerHeader(context),
            SizedBox(height: 20.h),
            _buildPrayerContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerHeader(BuildContext context) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    // ✅ your model field name is prayerTrackerModel
    final PrayerTrackerModel m =
        state.prayerTrackerModel ?? PrayerTrackerModel();

    return Container(
      decoration: BoxDecoration(
        color: appTheme.gray_700,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14.h),
          bottomRight: Radius.circular(14.h),
        ),
      ),
      padding: EdgeInsets.all(24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40.h),
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
  final state = ref.watch(prayerTrackerNotifierProvider);
  final times = state.dailyTimes;
  final done = state.completedByPrayer;
  final current = state.currentPrayer;

  const names = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  return Column(
    children: [
      for (final name in names) ...[
        _buildPrayerCardRow(
          context,
          name: name,
          time: times[name] ?? '00:00',
          isCompleted: done[name] ?? false,
          isCurrent: name == current,
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
}) {
  final Color baseText = appTheme.white_A700;
  // Only the current prayer should be green; use Material green for now (TODO: map to theme token)
  final Color accent = isCurrent ? Colors.greenAccent : baseText;

  final TextStyle nameStyle = TextStyleHelper.instance.body15RegularPoppins.copyWith(
    color: accent.withOpacity(isCompleted ? 0.7 : 1.0),
    decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
  );

  final TextStyle timeStyle = TextStyleHelper.instance.body15RegularPoppins.copyWith(
    color: accent.withOpacity(isCompleted ? 0.7 : 1.0),
    decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
  );

  return Container(
    decoration: BoxDecoration(
      color: appTheme.gray_700,
      borderRadius: BorderRadius.circular(20.h),
    ),
    padding: EdgeInsets.all(14.h),
    child: Row(
      children: [
        // Checkbox zone (tap to toggle)
        GestureDetector(
          onTap: () => _onToggleCompleted(name),
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
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: appTheme.gray_500, width: 2.h),
                      borderRadius: BorderRadius.circular(6.h),
                    ),
                    // empty box look
                    margin: EdgeInsets.all(2.h),
                  ),
          ),
        ),
        SizedBox(width: 10.h),
        // Name
        Expanded(
          child: Text(name, style: nameStyle),
        ),
        SizedBox(width: 12.h),
        // Time
        Text(time, style: timeStyle),
        SizedBox(width: 12.h),
        // Bell (kept as-is; can make interactive later)
        CustomImageView(
          imagePath: ImageConstant.imgNotificationOn,
          height: 26.h,
          width: 24.h,
        ),
      ],
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
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgMobileIcon,
          height: 22.h,
          width: 26.h,
        ),
        SizedBox(width: 24.h),
        Expanded(
          child: Text(
            'Please place your phone on a flat surface',
            style: TextStyleHelper.instance.label10LightPoppins,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicators(BuildContext context) {
    Widget bar(Color c) => Expanded(
          child: Container(
            height: 8.h,
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(4.h),
            ),
          ),
        );

    return Padding(
      padding: EdgeInsets.all(10.h),
      child: Row(
        children: [
          bar(appTheme.gray_700),
          SizedBox(width: 10.h),
          bar(appTheme.gray_500),
          SizedBox(width: 10.h),
          bar(appTheme.white_A700),
          SizedBox(width: 10.h),
          bar(appTheme.white_A700),
          SizedBox(width: 10.h),
          bar(appTheme.white_A700),
        ],
      ),
    );
  }

  Widget _buildPrayerStatusInput(BuildContext context) {
    return CustomTextFieldWithIcon(
      leftIcon: ImageConstant.imgCheck,
      hintText: '1/5 prayers completed today.',
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
