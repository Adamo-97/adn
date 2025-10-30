import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../notifier/nearby_mosques_notifier.dart';
import '../notifier/nearby_mosques_state.dart';
import 'mosque_card.dart';
import '../../../widgets/custom_image_view.dart';
import 'mosque_list_head.dart';

class MosqueListSheet extends StatefulWidget {
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
  State<MosqueListSheet> createState() => _MosqueListSheetState();
}

class _MosqueListSheetState extends State<MosqueListSheet> {
  // Drag-handling logic (sensitivity, tap vs drag detection, etc.) has been
  // extracted into `MosqueListHead`. This state class now only manages
  // layout and list rendering for the sheet.

  @override
  void initState() {
    super.initState();
    // Add a listener to print debug info when the sheet size changes.
    widget.draggableController.addListener(_controllerListener);
  }

  @override
  void dispose() {
    widget.draggableController.removeListener(_controllerListener);
    super.dispose();
  }

  void _controllerListener() {
    // Listener retained for future internal updates; no-op to avoid log spam.
  }

  double _minSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double handleHeight = 14.h + 4.h + 10.h;
    // Allow the min size to closely match the handle height. Use a small lower
    // bound to avoid extremely tiny values on very large screens but ensure
    // it's small enough so only the handle is visible when minimized.
    return (handleHeight / screenHeight).clamp(0.02, 0.25);
  }

  @override
  Widget build(BuildContext context) {
    final minSize = _minSize(context);
    // build

    return DraggableScrollableSheet(
      controller: widget.draggableController,
      initialChildSize: 0.5,
      minChildSize: minSize,
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
              // Head widget: extracted the notch/drag/tap logic to a separate
              // widget so the sheet file remains focused on layout.
              MosqueListHead(
                draggableController: widget.draggableController,
                minSizeBuilder: (ctx) => _minSize(ctx),
              ),

              // Mosque list with gradient shadow at bottom. When the sheet is
              // minimized (close to minSize) we intentionally hide the list so
              // only the handle is visible and no card peeks through.
              Expanded(
                child: Builder(builder: (context) {
                  final currentSize = widget.draggableController.isAttached
                      ? widget.draggableController.size
                      : 0.5;
                  final minSizeNow = _minSize(context);
                  final isMinimized = currentSize <= (minSizeNow + 0.005);

                  if (isMinimized) {
                    // Render nothing under the handle when minimized.
                    return const SizedBox.shrink();
                  }

                  return Stack(
                    children: [
                      // List content
                      widget.state.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: appTheme.orange_200,
                              ),
                            )
                          : widget.state.filteredMosques.isEmpty
                              ? _buildEmptyState()
                              : _buildMosqueListView(
                                  widget.state,
                                  widget.notifier,
                                  scrollController,
                                ),

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
                                  appTheme.gray_900.withAlpha(
                                    (0.3 * 255).round(),
                                  ),
                                  appTheme.gray_900.withAlpha(
                                    (0.7 * 255).round(),
                                  ),
                                  appTheme.gray_900,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
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

  Widget _buildMosqueListView(
    NearbyMosquesState state,
    NearbyMosquesNotifier notifier,
    ScrollController scrollController,
  ) {
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
