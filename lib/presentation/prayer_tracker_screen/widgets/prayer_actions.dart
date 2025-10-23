import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../models/prayer_tracker_model.dart';
import '../notifier/prayer_tracker_notifier.dart';
import 'prayer_action_item_widget.dart';

class PrayerActions extends ConsumerWidget {
  const PrayerActions({
    super.key,
    required this.onActionTap,
    this.qiblaSelected = false,
    this.weeklyStatSelected = false,
    this.monthlyStatSelected = false,
    this.quadStatSelected = false,
  });

  final void Function(PrayerActionModel action) onActionTap;
  final bool qiblaSelected;
  final bool weeklyStatSelected;
  final bool monthlyStatSelected;
  final bool quadStatSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final PrayerTrackerModel m =
        state.prayerTrackerModel ?? PrayerTrackerModel();
    final actions = m.prayerActions;

    // EXACT same layout you had: Padding -> Wrap(spaceBetween) with spacing/runSpacing 12.h
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 12.h,
        spacing: 12.h,
        children: actions.map((action) {
          // Check button type
          final id = action.id.toLowerCase();
          final isQibla = id.contains('qibla');
          final isWeeklyStat = id.contains('weekly');
          final isMonthlyStat = id.contains('monthly');
          final isQuadStat = id.contains('quad');

          // Determine if this button is selected
          bool isSelected = false;
          if (isQibla) {
            isSelected = qiblaSelected;
          } else if (isWeeklyStat)
            isSelected = weeklyStatSelected;
          else if (isMonthlyStat)
            isSelected = monthlyStatSelected;
          else if (isQuadStat) isSelected = quadStatSelected;

          return PrayerActionItemWidget(
            action: action,
            onTap: () => onActionTap(action),
            isSelected: isSelected,
          );
        }).toList(),
      ),
    );
  }
}
