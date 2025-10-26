import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './models/prayer_tracker_model.dart';
import 'notifier/prayer_tracker_notifier.dart';

import './widgets/fixed_prayer_header.dart';
import './widgets/prayer_actions.dart';
import './widgets/qibla_panel.dart';
import './widgets/weekly_stats_panel.dart';
import './widgets/monthly_stats_panel.dart';
import './widgets/quarterly_stats_panel.dart';
import './widgets/progress_indicators_row.dart';
import './widgets/date_nav_calendar.dart';
import './widgets/prayer_cards_list.dart';

class PrayerTrackerInitialPage extends ConsumerStatefulWidget {
  const PrayerTrackerInitialPage({super.key});

  @override
  PrayerTrackerInitialPageState createState() =>
      PrayerTrackerInitialPageState();
}

class PrayerTrackerInitialPageState
    extends ConsumerState<PrayerTrackerInitialPage> {
  static const List<String> _fardPrayers = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha'
  ];

  @override
  void dispose() {
    ref.read(prayerTrackerNotifierProvider.notifier).resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final double headerBodyHeight = 125.h; // visible part below the status bar
    final double headerTotalHeight = topInset + headerBodyHeight;
    final double navbarHeight = 76.h; // Bottom navbar height

    // DEBUG: Print layout measurements
    debugPrint(
        'DEBUG Layout: topInset=$topInset, headerTotalHeight=$headerTotalHeight, '
        'navbarHeight=$navbarHeight, gradientHeight=${navbarHeight + 40.h}');

    return ColoredBox(
      color: appTheme.gray_900,
      child: Stack(
        children: [
          // Scrollable content UNDER the fixed header
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              25.h,
              headerTotalHeight + 12.h, // push content below header
              25.h,
              navbarHeight + 20.h, // Bottom padding: navbar + extra clearance
            ),
            child: _buildPrayerContent(context),
          ),

          // Fixed header on top
          FixedPrayerHeader(topInset: topInset, totalHeight: headerTotalHeight),

          // Bottom fade effect - positioned to start where scrollable content is
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                height: navbarHeight +
                    40.h, // Extend gradient higher to cover more content
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.3, 0.6, 0.85, 1.0],
                    colors: [
                      appTheme.gray_900.withOpacity(0.0),
                      appTheme.gray_900.withOpacity(0.2),
                      appTheme.gray_900.withOpacity(0.5),
                      appTheme.gray_900.withOpacity(0.8),
                      appTheme.gray_900,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerContent(BuildContext context) {
    final m = ref.watch(prayerTrackerNotifierProvider); // Riverpod state
    //count the completed prayers
    final completedCount =
        _fardPrayers.where((p) => m.completedByPrayer[p] == true).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrayerActions(
          onActionTap: _onPrayerActionTap,
          qiblaSelected: m.qiblaOpen,
          weeklyStatSelected: m.openStatButton == 'weekly',
          monthlyStatSelected: m.openStatButton == 'monthly',
          quadStatSelected: m.openStatButton == 'quad',
        ),
        QiblaPanel(isOpen: m.qiblaOpen),
        WeeklyStatsPanel(isOpen: m.openStatButton == 'weekly'),
        MonthlyStatsPanel(isOpen: m.openStatButton == 'monthly'),
        QuarterlyStatsPanel(isOpen: m.openStatButton == 'quad'),
        SizedBox(height: 16.h),
        ProgressIndicatorsRow(
          statuses: m.progressStatusesRaw,
          colors: ProgressColors(
            completed: appTheme.gray_700, // completed
            current: appTheme.gray_500, // current
            upcoming: appTheme.white_A700, // upcoming/uncompleted
          ),
          completedCount: completedCount,
          totalFard: _fardPrayers.length, // 5
        ),
        SizedBox(height: 16.h),
        const DateNavCalendar(),
        SizedBox(height: 20.h),
        const PrayerCardsList(),
      ],
    );
  }

  void _onPrayerActionTap(PrayerActionModel action) {
    final label = action.label.toLowerCase().trim();
    final aid = action.id.toLowerCase().trim();

    // Check if this is Qibla button
    final isQibla = label.contains('qibla') || aid.contains('qibla');

    // Check if this is a stat button
    final isWeeklyStat = aid.contains('weekly');
    final isMonthlyStat = aid.contains('monthly');
    final isQuadStat = aid.contains('quad');

    final notifier = ref.read(prayerTrackerNotifierProvider.notifier);

    if (isQibla) {
      notifier.toggleQibla();
      return;
    }

    if (isWeeklyStat) {
      notifier.toggleStatButton('weekly');
      return;
    }

    if (isMonthlyStat) {
      notifier.toggleStatButton('monthly');
      return;
    }

    if (isQuadStat) {
      notifier.toggleStatButton('quad');
      return;
    }

    // For any other action (if added in future): reset UI state
    notifier.resetState();
  }
}
