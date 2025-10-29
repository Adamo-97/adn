import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/purification_item_model.dart';

class PurificationItemWidget extends StatelessWidget {
  final PurificationItemModel purificationItem;

  const PurificationItemWidget({
    super.key,
    required this.purificationItem,
  });

  @override
  Widget build(BuildContext context) {
    final isMain = purificationItem.isMainCard ?? false;
    final vPad = isMain ? 14.h : 12.h;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellH = constraints.maxHeight;
        final innerH = (cellH - vPad * 2).clamp(0, double.infinity);

        // Icon a bit bigger than before, still safe in ~60.h rows
        final iconSize = (innerH * 0.62).clamp(24.h, 30.h).toDouble();

        // Always show one line. Fallback to secondary if primary is empty.
        final title =
            (purificationItem.primaryTitle?.trim().isNotEmpty ?? false)
                ? purificationItem.primaryTitle!.trim()
                : (purificationItem.secondaryTitle ?? '').trim();

        return Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: vPad).copyWith(
            left: 12.h,
            right: 12.h,
          ),
          decoration: BoxDecoration(
            color: appTheme.gray_500, // your bg
            borderRadius: BorderRadius.circular(12.h),
            border:
                Border.all(color: appTheme.gray_700, width: 3.h), // your border
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style:
                        TextStyleHelper.instance.body15RegularPoppins.copyWith(
                      fontSize: 15.0,
                      height: 1.10,
                      color: appTheme.whiteA700, // ✅ white text
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.h),
              CustomImageView(
                imagePath: purificationItem.iconPath ?? '',
                height: iconSize,
                width: iconSize,
                fit: BoxFit.contain,
                alignment: Alignment.centerRight,
                // Make the icon gold. If CustomImageView doesn't expose `color`,
                // switch to a colorFilter in that widget implementation.
                color: appTheme.orange_200, // ✅ gold icon
                // colorFilter: ColorFilter.mode(appTheme.orange_200, BlendMode.srcIn),
              ),
            ],
          ),
        );
      },
    );
  }
}
