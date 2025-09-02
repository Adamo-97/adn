import 'package:flutter/widgets.dart';
import 'package:adam_s_application/core/app_export.dart';
import 'package:adam_s_application/widgets/custom_text_field_with_icon.dart';

class ProgressColors {
  final Color completed; // olive green
  final Color current;   // light green
  final Color upcoming;  // white
  const ProgressColors({
    required this.completed,
    required this.current,
    required this.upcoming,
  });
}

/// Paints 5 bars using statuses: "completed" | "current" | "upcoming",
/// and shows a centered counter underneath (e.g. "3/5 prayers completed today.")
class ProgressIndicatorsRow extends StatelessWidget {
  final List<String> statuses; // "completed" | "current" | "upcoming"
  final ProgressColors colors;
  final int completedCount;
  final int totalFard;

  const ProgressIndicatorsRow({
    super.key,
    required this.statuses,
    required this.colors,
    required this.completedCount,
    this.totalFard = 5,
  });

  Color _map(String s) {
    switch (s) {
      case 'completed': return colors.completed;
      case 'current':   return colors.current;
      default:          return colors.upcoming;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Bars row: fixed height, responsive width
        Padding(
          padding: EdgeInsets.all(10.h),
          child: Row(
            children: [
              for (int i = 0; i < statuses.length; i++) ...[
                if (i > 0) SizedBox(width: 10.h),
                bar(_map(statuses[i])),
              ],
            ],
          ),
        ),

        SizedBox(height: 8.h),

        // Counter: responsive (fills width), visually centered within page padding
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: SizedBox(
            width: double.infinity,
            child: CustomTextFieldWithIcon(
              leftIcon: ImageConstant.imgCheck,
              hintText: '$completedCount/$totalFard prayers completed today.',
              textStyle: TextStyleHelper.instance.body15RegularPoppins
                  .copyWith(color: appTheme.white_A700),
            ),
          ),
        ),
      ],
    );
  }
}
