import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_search_view.dart';
import './models/azkhar_category_model.dart';
import './widgets/azkhar_category_item_widget.dart';
import 'notifier/azkhar_categories_notifier.dart';

class AzkharCategoriesScreen extends ConsumerStatefulWidget {
  const AzkharCategoriesScreen({Key? key}) : super(key: key);

  @override
  AzkharCategoriesScreenState createState() => AzkharCategoriesScreenState();
}

class AzkharCategoriesScreenState
    extends ConsumerState<AzkharCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray_900,
        body: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              child: Column(
                children: [
                  _buildMainContent(context),
                  _buildFloatingIcon(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildMainContent(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(
              top: 44.h,
              left: 24.h,
              right: 24.h,
            ),
            decoration: BoxDecoration(
              color: appTheme.gray_900,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    'Azkhar',
                    style: TextStyleHelper.instance.title20BoldPoppins
                        .copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(
              top: 10.h,
              left: 24.h,
              right: 24.h,
            ),
            child: CustomSearchView(
              hintText: 'Placeholder',
              prefixIconPath: ImageConstant.imgSearchGray500,
              suffixIconPath: ImageConstant.imgAddicon,
              contentPadding: EdgeInsets.symmetric(
                vertical: 6.h,
                horizontal: 40.h,
              ),
              prefixIconSize: Size(32.h, 34.h),
              suffixIconSize: Size(38.h, 34.h),
            ),
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(top: 14.h),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 25.h),
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                    color: appTheme.gray_500,
                    border: Border.all(
                      color: appTheme.gray_700,
                      width: 3.h,
                    ),
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          'My Azkhar',
                          style: TextStyleHelper.instance.title20BoldPoppins
                              .copyWith(
                                  color: appTheme.orange_200, height: 1.5),
                        ),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgFavoriteIconPlaceholder,
                        height: 30.h,
                        width: 30.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                _buildCategoriesGrid(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCategoriesGrid(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(azkharCategoriesNotifier);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 25.h),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 17.h,
              mainAxisSpacing: 10.h,
              childAspectRatio: 1.2,
            ),
            itemCount: state.categories?.length ?? 0,
            itemBuilder: (context, index) {
              final category = state.categories![index];
              return AzkharCategoryItemWidget(
                category: category,
                onTapCategory: () {
                  onTapCategory(context, category);
                },
              );
            },
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildFloatingIcon(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 84.h,
      margin: EdgeInsets.only(top: 232.h),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgShadowButtom76x374,
            height: 76.h,
            width: double.maxFinite,
            alignment: Alignment.bottomCenter,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 120.h),
              child: CustomIconButton(
                iconPath: ImageConstant.imgGroup5,
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

  /// Navigates to category details screen
  void onTapCategory(BuildContext context, AzkharCategoryModel category) {
    // Handle category navigation based on category type
  }

  /// Handles floating button press
  void onTapFloatingButton(BuildContext context) {
    // Handle floating action button press
  }
}
