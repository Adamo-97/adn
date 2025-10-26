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

    // Full width layout - no horizontal padding, buttons fill edge to edge
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.h), // No padding, fill width
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int i = 0; i < actions.length; i++) ...[
            Expanded(
              child: Builder(
                builder: (context) {
                  final action = actions[i];
                  final id = action.id.toLowerCase();
                  final isQibla = id.contains('qibla');
                  final isWeeklyStat = id.contains('weekly');
                  final isMonthlyStat = id.contains('monthly');
                  final isQuadStat = id.contains('quad');

                  bool isSelected = false;
                  if (isQibla) {
                    isSelected = qiblaSelected;
                  } else if (isWeeklyStat) {
                    isSelected = weeklyStatSelected;
                  } else if (isMonthlyStat) {
                    isSelected = monthlyStatSelected;
                  } else if (isQuadStat) {
                    isSelected = quadStatSelected;
                  }

                  return PrayerActionItemWidget(
                    action: action,
                    onTap: () => onActionTap(action),
                    isSelected: isSelected,
                  );
                },
              ),
            ),
            if (i < actions.length - 1) SizedBox(width: 16.h),
          ],
        ],
      ),
    );
  }
}
