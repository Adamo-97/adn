import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_search_view.dart';
import './widgets/surah_item_widget.dart';
import 'notifier/quran_main_notifier.dart';

class QuranMainScreen extends ConsumerStatefulWidget {
  const QuranMainScreen({Key? key}) : super(key: key);

  @override
  QuranMainScreenState createState() => QuranMainScreenState();
}

class QuranMainScreenState extends ConsumerState<QuranMainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray_900,
        body: Container(
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildHeader(context),
                    _buildSearchSection(context),
                    _buildTabSection(context),
                    _buildSurahItem(context),
                    Spacer(),
                    _buildFloatingButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget - Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 56.h),
      child: Text(
        'Quraan',
        style:
            TextStyleHelper.instance.title20BoldPoppins.copyWith(height: 1.5),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Section Widget - Search Section
  Widget _buildSearchSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10.h,
        left: 24.h,
        right: 24.h,
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(quranMainNotifierProvider);

          return CustomSearchView(
            controller: state.searchController,
            hintText: 'ex: surah name/nr, verse nr.....',
            prefixIconPath: ImageConstant.imgSearch,
            suffixIconPath: ImageConstant.imgVector,
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 40.h,
            ),
            prefixIconSize: Size(32.h, 26.h),
            suffixIconSize: Size(20.h, 26.h),
            onChanged: (value) {
              ref
                  .read(quranMainNotifierProvider.notifier)
                  .updateSearchText(value);
            },
          );
        },
      ),
    );
  }

  /// Section Widget - Tab Section
  Widget _buildTabSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10.h,
        left: 90.h,
        right: 90.h,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 6.h,
        horizontal: 4.h,
      ),
      decoration: BoxDecoration(
        color: appTheme.color195C62,
        borderRadius: BorderRadius.circular(14.h),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(quranMainNotifierProvider);

          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(quranMainNotifierProvider.notifier).selectTab(0);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: (state.selectedTabIndex ?? 0) == 0
                          ? Color(0xFF5C6248)
                          : appTheme.transparentCustom,
                      borderRadius: BorderRadius.circular(12.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgIcons,
                          height: 24.h,
                          width: 22.h,
                        ),
                        SizedBox(width: 4.h),
                        Text(
                          'Surah',
                          style: TextStyleHelper.instance.body15RegularPoppins
                              .copyWith(
                                  color: appTheme.white_A700, height: 1.33),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.h),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(quranMainNotifierProvider.notifier).selectTab(1);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 4.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgIconsWhiteA700,
                          height: 24.h,
                          width: 16.h,
                        ),
                        SizedBox(width: 4.h),
                        Text(
                          'Juz\'',
                          style: TextStyleHelper.instance.body15RegularPoppins
                              .copyWith(
                                  color: appTheme.color7FFFFF, height: 1.33),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Section Widget - Surah Item
  Widget _buildSurahItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 20.h,
        left: 24.h,
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(quranMainNotifierProvider);

          return SurahItemWidget(
            surahModel: state.surahModel,
            onTapSurah: () {
              onTapSurah(context);
            },
          );
        },
      ),
    );
  }

  /// Section Widget - Floating Button
  Widget _buildFloatingButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 84.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgShadowButtom,
            height: 76.h,
            width: double.maxFinite,
            alignment: Alignment.bottomCenter,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(right: 120.h),
              child: CustomIconButton(
                iconPath: ImageConstant.imgGroup1,
                onPressed: () {
                  onTapFloatingButton(context);
                },
                variant: CustomIconButtonVariant.large,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates to surah detail when surah item is tapped.
  void onTapSurah(BuildContext context) {
    // Handle surah selection navigation
  }

  /// Handles floating button action.
  void onTapFloatingButton(BuildContext context) {
    // Handle floating button action
  }
}
