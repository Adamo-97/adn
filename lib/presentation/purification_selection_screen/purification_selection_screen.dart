import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import './widgets/purification_item_widget.dart';
import 'notifier/purification_selection_notifier.dart';

class PurificationSelectionScreen extends ConsumerStatefulWidget {
  const PurificationSelectionScreen({Key? key}) : super(key: key);

  @override
  PurificationSelectionScreenState createState() =>
      PurificationSelectionScreenState();
}

class PurificationSelectionScreenState
    extends ConsumerState<PurificationSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray_900,
        body: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: appTheme.gray_900,
            boxShadow: [
              BoxShadow(
                color: appTheme.black_900_19,
                blurRadius: 40.h,
                offset: Offset(0, 24.h),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildPurificationOptions(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(
        top: 54.h,
        left: 24.h,
        right: 24.h,
      ),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          onTapBackButton(context);
                        },
                        child: CustomImageView(
                          imagePath: ImageConstant.imgBackButton,
                          height: 30.h,
                          width: 30.h,
                        ),
                      ),
                      SizedBox(width: 16.h),
                      Text(
                        'Purification (Ṭahārah)',
                        style: TextStyleHelper.instance.title20BoldPoppins
                            .copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 1.h,
                  width: double.maxFinite,
                  color: appTheme.orange_200,
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPurificationOptions(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: SingleChildScrollView(
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(purificationSelectionNotifier);

            return Column(
              children: [
                _buildMainAblutionCard(),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: PurificationItemWidget(
                        purificationItem: state.purificationItems[1],
                      ),
                    ),
                    SizedBox(width: 10.h),
                    Expanded(
                      child: PurificationItemWidget(
                        purificationItem: state.purificationItems[2],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildMainAblutionCard() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 14.h),
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
            imagePath: ImageConstant.imgWuduIcon,
            height: 48.h,
            width: 48.h,
          ),
          SizedBox(height: 14.h),
          Text(
            'Minor Ablution',
            style: TextStyleHelper.instance.body15RegularPoppins
                .copyWith(color: appTheme.orange_200, height: 1.33),
          ),
          Text(
            'Wuduʾ',
            style: TextStyleHelper.instance.body15RegularPoppins
                .copyWith(color: appTheme.white_A700, height: 1.33),
          ),
        ],
      ),
    );
  }

  /// Navigates back to the previous screen.
  void onTapBackButton(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.prayerTrackerScreen);
  }
}
