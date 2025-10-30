import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../notifier/nearby_mosques_notifier.dart';
import '../notifier/nearby_mosques_state.dart';
import 'mosque_card.dart';
import '../../../widgets/custom_image_view.dart';

class MosqueListSheet extends StatelessWidget {
  final NearbyMosquesState state;
  final NearbyMosquesNotifier notifier;
  final DraggableScrollableController draggableController;

  const MosqueListSheet({
    super.key,
    required this.state,
    required this.notifier,
    required this.draggableController,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: draggableController,
      initialChildSize: 0.5,
      minChildSize: 0.15,
      maxChildSize: 0.85,
      snap: true,
      snapSizes: const [0.15, 0.5, 0.85],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: appTheme.gray_900,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(13.h),
              topRight: Radius.circular(13.h),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.25 * 255).round()),
                blurRadius: 4,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                child: Container(
                  width: 45.h,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: appTheme.gray_700,
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                ),
              ),

              // Mosque list with gradient shadow at bottom
              Expanded(
                child: Stack(
                  children: [
                    // List content
                    state.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: appTheme.orange_200,
                            ),
                          )
                        : state.filteredMosques.isEmpty
                            ? _buildEmptyState()
                            : _buildMosqueListView(
                                state, notifier, scrollController),

                    // Bottom gradient shadow
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: Container(
                          height: 45.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.4, 0.7, 1.0],
                              colors: [
                                appTheme.gray_900.withAlpha(0),
                                appTheme.gray_900
                                    .withAlpha((0.3 * 255).round()),
                                appTheme.gray_900
                                    .withAlpha((0.7 * 255).round()),
                                appTheme.gray_900,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgMosqueNavIcon,
            height: 64.h,
            width: 64.h,
            color: appTheme.gray_500.withAlpha((0.5 * 255).round()),
          ),
          SizedBox(height: 16.h),
          Text(
            'No mosques found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: appTheme.whiteA700.withAlpha((0.7 * 255).round()),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search or location',
            style: theme.textTheme.bodySmall?.copyWith(
              color: appTheme.whiteA700.withAlpha((0.5 * 255).round()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMosqueListView(NearbyMosquesState state,
      NearbyMosquesNotifier notifier, ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      itemCount: state.filteredMosques.length,
      padding: EdgeInsets.only(
        left: 15.h,
        right: 15.h,
        top: 0,
        bottom: 76.h + 20.h,
      ),
      itemBuilder: (context, index) {
        final mosque = state.filteredMosques[index];
        final isExpanded = state.expandedMosqueId == mosque.id;

        return MosqueCard(
          mosque: mosque,
          isExpanded: isExpanded,
          onTap: () => notifier.toggleMosqueExpansion(mosque.id),
          onMapTap: () => notifier.openMosqueInMap(mosque),
          onSearchGoogle: () => notifier.searchGoogleForMosque(mosque),
        );
      },
    );
  }
}
