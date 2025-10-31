import 'package:flutter/material.dart';
import 'package:adam_s_application/core/app_export.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyleHelper.instance.body14SemiBoldPoppins
          .copyWith(color: appColors.whiteA700),
    );
  }
}
