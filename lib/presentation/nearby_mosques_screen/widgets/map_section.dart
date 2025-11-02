import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

class MapSection extends StatelessWidget {
  const MapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Map placeholder
          CustomImageView(
            imagePath: ImageConstant.imgMapPlaceholder,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 107.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    appColors.transparentCustom,
                    appColors.gray_900.withAlpha((0.3 * 255).round()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
