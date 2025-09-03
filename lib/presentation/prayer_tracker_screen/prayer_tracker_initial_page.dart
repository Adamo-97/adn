import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './models/prayer_tracker_model.dart';
import 'notifier/prayer_tracker_notifier.dart';

import './widgets/fixed_prayer_header.dart';
import './widgets/prayer_actions.dart';
import './widgets/qibla_panel.dart';
import './widgets/progress_indicators_row.dart';
import './widgets/date_nav_calendar.dart';
import './widgets/prayer_cards_list.dart';

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
        SizedBox(height: 16.h),
        const DateNavCalendar(),
        SizedBox(height: 20.h),
        const PrayerCardsList(),
      ],
    );
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
