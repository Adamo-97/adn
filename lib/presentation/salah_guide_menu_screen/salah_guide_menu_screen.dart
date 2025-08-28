import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import './models/salah_guide_menu_model.dart';
import './widgets/prayer_guide_grid_item_widget.dart';
import './widgets/prayer_list_item_widget.dart';
import 'notifier/salah_guide_menu_notifier.dart';

class SalahGuideMenuScreen extends ConsumerStatefulWidget {
  const SalahGuideMenuScreen({Key? key}) : super(key: key);

  @override
  SalahGuideMenuScreenState createState() => SalahGuideMenuScreenState();
}

class SalahGuideMenuScreenState extends ConsumerState<SalahGuideMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray_900,
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(24.h),
          child: Column(
            children: [
              SizedBox(height: 14.h),
              _buildHeader(context),
              SizedBox(height: 15.h),
              _buildScrollableContent(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Row(
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
            SizedBox(width: 70.h),
            Text(
              'Salah Guide',
              style: TextStyleHelper.instance.title20BoldPoppins,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          height: 1.h,
          width: double.maxFinite,
          color: appTheme.orange_200,
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildScrollableContent(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            _buildPrayerGuideGrid(context),
            SizedBox(height: 10.h),
            _buildPrayerTypesList(context),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPrayerGuideGrid(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(salahGuideMenuNotifier);

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.h,
            childAspectRatio: 1.0,
          ),
          itemCount: state.prayerGuideItems?.length ?? 0,
          itemBuilder: (context, index) {
            final item = state.prayerGuideItems![index];
            return PrayerGuideGridItemWidget(
              prayerGuideItem: item,
              onTapGuideItem: () {
                onTapGuideItem(context, item);
              },
            );
          },
        );
      },
    );
  }

  /// Section Widget
  Widget _buildPrayerTypesList(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(salahGuideMenuNotifier);

        return Column(
          children: List.generate(
            (state.prayerTypes?.length ?? 0) ~/ 2 +
                ((state.prayerTypes?.length ?? 0) % 2),
            (rowIndex) {
              final startIndex = rowIndex * 2;
              final endIndex =
                  (startIndex + 2 < (state.prayerTypes?.length ?? 0))
                      ? startIndex + 2
                      : state.prayerTypes?.length ?? 0;

              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    if (startIndex < (state.prayerTypes?.length ?? 0))
                      Expanded(
                        child: PrayerListItemWidget(
                          prayerType: state.prayerTypes![startIndex],
                          onTapPrayerType: () {
                            onTapPrayerType(
                                context, state.prayerTypes![startIndex]);
                          },
                        ),
                      ),
                    if (startIndex + 1 < (state.prayerTypes?.length ?? 0)) ...[
                      SizedBox(width: 10.h),
                      Expanded(
                        child: PrayerListItemWidget(
                          prayerType: state.prayerTypes![startIndex + 1],
                          onTapPrayerType: () {
                            onTapPrayerType(
                                context, state.prayerTypes![startIndex + 1]);
                          },
                        ),
                      ),
                    ] else if (startIndex < (state.prayerTypes?.length ?? 0))
                      Expanded(child: SizedBox()),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Navigates back to the previous screen
  void onTapBackButton(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.prayerTrackerScreen);
  }

  /// Handles guide item tap navigation
  void onTapGuideItem(BuildContext context, PrayerGuideItemModel item) {
    // Navigate to specific guide content based on item type
  }

  /// Handles prayer type tap navigation
  void onTapPrayerType(BuildContext context, PrayerTypeModel prayerType) {
    // Navigate to specific prayer type content
  }
}
