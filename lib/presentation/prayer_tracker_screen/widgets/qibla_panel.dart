import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

class QiblaPanel extends StatelessWidget {
  const QiblaPanel({super.key, required this.onToggle});
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('qibla-open'),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: appTheme.gray_700,
        borderRadius: BorderRadius.circular(10.h),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Qibla',
                style: TextStyleHelper.instance.title18SemiBoldPoppins
                    .copyWith(color: appTheme.orange_200),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onToggle,
                child: CustomImageView(
                  imagePath: ImageConstant.imgArrowNext, // collapse icon
                  height: 24.h,
                  width: 24.h,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgCompassIcon,
                height: 120.h,
                width: 120.h,
              ),
              SizedBox(width: 12.h),
              Flexible(
                child: Text(
                  'Please place your phone on a flat surface',
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.instance.label10LightPoppins,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget Collapsed({Key? key, required VoidCallback onToggle}) {
    return _QiblaCollapsed(key: key, onToggle: onToggle);
  }
}

class _QiblaCollapsed extends StatelessWidget {
  const _QiblaCollapsed({super.key, required this.onToggle});
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('qibla-closed'),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: appTheme.gray_700,
        borderRadius: BorderRadius.circular(10.h),
      ),
      child: Row(
        children: [
          Text(
            'Qibla',
            style: TextStyleHelper.instance.title18SemiBoldPoppins
                .copyWith(color: appTheme.orange_200),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onToggle,
            child: CustomImageView(
              imagePath: ImageConstant.imgArrowNext,
              height: 24.h,
              width: 24.h,
            ),
          ),
        ],
      ),
    );
  }
}
