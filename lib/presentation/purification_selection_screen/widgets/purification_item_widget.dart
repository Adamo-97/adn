import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/purification_item_model.dart';

class PurificationItemWidget extends StatelessWidget {
  final PurificationItemModel purificationItem;

  const PurificationItemWidget({
    Key? key,
    required this.purificationItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        vertical: purificationItem.isMainCard ?? false ? 14.h : 12.h,
      ),
      decoration: BoxDecoration(
        color: appTheme.gray_500,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appTheme.gray_700,
          width: 3.h,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: purificationItem.iconPath ?? '',
            height: 48.h,
            width: _getIconWidth(),
          ),
          SizedBox(height: purificationItem.isMainCard ?? false ? 14.h : 16.h),
          Text(
            purificationItem.primaryTitle ?? '',
            style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                color: appTheme.orange_200,
                height: purificationItem.isMainCard ?? false ? 1.33 : 1.53),
            textAlign: purificationItem.isMainCard ?? false
                ? TextAlign.center
                : TextAlign.left,
          ),
          Text(
            purificationItem.secondaryTitle ?? '',
            style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                color: appTheme.white_A700,
                height: purificationItem.isMainCard ?? false ? 1.33 : 1.53),
            textAlign: purificationItem.isMainCard ?? false
                ? TextAlign.center
                : TextAlign.left,
          ),
        ],
      ),
    );
  }

  double _getIconWidth() {
    if (purificationItem.iconPath?.contains('tayammum') ?? false) {
      return 58.h;
    } else if (purificationItem.iconPath?.contains('ghusl') ?? false) {
      return 28.h;
    }
    return 48.h;
  }
}
