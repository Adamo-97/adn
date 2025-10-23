import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/surah_item_model.dart';

class SurahItemWidget extends StatelessWidget {
  final SurahItemModel? surahModel;
  final VoidCallback? onTapSurah;

  const SurahItemWidget({
    super.key,
    this.surahModel,
    this.onTapSurah,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTapSurah,
        child: Container(
            width: 182.h,
            padding: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
                color: appTheme.gray_700,
                border: Border.all(color: appTheme.gray_500, width: 3.h),
                borderRadius: BorderRadius.circular(12.h)),
            child: Row(children: [
              Container(
                  width: 32.h,
                  height: 32.h,
                  margin: EdgeInsets.only(left: 5.h),
                  child: Stack(alignment: Alignment.center, children: [
                    CustomImageView(
                        imagePath: ImageConstant.imgBgRectangel,
                        height: 32.h,
                        width: 32.h),
                    Text(surahModel?.surahNumber ?? '1',
                        style: TextStyleHelper.instance.body12SemiBoldPoppins
                            .copyWith(height: 1.5)),
                  ])),
              SizedBox(width: 2.h),
              Expanded(
                  child: Text(surahModel?.surahName ?? 'Al-Fatiha',
                      style: TextStyleHelper.instance.body14SemiBoldPoppins
                          .copyWith(height: 1.43))),
              SizedBox(width: 30.h),
              Text(surahModel?.arabicName ?? '',
                  style: TextStyleHelper.instance.title17RegularSura_names
                      .copyWith(height: 1.0)),
            ])));
  }
}
