import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/salah_guide_card_model.dart';

class SalahGuideCardWidget extends StatelessWidget {
  final SalahGuideCardModel card;
  final VoidCallback? onTapCard;

  const SalahGuideCardWidget({
    super.key,
    required this.card,
    this.onTapCard,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCard,
      child: Container(
        // tighter padding so the tile is shorter
        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 6.h),
        constraints: BoxConstraints(minHeight: 44.h), // compact but tappable
        decoration: BoxDecoration(
          color: card.backgroundColor ?? appColors.gray_700,
          border: Border.all(
            color: card.borderColor ?? appColors.gray_500,
            width: 2.h, // slimmer border reduces overall height feel
          ),
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // clamps text so it doesn't force extra height
              child: Text(
                card.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyleHelper.instance.body15RegularPoppins
                    .copyWith(color: appColors.whiteA700, height: 1.10),
              ),
            ),
            SizedBox(width: 6.h),
            CustomImageView(
              imagePath: card.iconPath ?? '',
              height: 18.h, // smaller icon
              width: 18.h,
            ),
          ],
        ),
      ),
    );
  }
}
