import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/prayer_tracker_notifier.dart';
import '../../../core/utils/image_constant.dart';

class PrayerNotificationIcon extends ConsumerWidget {
  const PrayerNotificationIcon({
    super.key,
    required this.prayerId,
    this.size = 24.0,
    this.hitSize,
  });

  final String prayerId;
  final double size;
  final Size? hitSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(
      prayerTrackerNotifierProvider.select(
        (s) => s.bellByPrayer[prayerId] ?? PrayerBellMode.adhan,
      ),
    );

    String asset(PrayerBellMode m) {
      switch (m) {
        case PrayerBellMode.adhan: return ImageConstant.bellAdhan;
        case PrayerBellMode.pling: return ImageConstant.bellPling;
        case PrayerBellMode.mute:  return ImageConstant.bellMute;
      }
    }

    final childKey = ValueKey(mode);

    final icon = SizedBox(
      width: size,
      height: size,
      child: Center(
        child: SvgPicture.asset(
          asset(mode),
          fit: BoxFit.contain,
        ),
      ),
    );

    final tappable = SizedBox(
      width: hitSize?.width,
      height: hitSize?.height,
      child: Center(
        child: RepaintBoundary(
          key: childKey,
          child: icon,
        ),
      ),
    );

    return InkWell(
      onTap: () =>
          ref.read(prayerTrackerNotifierProvider.notifier).cycleBell(prayerId),
      customBorder: const CircleBorder(),
      child: tappable,
    );
  }
}
