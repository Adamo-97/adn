import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../models/prayer_tracker_model.dart';

class PrayerRowWidget extends StatelessWidget {
  final PrayerRowModel row;
  final bool isFirstRow;
  final bool isLastRow;

  const PrayerRowWidget({
    Key? key,
    required this.row,
    this.isFirstRow = false,
    this.isLastRow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.gray_900_01,
        borderRadius: isLastRow
            ? BorderRadius.only(
                bottomLeft: Radius.circular(10.h),
                bottomRight: Radius.circular(10.h),
              )
            : null,
      ),
      padding: EdgeInsets.symmetric(
        vertical: isFirstRow ? 2.h : 10.h,
        horizontal: isFirstRow ? 4.h : 18.h,
      ),
      child: Row(
        mainAxisAlignment: isFirstRow
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: (row.values ?? []).map((value) {
          // Modified: Added null safety handling
          int index = (row.values ?? [])
              .indexOf(value); // Modified: Added null safety handling
          return isFirstRow && index == 0
              ? Container(
                  width: 36.h,
                  height: 36.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: appTheme.gray_700,
                      width: 3.h,
                    ),
                    borderRadius: BorderRadius.circular(18.h),
                  ),
                  child: Center(
                    child: Text(
                      value,
                      style: TextStyleHelper.instance.label10LightPoppins,
                    ),
                  ),
                )
              : isFirstRow
                  ? Row(
                      children: [
                        if (index > 1) Spacer(),
                        Text(
                          value,
                          style: TextStyleHelper.instance.label10LightPoppins,
                        ),
                      ],
                    )
                  : Text(
                      value,
                      style: TextStyleHelper.instance.label10LightPoppins,
                    );
        }).toList(),
      ),
    );
  }
}
