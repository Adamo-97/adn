import 'package:flutter/material.dart';

import 'package:adam_s_application/core/app_export.dart';
import '../../../core/utils/time_format_utils.dart';
import '../notifier/prayer_tracker_notifier.dart';
import '../../profile_settings_screen/notifier/profile_settings_notifier.dart';
import '../widgets/prayer_notification_icon.dart';

class PrayerCardsList extends ConsumerWidget {
  const PrayerCardsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final items = state.cardItems;

    // Get time format preference from profile settings (single source of truth)
    final use24HourFormat = ref.watch(
        profileSettingsNotifier.select((s) => s.use24HourFormat ?? false));

    return Column(
      children: [
        for (final item in items) ...[
          _CardRow(item: item, use24HourFormat: use24HourFormat),
          SizedBox(height: 5.h),
        ],
      ],
    );
  }
}

class _CardRow extends ConsumerWidget {
  final PrayerCardItem item;
  final bool use24HourFormat;

  const _CardRow({required this.item, required this.use24HourFormat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Colors per your spec
    const nonCurrentBg = Color(0x1A5C6248); // 10% alpha on #5C6248
    final nameColor =
        item.isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.5);
    final timeColor =
        item.isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.5);
    final decorationColor =
        item.isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.5);
    final bgColor = item.isCurrent ? appColors.gray_700 : nonCurrentBg;

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
              child: _RoundCheckbox(
                checked: item.isCompleted,
                enabled: !item.isAfterCurrent,
                size: 24.h, // icon visual size
                // colors match your current vs non-current scheme
                fillColor:
                    item.isCurrent ? appColors.orange_200 : appColors.gray_700,
                borderColor: item.isCurrent
                    ? appColors.orange_200
                    : appColors.whiteA700.withValues(alpha: 0.5),
                checkColor: appColors.whiteA700, // contrast on orange fill
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
                  decoration: item.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: decorationColor,
                  decorationThickness: 2,
                ),
              ),
            ),
            SizedBox(width: 12.h),

            // Time (no strike-through) - formatted based on user preference
            Text(
              TimeFormatUtils.formatTime(item.time, use24HourFormat),
              style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                color: timeColor,
              ),
            ),
            SizedBox(width: 12.h),

            // Bell (unchanged)
            PrayerNotificationIcon(
              prayerId: item.name,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}

// keep this OUTSIDE the _CardRow class
class _RoundCheckbox extends StatelessWidget {
  final bool checked;
  final bool enabled;
  final double size; // visual circle diameter (was 24.h)
  final Color fillColor; // used when checked
  final Color borderColor; // outline color
  final Color checkColor; // tick color

  const _RoundCheckbox({
    required this.checked,
    required this.enabled,
    required this.size,
    required this.fillColor,
    required this.borderColor,
    required this.checkColor,
  });

  @override
  Widget build(BuildContext context) {
    final circle = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: checked ? fillColor : Colors.transparent,
        border: Border.all(color: borderColor, width: 2.h),
      ),
      child: checked
          ? Icon(Icons.check_rounded, size: size * 0.66, color: checkColor)
          : const SizedBox.shrink(),
    );

    // preserve your old ~28.h tap target
    final box = SizedBox(
      width: size + 4.h,
      height: size + 4.h,
      child: Center(child: circle),
    );

    return enabled ? box : Opacity(opacity: 0.6, child: box);
  }
}
