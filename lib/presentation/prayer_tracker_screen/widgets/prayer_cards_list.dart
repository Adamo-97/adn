import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../notifier/prayer_tracker_notifier.dart';

class PrayerCardsList extends ConsumerWidget {
  const PrayerCardsList({super.key, required this.fardPrayers});
  final List<String> fardPrayers; // ['Fajr','Dhuhr','Asr','Maghrib','Isha']

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final times = state.dailyTimes;         // {'Fajr':'05:30 AM', ...}
    final done = state.completedByPrayer;   // {'Fajr':true, ...}
    final current = state.currentPrayer;    // e.g., 'Asr'
    final currentIdx = fardPrayers.indexOf(current);

    final children = <Widget>[];
    for (int i = 0; i < fardPrayers.length; i++) {
      final name = fardPrayers[i];
      final time = times[name] ?? '00:00';
      final isCompleted = done[name] == true;
      final isCurrent = name == current;
      final isAfter = currentIdx >= 0 ? i > currentIdx : false;

      children.add(_PrayerCardRow(
        name: name,
        time: time,
        isCompleted: isCompleted,
        isCurrent: isCurrent,
        isAfterCurrent: isAfter,
        onToggle: () {
          // wire later if you add toggling
          // ref.read(prayerTrackerNotifierProvider.notifier).toggleCompletion(name);
        },
      ));
      children.add(SizedBox(height: 10.h));
    }

    return Column(children: children);
  }
}

class _PrayerCardRow extends StatelessWidget {
  const _PrayerCardRow({
    required this.name,
    required this.time,
    required this.isCompleted,
    required this.isCurrent,
    required this.isAfterCurrent,
    this.onToggle,
  });

  final String name;
  final String time;
  final bool isCompleted;
  final bool isCurrent;
  final bool isAfterCurrent;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    // match your initial page visuals
    const nonCurrentBg = Color(0x1A5C6248); // 10% alpha on #5C6248
    final nameColor = isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.5);
    final timeColor = isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.5);
    final decorationColor = isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.5);
    final bgColor = isCurrent ? appTheme.gray_700 : nonCurrentBg;
    const uncheckedSvgPath = 'assets/images/ic_checkbox_unchecked.svg';

    return Opacity(
      opacity: isAfterCurrent ? 0.5 : 1.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.h),
        ),
        child: Row(
          children: [
            // Checkbox visuals exactly like your page
            GestureDetector(
              onTap: onToggle,
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
                        imagePath: uncheckedSvgPath,
                        height: 24.h,
                        width: 24.h,
                      ),
              ),
            ),
            SizedBox(width: 10.h),

            // name (strike-through only here)
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

            // time (no strike-through)
            Text(
              time,
              style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                color: timeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
