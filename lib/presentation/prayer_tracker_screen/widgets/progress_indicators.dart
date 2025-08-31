import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_export.dart';
import '../notifier/prayer_tracker_notifier.dart';

class ProgressIndicators extends ConsumerWidget {
  const ProgressIndicators({super.key, required this.fardPrayers});
  final List<String> fardPrayers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final done = state.completedByPrayer; // map<String,bool>
    final current = state.currentPrayer;
    final currentIsFard = fardPrayers.contains(current);

    final List<Widget> bars = [];
    for (int i = 0; i < fardPrayers.length; i++) {
      final name = fardPrayers[i];
      final isCompleted = done[name] == true;
      final isCurrent = currentIsFard && (name == current);

      final Color c = isCompleted
          ? appTheme.gray_700 // completed = dark
          : (isCurrent ? appTheme.gray_500 : appTheme.white_A700);

      bars.add(Expanded(
        child: Container(
          height: 6.h,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(20.h),
          ),
        ),
      ));
      if (i != fardPrayers.length - 1) {
        bars.add(SizedBox(width: 6.h));
      }
    }

    return Row(children: bars);
  }
}
