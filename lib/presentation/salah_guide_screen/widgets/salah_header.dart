import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

class SalahHeaderWithSearch extends StatefulWidget {
  const SalahHeaderWithSearch({
    super.key,
    required this.topInset,
    required this.searchController,
    this.title = 'Salah Guide',
  });

  final double topInset;
  final TextEditingController searchController;
  final String title;

  @override
  State<SalahHeaderWithSearch> createState() => _SalahHeaderWithSearchState();
}

class _SalahHeaderWithSearchState extends State<SalahHeaderWithSearch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation =
      const AlwaysStoppedAnimation<double>(0);
  bool _exceeded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    // Shake sequence that always ends back at 0
    _offsetAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _handleChange(String value) {
    if (value.length > 35) {
      // Trim to 35 and give feedback
      widget.searchController.text = value.substring(0, 35);
      widget.searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.searchController.text.length),
      );

      if (!_exceeded) {
        setState(() => _exceeded = true);
        _controller.forward(from: 0); // trigger jiggle
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => _exceeded = false);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.h, widget.topInset + 16.h, 20.h, 20.h),
      decoration: BoxDecoration(
        color: appTheme.gray_900,
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray_700.withAlpha((0.3 * 255).round()),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Centered title
          Text(
            widget.title,
            style: TextStyleHelper.instance.title20BoldPoppins.copyWith(
              color: appTheme.whiteA700,
              fontSize: 22.fSize,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),

          // Search bar with jiggle + max length feedback
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_offsetAnimation.value, 0),
                child: child,
              );
            },
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: appTheme.gray_700.withAlpha((0.3 * 255).round()),
                borderRadius: BorderRadius.circular(12.h),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.h),
              child: Row(
                children: [
                  // Search icon
                  CustomImageView(
                    imagePath: ImageConstant.imgSearch,
                    color: appTheme.gray_600,
                  ),
                  SizedBox(width: 10.h),

                  // Input field
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _offsetAnimation,
                      builder: (context, child) => Transform.translate(
                          offset: Offset(_offsetAnimation.value, 0),
                          child: child),
                      child: TextField(
                        controller: widget.searchController,
                        onChanged: _handleChange,
                        style: TextStyleHelper.instance.body15RegularPoppins
                            .copyWith(
                          color: _exceeded
                              ? appTheme.whiteA700
                              : appTheme.whiteA700,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Search for a title or keyword',
                          hintStyle: TextStyleHelper
                              .instance.body15RegularPoppins
                              .copyWith(
                            color: appTheme.gray_600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
