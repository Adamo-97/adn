import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/prayer_tracker_model.dart';
import '../notifier/prayer_tracker_notifier.dart';

class FixedPrayerHeader extends ConsumerWidget {
  const FixedPrayerHeader({
    super.key,
    required this.topInset,
    required this.totalHeight,
  });

  final double topInset;
  final double totalHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTrackerNotifierProvider);
    final m = state.prayerTrackerModel ?? PrayerTrackerModel();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: totalHeight,
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.gray_700,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(14.h),
            bottomRight: Radius.circular(14.h),
          ),
        ),
        padding: EdgeInsets.fromLTRB(25.h, topInset + 16.h, 25.h, 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Prayers',
              textAlign: TextAlign.center,
              style: TextStyleHelper.instance.title20BoldPoppins,
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                // Left column: next prayer + time | location (unchanged)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.nextPrayer,
                        style: TextStyleHelper.instance.body15RegularPoppins
                            .copyWith(color: appTheme.white_A700),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${m.prayerTime} |',
                            style: TextStyleHelper.instance.body12RegularPoppins
                                .copyWith(color: appTheme.orange_200),
                          ),
                          SizedBox(width: 4.h),
                          CustomImageView(
                            imagePath: ImageConstant.imgLocationIcon,
                            height: 8.h,
                            width: 8.h,
                          ),
                          SizedBox(width: 4.h),
                          Flexible(
                            child: Text(
                              m.location,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleHelper
                                  .instance.body12RegularPoppins
                                  .copyWith(color: appTheme.orange_200),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Right: icon (unchanged)
                CustomImageView(
                  imagePath: ImageConstant.iconForPrayer(
                      state.currentPrayer), // same helper you use
                  height: 42.h,
                  width: 42.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
