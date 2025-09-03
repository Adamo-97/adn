import 'package:flutter/material.dart';

import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/widgets/custom_image_view.dart';
import '../notifier/prayer_tracker_notifier.dart';
import '../widgets/prayer_notification_icon.dart';
class PrayerCardsList extends ConsumerWidget {
  const PrayerCardsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final items = state.cardItems; // ← derived list from state

    return Column(
      children: [
        for (final item in items) ...[
          _CardRow(item: item),
          SizedBox(height: 5.h),
        ],
      ],
    );
  }
}

class _CardRow extends ConsumerWidget {
  final PrayerCardItem item;
  const _CardRow({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Colors per your spec
    const nonCurrentBg = Color(0x1A5C6248); // 10% alpha on #5C6248
    final nameColor = item.isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.5);
    final timeColor = item.isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.5);
    final decorationColor = item.isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.5);
    final bgColor = item.isCurrent ? appTheme.gray_700 : nonCurrentBg;

    const uncheckedSvgPath = 'assets/images/ic_checkbox_unchecked.svg';

    return Opacity(
      opacity: item.isAfterCurrent ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.h),
        ),
        padding: EdgeInsets.all(14.h),
        child: Row(
          children: [
            // Checkbox – business rule enforced in notifier (future prayers blocked)
            GestureDetector(
              onTap: item.isAfterCurrent
                  ? null
                  : () => ref
                      .read(prayerTrackerNotifierProvider.notifier)
                      .togglePrayerCompleted(item.name),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 28.h,
                height: 28.h,
                child: item.isCompleted
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

            // Name (strike-through only here)
            Expanded(
              child: Text(
                item.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                  color: nameColor,
                  decoration: item.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: decorationColor,
                  decorationThickness: 2,
                ),
              ),
            ),
            SizedBox(width: 12.h),

            // Time (no strike-through)
            Text(
              item.time,
              style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                color: timeColor,
              ),
            ),
            SizedBox(width: 12.h),

            // Bell (unchanged)
            PrayerNotificationIcon(
              prayerId: item.name, // use the prayer name as ID ("Fajr", "Asr", etc.)
              size: 26,            // we’ll wrap in a transparent square
            ),
          ],
        ),
      ),
    );
  }
}
