import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_field_with_icon.dart';
import './models/prayer_tracker_model.dart';
import './widgets/prayer_action_item_widget.dart';
import './widgets/prayer_row_widget.dart';
import 'notifier/prayer_tracker_notifier.dart';

class PrayerTrackerInitialPage extends ConsumerStatefulWidget {
  const PrayerTrackerInitialPage({Key? key}) : super(key: key);

  @override
  PrayerTrackerInitialPageState createState() =>
      PrayerTrackerInitialPageState();
}

class PrayerTrackerInitialPageState
    extends ConsumerState<PrayerTrackerInitialPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.gray_900,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildPrayerHeader(context),
            SizedBox(height: 20.h),
            _buildPrayerContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.gray_700,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14.h),
          bottomRight: Radius.circular(14.h),
        ),
      ),
      padding: EdgeInsets.all(24.h),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Text(
            'Prayers',
            style: TextStyleHelper.instance.title20BoldPoppins,
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Prayer is Fajr',
                      style: TextStyleHelper.instance.body15RegularPoppins
                          .copyWith(color: appTheme.white_A700),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          '00:00 AM |',
                          style: TextStyleHelper.instance.body12RegularPoppins
                              .copyWith(color: appTheme.orange_200),
                        ),
                        SizedBox(width: 4.h),
                        CustomImageView(
                          imagePath: ImageConstant.imgLocationIcon,
                          height: 8.h,
                          width: 8.h,
                        ),
                        SizedBox(width: 4.h),
                        Text(
                          'Ronneby, SE',
                          style: TextStyleHelper.instance.body12RegularPoppins
                              .copyWith(color: appTheme.orange_200),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgDhuhrIcon,
                height: 42.h,
                width: 42.h,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerContent(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 870.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.h),
              child: Column(
                children: [
                  _buildPrayerActions(context),
                  SizedBox(height: 38.h),
                  _buildCompassSection(context),
                  SizedBox(height: 40.h),
                  _buildPhoneInstructions(context),
                  SizedBox(height: 26.h),
                  _buildProgressIndicators(context),
                  SizedBox(height: 4.h),
                  _buildPrayerStatusInput(context),
                  SizedBox(height: 12.h),
                  _buildDateNavigation(context),
                  SizedBox(height: 16.h),
                  _buildPrayerCalendar(context),
                  SizedBox(height: 14.h),
                  _buildFajrPrayerRow(context),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomImageView(
              imagePath: ImageConstant.imgShadowButtom1,
              height: 76.h,
              width: double.infinity,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 40.h, bottom: 152.h),
              child: CustomIconButton(
                iconPath: ImageConstant.imgGroup10,
                backgroundColor: appTheme.gray_500,
                borderRadius: 28.h,
                height: 56.h,
                width: 56.h,
                padding: EdgeInsets.all(10.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerActions(BuildContext context) {
    final state = ref.watch(prayerTrackerNotifierProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...state.prayerActions.map(
            (action) => PrayerActionItemWidget(
              action: action,
              onTap: () => _onPrayerActionTap(action),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompassSection(BuildContext context) {
    return CustomImageView(
      imagePath: ImageConstant.imgCompassIcon,
      height: 202.h,
      width: 194.h,
    );
  }

  Widget _buildPhoneInstructions(BuildContext context) {
    return Row(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgMobileIcon,
          height: 22.h,
          width: 26.h,
        ),
        SizedBox(width: 24.h),
        Expanded(
          child: Text(
            'Please place your phone on a flat surface',
            style: TextStyleHelper.instance.label10LightPoppins,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicators(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: appTheme.gray_700,
                borderRadius: BorderRadius.circular(4.h),
              ),
            ),
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: appTheme.gray_500,
                borderRadius: BorderRadius.circular(4.h),
              ),
            ),
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: appTheme.white_A700,
                borderRadius: BorderRadius.circular(4.h),
              ),
            ),
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: appTheme.white_A700,
                borderRadius: BorderRadius.circular(4.h),
              ),
            ),
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: appTheme.white_A700,
                borderRadius: BorderRadius.circular(4.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerStatusInput(BuildContext context) {
    return CustomTextFieldWithIcon(
      leftIcon: ImageConstant.imgCheck,
      hintText: '1/5 prayers completed today.',
      textStyle: TextStyleHelper.instance.body15RegularPoppins
          .copyWith(color: appTheme.white_A700),
    );
  }

  Widget _buildDateNavigation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgArrowPrev,
          height: 24.h,
          width: 24.h,
        ),
        Text(
          'Today, 00/00/0000',
          style: TextStyleHelper.instance.title18SemiBoldPoppins
              .copyWith(color: appTheme.orange_200),
        ),
        CustomImageView(
          imagePath: ImageConstant.imgArrowNext,
          height: 24.h,
          width: 24.h,
        ),
      ],
    );
  }

  Widget _buildPrayerCalendar(BuildContext context) {
    final state = ref.watch(prayerTrackerNotifierProvider);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: appTheme.gray_700,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.h),
              topRight: Radius.circular(10.h),
            ),
          ),
          padding: EdgeInsets.all(12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...state.weekDays.map(
                (day) => Text(
                  day,
                  style: TextStyleHelper.instance.body15RegularPoppins
                      .copyWith(color: appTheme.orange_200),
                ),
              ),
            ],
          ),
        ),
        ...state.prayerRows.map(
          (row) => PrayerRowWidget(
            row: row,
            isFirstRow: state.prayerRows.indexOf(row) == 0,
            isLastRow:
                state.prayerRows.indexOf(row) == state.prayerRows.length - 1,
          ),
        ),
      ],
    );
  }

  Widget _buildFajrPrayerRow(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.gray_700,
        borderRadius: BorderRadius.circular(20.h),
      ),
      padding: EdgeInsets.all(14.h),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgCheckedIcon,
            height: 24.h,
            width: 24.h,
          ),
          SizedBox(width: 10.h),
          Text(
            'Fajr',
            style: TextStyleHelper.instance.body15RegularPoppins
                .copyWith(color: appTheme.white_A700),
          ),
          SizedBox(width: 16.h),
          Text(
            '00:00',
            style: TextStyleHelper.instance.body15RegularPoppins
                .copyWith(color: appTheme.white_A700),
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgNotificationOn,
            height: 26.h,
            width: 24.h,
          ),
        ],
      ),
    );
  }

  void _onPrayerActionTap(PrayerActionModel action) {
    if (action.navigateTo != null) {
      switch (action.navigateTo) {
        case '576:475':
          NavigatorService.pushNamed(AppRoutes.purificationSelectionScreen);
          break;
        case '508:307':
          NavigatorService.pushNamed(AppRoutes.salahGuideMenuScreen);
          break;
      }
    }
  }
}
