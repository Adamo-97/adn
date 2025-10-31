import 'package:flutter/widgets.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/widgets/custom_text_field_with_icon.dart';

class ProgressColors {
  final Color completed; // gold when used with filled bg
  final Color current; // keep your existing
  final Color upcoming; // white
  const ProgressColors({
    required this.completed,
    required this.current,
    required this.upcoming,
  });
}

/// Bars + centered counter. Optionally wraps everything in a rounded filled card.
class ProgressIndicatorsRow extends StatelessWidget {
  final List<String> statuses; // "completed" | "current" | "upcoming"
  final ProgressColors colors;
  final int completedCount;
  final int totalFard;

  final bool filled; // wrap in a bg container
  final Color? backgroundColor; // defaults to olive (your theme token)
  final double radius; // card radius
  final EdgeInsets? cardPadding; // inner padding of the card

  final bool fullBleed;

  const ProgressIndicatorsRow({
    super.key,
    required this.statuses,
    required this.colors,
    required this.completedCount,
    this.totalFard = 5,
    this.filled = false,
    this.backgroundColor,
    this.radius = 20, // will be scaled with .h
    this.cardPadding, // default provided below
    this.fullBleed = false,
  });

  Color _map(String s) {
    switch (s) {
      case 'completed':
        return colors.completed; // gold
      case 'current':
        return colors.current; // keep as-is
      default:
        return colors.upcoming; // white
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bar(Color c) => Expanded(
          child: Container(
            height: 8.h,
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(4.h),
            ),
          ),
        );

    // Content (bars + counter)
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Bars row — trimmed bottom to sit closer to the counter
        Padding(
          padding: EdgeInsets.fromLTRB(10.h, 10.h, 10.h, 2.h),
          child: Row(
            children: [
              for (int i = 0; i < statuses.length; i++) ...[
                if (i > 0) SizedBox(width: 10.h),
                bar(_map(statuses[i])),
              ],
            ],
          ),
        ),
        SizedBox(height: 4.h),
        // Counter: fills width, centered by parent padding
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: SizedBox(
            width: double.infinity,
            child: CustomTextFieldWithIcon(
              leftIcon: ImageConstant.imgCheck,
              hintText: '$completedCount/$totalFard prayers completed today.',
              textStyle: TextStyleHelper.instance.body15RegularPoppins
                  .copyWith(color: appColors.whiteA700),
            ),
          ),
        ),
      ],
    );

    if (!filled) return content;

    // Filled card wrapper (olive bg)
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? appColors.gray_700, // your olive card bg
        borderRadius: BorderRadius.circular(radius.h),
      ),
      padding: cardPadding ?? EdgeInsets.all(12.h),
      child: content,
    );
  }
}
