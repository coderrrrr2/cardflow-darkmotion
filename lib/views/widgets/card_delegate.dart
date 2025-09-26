import 'dart:ui';
import 'package:flutter/material.dart';

class ParallaxFlowDelegate extends FlowDelegate {
  final double offsetX;
  final bool isCardExpanded;
  final double swipeProgress;
  final bool isSwipingLeft;

  ParallaxFlowDelegate({
    this.offsetX = 20.0,
    required this.isCardExpanded,
    this.swipeProgress = 0.0,
    this.isSwipingLeft = true,
  });

  // Helper to get the base scale and position for a card at a given stack index
  // Inside ParallaxFlowDelegate class

  // Helper to get the base scale and position for a card at a given stack index
  Offset _getBaseScale(double index) {
    // Define scales for the expanded state (when you want the deck effect)
    final List<Offset> expandedScales = [
      const Offset(
        0.9,
        1.0,
      ), // Top card is slightly scaled down horizontally (0.9)
      const Offset(0.9, 0.94),
      const Offset(0.9, 0.9),
      const Offset(0.9, 0.88),
    ];

    // Define scales for the unexpanded state
    // Top card should be full size (1.0, 1.0)
    // Cards underneath can either be (1.0, 1.0) or slightly scaled down (e.g., 0.98)
    // if you still want a subtle 3D stack, but let's go with full scale for now.
    final List<Offset> unexpandedScales = [
      const Offset(1.0, 1.0), // Full scale when not expanded
      const Offset(1.0, 1.0),
      const Offset(1.0, 1.0),
      const Offset(1.0, 1.0),
    ];

    final List<Offset> baseScales =
        isCardExpanded ? expandedScales : unexpandedScales;

    if (index <= 0) return baseScales.first;
    if (index >= baseScales.length - 1) return baseScales.last;

    final int floor = index.floor();
    final double frac = index - floor;

    // Linearly interpolate between the two closest scale points
    final double baseX =
        lerpDouble(baseScales[floor].dx, baseScales[floor + 1].dx, frac)!;
    final double baseY =
        lerpDouble(baseScales[floor].dy, baseScales[floor + 1].dy, frac)!;

    return Offset(baseX, baseY);
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final total = context.childCount;
    final size = context.size;

    // Handle swipe right (bringing a card back) - REVERTED TO ORIGINAL LOGIC
    if (!isSwipingLeft && swipeProgress > 0.0) {
      int? incomingChildIndex = total - 1;

      // Paint existing cards first
      for (int i = 0; i < total; i++) {
        final childIndex = total - 1 - i;
        final int indexFromTop = (total - 1 - i).clamp(0, total - 1);

        if (indexFromTop > 2) continue;
        if (childIndex == incomingChildIndex) continue;

        double effective = indexFromTop + swipeProgress;
        double opacity = 1.0;

        if (indexFromTop == 2) {
          opacity = 1.0 - swipeProgress;
        }

        double dx = isCardExpanded ? offsetX * effective : 0.0;
        double dy = !isCardExpanded ? 5.0 : effective * 20.0;

        final Offset base = _getBaseScale(effective);
        Map<String, double> scales = {'scaleX': base.dx, 'scaleY': base.dy};

        final transform = Matrix4.translationValues(dx, dy, 0)
          ..scale(scales['scaleX'], scales['scaleY']);

        context.paintChild(childIndex, transform: transform, opacity: opacity);
      }

      // Paint incoming card - ORIGINAL LOGIC RESTORED
      final childIndex = incomingChildIndex;
      final double incomingDir = -1.0; // From right side

      final double dx = _calculateSwipeOffset(
        0.0,
        swipeProgress,
        size.width,
        incomingDir,
      );
      final double dy = _calculateSwipeYOffset(0.0, swipeProgress);

      // REVERTED: Original growth factors (negative values)
      const double baseX = 0.9;
      const double baseY = 1.0;
      const double growthX = -0.1; // REVERTED: Back to negative
      const double growthY = -0.1; // REVERTED: Back to negative
      final double scaleX = baseX - growthX * (1 - swipeProgress);
      final double scaleY = baseY - growthY * (1 - swipeProgress);

      final transform = Matrix4.translationValues(dx, dy, 0)
        ..scale(scaleX, scaleY);

      context.paintChild(childIndex, transform: transform, opacity: 1.0);
      return;
    }

    // Handle idle state and swipe left (keep the improved version)
    _paintIdleAndSwipeLeft(context);
  }

  void _paintIdleAndSwipeLeft(FlowPaintingContext context) {
    final total = context.childCount;
    final size = context.size;

    for (int i = 0; i < total; i++) {
      final childIndex = total - 1 - i;
      final int indexFromTop = (total - 1 - i).clamp(0, total - 1);

      // Optimization: Don't paint cards that are too deep in the stack
      if (indexFromTop > 2 && swipeProgress == 0.0) continue;

      double dx, dy, scaleX, scaleY;

      if (isSwipingLeft && swipeProgress > 0.0) {
        // --- SWIPE LEFT (IMPROVED INTERPOLATION LOGIC) ---
        if (indexFromTop == 0) {
          // The top card simply swipes off-screen
          dx = _calculateSwipeOffset(0, swipeProgress, size.width);
          dy = !isCardExpanded ? 5.0 : 0;
          final startScale = _getBaseScale(0);
          // It shrinks as it moves away
          scaleX =
              lerpDouble(startScale.dx, startScale.dx - 0.1, swipeProgress)!;
          scaleY =
              lerpDouble(startScale.dy, startScale.dy - 0.1, swipeProgress)!;
        } else {
          // Underlying cards interpolate to their new positions
          final double currentIndex = indexFromTop.toDouble();
          final double targetIndex = currentIndex - 1;

          // Interpolate scale
          final startScale = _getBaseScale(currentIndex);
          final endScale = _getBaseScale(targetIndex);
          scaleX = lerpDouble(startScale.dx, endScale.dx, swipeProgress)!;
          scaleY = lerpDouble(startScale.dy, endScale.dy, swipeProgress)!;

          // Interpolate position
          final startDx = isCardExpanded ? offsetX * currentIndex : 0.0;
          final endDx = isCardExpanded ? offsetX * targetIndex : 0.0;
          dx = lerpDouble(startDx, endDx, swipeProgress)!;

          final startDy = !isCardExpanded ? 5.0 : currentIndex * 20.0;
          final endDy = !isCardExpanded ? 5.0 : targetIndex * 20.0;
          dy = lerpDouble(startDy, endDy, swipeProgress)!;
        }
      } else {
        // --- IDLE STATE ---
        final scales = _getBaseScale(indexFromTop.toDouble());
        scaleX = scales.dx;
        scaleY = scales.dy;
        dx = isCardExpanded ? offsetX * indexFromTop : 0.0;
        dy = !isCardExpanded ? 5.0 : indexFromTop * 20.0;
      }

      final transform = Matrix4.translationValues(dx, dy, 0)
        ..scale(scaleX, scaleY);

      context.paintChild(childIndex, transform: transform);
    }
  }

  double _calculateSwipeOffset(
    double indexFromTop,
    double progress,
    double screenWidth, [
    double? customDir,
  ]) {
    final dir = customDir ?? (isSwipingLeft ? -1.0 : 1.0);
    final depthFactor = 0.05 + (0.02 * indexFromTop);
    final maxShift =
        indexFromTop == 0 ? screenWidth : screenWidth * depthFactor;
    final effectiveProgress = isSwipingLeft ? progress : (1.0 - progress);
    return dir * maxShift * effectiveProgress;
  }

  double _calculateSwipeYOffset(double indexFromTop, double progress) {
    if (!isCardExpanded) return 0.0;
    final dir = isSwipingLeft ? -1.0 : 1.0;
    if (indexFromTop == 0) return 0.0;
    return dir * 20.0 * progress;
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  bool shouldRepaint(covariant ParallaxFlowDelegate oldDelegate) {
    return oldDelegate.offsetX != offsetX ||
        oldDelegate.isCardExpanded != isCardExpanded ||
        oldDelegate.swipeProgress != swipeProgress ||
        oldDelegate.isSwipingLeft != isSwipingLeft;
  }
}
