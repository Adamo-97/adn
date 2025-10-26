import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/widgets/custom_image_view.dart';

class QiblaPanel extends StatelessWidget {
  final bool isOpen;
  const QiblaPanel({super.key, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, anim) => SizeTransition(
        sizeFactor: anim,
        axisAlignment: -1.0,
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: !isOpen
          ? const SizedBox.shrink(key: ValueKey('qibla-off'))
          : Column(
              key: const ValueKey('qibla-on'),
              children: const [
                _QiblaSpacingTop(),
                _Compass(),
                _QiblaSpacingBetween(),
                _PhoneInstructions(),
              ],
            ),
    );
  }
}

class _QiblaSpacingTop extends StatelessWidget {
  const _QiblaSpacingTop();
  @override
  Widget build(BuildContext context) => SizedBox(height: 28.h);
}

class _QiblaSpacingBetween extends StatelessWidget {
  const _QiblaSpacingBetween();
  @override
  Widget build(BuildContext context) => SizedBox(height: 16.h);
}

class _Compass extends StatelessWidget {
  const _Compass();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: CustomImageView(
        imagePath: ImageConstant.imgCompassIcon,
        height: 202.h,
        width: 194.h,
      ),
    );
  }
}

class _PhoneInstructions extends StatelessWidget {
  const _PhoneInstructions();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // centered row
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgMobileIcon,
          height: 22.h,
          width: 26.h,
        ),
        SizedBox(width: 12.h),
        Flexible(
          child: Text(
            'Please place your phone on a flat surface',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyleHelper.instance.label10LightPoppins
                .copyWith(color: appTheme.white_A700),
          ),
        ),
      ],
    );
  }
}
