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

  // Initialize here (not `late`) so hot-reload won't leave it uninitialized.
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // Do NOT call provider methods via `ref` here: accessing `ref` during
    // widget disposal can be unsafe (and causes test-time errors). The
    // tab-level reset is already handled by `PrayerTrackerScreen._resetTabState`.
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _scrollController is initialized at declaration to survive hot-reload.
  }

  @override
  Widget build(BuildContext context) {
    // Listen for reset events from the notifier and scroll to top when reset occurs.
    // NOTE: ref.listen must be called from build (or a ConsumerWidget) —
    // calling it in initState caused an assertion.
    ref.listen<PrayerTrackerState>(prayerTrackerNotifierProvider,
        (previous, next) {
      if (previous == null) return;

      // Only act when a reset event was emitted
      if (next.resetTimestamp != previous.resetTimestamp) {
        // If either the Qibla panel or calendar were open previously, they
        // animate closed (240ms). Wait slightly longer than that so the
        // scroll target and layout have stabilized before jumping to top.
        final bool wasAnyPanelOpen =
            previous.qiblaOpen || previous.calendarOpen;
        final int delayMs = wasAnyPanelOpen ? 300 : 0;

        Future.delayed(Duration(milliseconds: delayMs), () {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            // Defensively guard animateTo to avoid crashes when the
            // controller or its position are not available (e.g., during
            // teardown or rapid navigation). We prefer to silently skip the
            // scroll rather than throw.
            try {
              if (!mounted) return;
              if (_scrollController.hasClients) {
                await _scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                );
              }
            } catch (_) {
              // Swallow any error here — defensive: avoids app crash caused
              // by race conditions where the ScrollPosition becomes null
              // or detached during animation.
            }
          });
        });
      }
    });

    final topInset = MediaQuery.of(context).padding.top;
    final double headerBodyHeight = 125.h; // visible part below the status bar
    final double headerTotalHeight = topInset + headerBodyHeight;
    final double navbarHeight = 76.h; // Bottom navbar height

    // Layout measurements

    return ColoredBox(
      color: appColors.gray_900,
      child: Stack(
        children: [
          // Scrollable content UNDER the fixed header
          SingleChildScrollView(
            controller: _scrollController,
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
                      appColors.gray_900.withAlpha(0),
                      appColors.gray_900.withAlpha((0.2 * 255).round()),
                      appColors.gray_900.withAlpha((0.5 * 255).round()),
                      appColors.gray_900.withAlpha((0.8 * 255).round()),
                      appColors.gray_900,
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
            completed: appColors.gray_700, // completed
            current: appColors.gray_500, // current
            upcoming: appColors.whiteA700, // upcoming/uncompleted
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
