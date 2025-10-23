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
  });

  final void Function(PrayerActionModel action) onActionTap;
  final bool qiblaSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final PrayerTrackerModel m = state.prayerTrackerModel ?? PrayerTrackerModel();
    final actions = m.prayerActions ?? const <PrayerActionModel>[];

    // EXACT same layout you had: Padding -> Wrap(spaceBetween) with spacing/runSpacing 12.h
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 12.h,
        spacing: 12.h,
        children: actions.map((action) {
          // Check if this is the Qibla button
          final isQibla = (action.label ?? '').toLowerCase().contains('qibla');
          
          return PrayerActionItemWidget(
            action: action,
            onTap: () => onActionTap(action),
            isSelected: isQibla ? qiblaSelected : false,
          );
        }).toList(),
      ),
    );
  }
}
