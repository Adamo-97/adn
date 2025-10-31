import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

/// Head / Notch widget for the Mosque list sheet.
///
/// Responsibilities:
/// - Render the visual notch centered inside a larger tappable head area.
/// - Handle taps and vertical drags on the head and control the
///   provided [DraggableScrollableController].
class MosqueListHead extends StatefulWidget {
  final DraggableScrollableController draggableController;
  final double Function(BuildContext) minSizeBuilder;

  const MosqueListHead({
    super.key,
    required this.draggableController,
    required this.minSizeBuilder,
  });

  @override
  State<MosqueListHead> createState() => _MosqueListHeadState();
}

class _MosqueListHeadState extends State<MosqueListHead> {
  late double _initialDragSize;
  double _dragTotalDy = 0.0;
  DateTime? _dragStartTime;

  double _handleSensitivity(BuildContext ctx) {
    final h = MediaQuery.of(ctx).size.height;
    final computed = 1.1 + (600.0 / h);
    return computed.clamp(1.0, 2.5).toDouble();
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
    final change = -delta / screenHeight * _handleSensitivity(context);
    final newSize = _clampSize(_initialDragSize + change);
    widget.draggableController.jumpTo(newSize);
  }

  double _clampSize(double size) {
    return size.clamp(widget.minSizeBuilder(context), 0.85);
  }

  void _onHandleDragEnd(DragEndDetails details) {
    final currentSize = widget.draggableController.size;
    const snapPoints = [0.15, 0.5, 0.85];

    int nearestIndex = 0;
    double nearestDist = (snapPoints[0] - currentSize).abs();
    for (int i = 1; i < snapPoints.length; i++) {
      final d = (snapPoints[i] - currentSize).abs();
      if (d < nearestDist) {
        nearestDist = d;
        nearestIndex = i;
      }
    }

    final vy = details.velocity.pixelsPerSecond.dy;
    const velocityThreshold = 350.0;
    const distanceThreshold = 8.0;
    const timeThreshold = 250;

    final dragDurationMs = _dragStartTime == null
        ? timeThreshold + 1
        : DateTime.now().difference(_dragStartTime!).inMilliseconds;

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

    if (vy.abs() > velocityThreshold &&
        _dragTotalDy.abs() > distanceThreshold) {
      if (vy < 0) {
        targetIndex = (nearestIndex + 1).clamp(0, snapPoints.length - 1);
      } else {
        targetIndex = (nearestIndex - 1).clamp(0, snapPoints.length - 1);
      }
    } else {
      if (_dragTotalDy < -distanceThreshold) {
        targetIndex = (nearestIndex + 1).clamp(0, snapPoints.length - 1);
      } else if (_dragTotalDy > distanceThreshold) {
        targetIndex = (nearestIndex - 1).clamp(0, snapPoints.length - 1);
      } else {
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
    // Build the larger tappable head area and center the visible notch
    final double headHeight = 14.h + 4.h + 10.h + 12.h;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final current = widget.draggableController.size;
        final snapMin = widget.minSizeBuilder(context);
        const snapInitial = 0.5;
        const snapMax = 0.85;

        if (current <= snapMin + 0.02) {
          widget.draggableController.animateTo(
            snapInitial,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else if ((current - snapInitial).abs() < 0.05) {
          widget.draggableController.animateTo(
            snapMax,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
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
      child: Container(
        height: headHeight,
        width: double.infinity,
        alignment: Alignment.center,
        child: Container(
          width: 45.h,
          height: 4.h,
          decoration: BoxDecoration(
            color: appColors.gray_700,
            borderRadius: BorderRadius.circular(10.h),
          ),
        ),
      ),
    );
  }
}
