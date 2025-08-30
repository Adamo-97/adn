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
    final values = row.values ?? const <String>[];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double hPad = isFirstRow ? 4.h : 18.h;           // row’s horizontal padding
        final double inner = constraints.maxWidth - (hPad * 2); // <— inner width
        final double colWidth = inner / 7.0;

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
            horizontal: hPad,
          ),
          child: Row(
            children: List.generate(7, (i) {
              final value = i < values.length ? values[i] : '';
              Widget cell = Center(
                child: Text(
                  value,
                  style: TextStyleHelper.instance.label10LightPoppins,
                  overflow: TextOverflow.ellipsis,
                ),
              );

              if (isFirstRow && i == 0) {
                cell = Center(
                  child: Container(
                    width: 36.h,
                    height: 36.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: appTheme.gray_700, width: 3.h),
                      borderRadius: BorderRadius.circular(18.h),
                    ),
                    child: Center(
                      child: Text(
                        value,
                        style: TextStyleHelper.instance.label10LightPoppins,
                      ),
                    ),
                  ),
                );
              }

              return SizedBox(width: colWidth, child: cell);
            }),
          ),
        );
      },
    );
  }
}
