import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../notifier/nearby_mosques_notifier.dart';
import '../notifier/nearby_mosques_state.dart';
import 'mosque_card.dart';
import '../../../widgets/custom_image_view.dart';

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
  late double _initialDragSize;
  // Accumulate total drag delta during a single drag gesture so we can
  // distinguish a short tap from a meaningful drag/fling.
  double _dragTotalDy = 0.0;
  // Compute a sensitivity multiplier for handle drags that's adaptive to
  // screen height. Smaller devices get a larger multiplier so the handle
  // feels more responsive; larger screens get a milder multiplier.
  double _handleSensitivity(BuildContext ctx) {
    final h = MediaQuery.of(ctx).size.height;
    // Base value plus a factor inversely proportional to height. Clamp to a
    // reasonable range so it's always predictable.
    final computed = 1.1 + (600.0 / h);
    return computed.clamp(1.0, 2.5).toDouble();
  }

  // Time when the current drag started; used to distinguish quick taps from
  // sustained drags.
  DateTime? _dragStartTime;

  @override
  void initState() {
    super.initState();
    // Add a listener to print debug info when the sheet size changes.
    widget.draggableController.addListener(_controllerListener);
    // Don't read controller.size synchronously here — it isn't attached to the sheet
    // until the first frame. Defer reading size until after first layout.
    WidgetsBinding.instance.addPostFrameCallback(_tryInitController);
  }

  void _tryInitController(Duration _) {
    if (!mounted) return;
    if (widget.draggableController.isAttached) {
      _initialDragSize = widget.draggableController.size;
    } else {
      // Not attached yet; try again on next frame.
      WidgetsBinding.instance.addPostFrameCallback(_tryInitController);
    }
  }

  @override
  void dispose() {
    widget.draggableController.removeListener(_controllerListener);
    super.dispose();
  }

  void _controllerListener() {
    // Listener retained for future internal updates; no-op to avoid log spam.
  }

  double _clampSize(double size) {
    return size.clamp(_minSize(context), 0.85);
  }

  double _minSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double handleHeight = 14.h + 4.h + 10.h;
    // Allow the min size to closely match the handle height. Use a small lower
    // bound to avoid extremely tiny values on very large screens but ensure
    // it's small enough so only the handle is visible when minimized.
    return (handleHeight / screenHeight).clamp(0.02, 0.25);
  }

  void _onHandleDragStart(DragStartDetails details) {
    _initialDragSize = widget.draggableController.size;
    _dragTotalDy = 0.0;
    _dragStartTime = DateTime.now();
  }

  void _onHandleDragUpdate(DragUpdateDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final delta = details.delta.dy;
    _dragTotalDy += delta;
    // Negative delta (drag up) should increase size; positive (drag down) decrease
    // Use the initial size as the base so repeated updates don't accumulate incorrectly.
    // Apply sensitivity multiplier so the handle is more responsive to user drags.
    final change = -delta / screenHeight * _handleSensitivity(context);
    final newSize = _clampSize(_initialDragSize + change);
    // jumpTo provides immediate response during drag
    widget.draggableController.jumpTo(newSize);
    // immediate jump during an interactive drag
  }

  void _onHandleDragEnd(DragEndDetails details) {
    final currentSize = widget.draggableController.size;
    // Snap points in ascending order
    const snapPoints = [0.15, 0.5, 0.85];

    // Find the index of the nearest snap point to the current size
    int nearestIndex = 0;
    double nearestDist = (snapPoints[0] - currentSize).abs();
    for (int i = 1; i < snapPoints.length; i++) {
      final d = (snapPoints[i] - currentSize).abs();
      if (d < nearestDist) {
        nearestDist = d;
        nearestIndex = i;
      }
    }

    // Direction & thresholds
    final vy = details.velocity.pixelsPerSecond.dy;
    const velocityThreshold = 350.0; // more human-friendly threshold
    const distanceThreshold = 8.0; // logical pixels (smaller to be responsive)
    const timeThreshold = 250; // milliseconds

    final dragDurationMs = _dragStartTime == null
        ? timeThreshold + 1
        : DateTime.now().difference(_dragStartTime!).inMilliseconds;

    // Short quick taps (very little movement + quick) -> go to default (middle)
    if (_dragTotalDy.abs() < distanceThreshold &&
        dragDurationMs < timeThreshold) {
      const snapInitial = 0.5;
      widget.draggableController.animateTo(
        snapInitial,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
      return;
    }

    int targetIndex = nearestIndex;

    // If the gesture was a fling (velocity + distance), move one step in the
    // direction of the fling. vy < 0 => fling up (expand), vy > 0 => fling down.
    if (vy.abs() > velocityThreshold &&
        _dragTotalDy.abs() > distanceThreshold) {
      if (vy < 0) {
        // fling up -> increase index by one step
        targetIndex = (nearestIndex + 1).clamp(0, snapPoints.length - 1);
      } else {
        // fling down -> decrease index by one step
        targetIndex = (nearestIndex - 1).clamp(0, snapPoints.length - 1);
      }
    } else {
      // Not a fling: use the net drag direction to move one step. Negative
      // _dragTotalDy means upward movement (expand).
      if (_dragTotalDy < -distanceThreshold) {
        targetIndex = (nearestIndex + 1).clamp(0, snapPoints.length - 1);
      } else if (_dragTotalDy > distanceThreshold) {
        targetIndex = (nearestIndex - 1).clamp(0, snapPoints.length - 1);
      } else {
        // If movement was tiny but not a tap (e.g., slow micro-move), snap to nearest
        targetIndex = nearestIndex;
      }
    }

    final target = snapPoints[targetIndex.clamp(0, snapPoints.length - 1)];
    widget.draggableController.animateTo(
      target,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
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
              // Drag handle — make the entire head area (not just the small
              // visual notch) interactive. This expands the tappable/draggable
              // region so users can tap or drag anywhere across the head to
              // control the sheet.
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // Tapping the handle should toggle between minimized -> default -> expanded.
                  final current = widget.draggableController.size;
                  final snapMin = _minSize(context);
                  const snapInitial = 0.5;
                  const snapMax = 0.85;

                  if (current <= snapMin + 0.02) {
                    // From minimized -> go to default (initial)
                    widget.draggableController.animateTo(
                      snapInitial,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  } else if ((current - snapInitial).abs() < 0.05) {
                    // From default -> expand fully
                    widget.draggableController.animateTo(
                      snapMax,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  } else {
                    // Otherwise, go to default
                    widget.draggableController.animateTo(
                      snapInitial,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                },
                onVerticalDragStart: _onHandleDragStart,
                onVerticalDragUpdate: _onHandleDragUpdate,
                onVerticalDragEnd: _onHandleDragEnd,
                // Provide a larger tappable area: include the vertical padding
                // around the notch and some extra head space so taps slightly
                // above/below the notch still register. The visual notch remains
                // centered inside this head region.
                child: LayoutBuilder(builder: (context, constraints) {
                  // Calculate a head height that includes the top padding used
                  // previously plus a small extra touch zone.
                  final double headHeight = 14.h + 4.h + 10.h + 12.h;
                  return Container(
                    height: headHeight,
                    width: double.infinity,
                    alignment: Alignment.center,
                    // The slim visible notch stays centered inside this area.
                    child: Container(
                      width: 45.h,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: appTheme.gray_700,
                        borderRadius: BorderRadius.circular(10.h),
                      ),
                    ),
                  );
                }),
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
