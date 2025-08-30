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

  Offset _getBaseScale(double index) {
    final List<Offset> baseScales = [
      const Offset(0.9, 1.0),
      const Offset(0.9, 0.94),
      const Offset(0.9, 0.9),
      const Offset(0.9, 0.88),
    ];

    if (index >= baseScales.length - 1) {
      return baseScales.last;
    }

    final int floor = index.floor();
    final double frac = index - floor;

    final double baseX =
        baseScales[floor].dx +
        frac * (baseScales[floor + 1].dx - baseScales[floor].dx);
    final double baseY =
        baseScales[floor].dy +
        frac * (baseScales[floor + 1].dy - baseScales[floor].dy);

    return Offset(baseX, baseY);
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final total = context.childCount;
    final size = context.size;

    final double dir = isSwipingLeft ? -1.0 : 1.0;

    int? incomingChildIndex;
    if (swipeProgress > 0.0 && !isSwipingLeft) {
      incomingChildIndex = total - 1;
    }

    for (int i = 0; i < total; i++) {
      final childIndex = total - 1 - i;
      final int indexFromTop = (total - 1 - i).clamp(0, total - 1);

      if (indexFromTop > 2 && swipeProgress == 0.0) continue;
      if (childIndex == incomingChildIndex) continue;

      double effective = indexFromTop.toDouble();
      double opacity = 1.0;

      if (swipeProgress > 0.0 && !isSwipingLeft) {
        effective = indexFromTop + swipeProgress;
        if (indexFromTop == 2) {
          opacity = 1.0 - swipeProgress;
        }
      }

      double dx = isCardExpanded ? offsetX * effective : 0.0;
      double dy = !isCardExpanded ? 5.0 : effective * 20.0;

      if (swipeProgress > 0.0 && isSwipingLeft) {
        dx += _calculateSwipeOffset(
          indexFromTop.toDouble(),
          swipeProgress,
          size.width,
        );
        dy += _calculateSwipeYOffset(indexFromTop.toDouble(), swipeProgress);
      }

      Map<String, double> scales;
      if (isSwipingLeft) {
        scales = _calculateParallaxScales(indexFromTop, swipeProgress);
      } else {
        final Offset base = _getBaseScale(effective);
        scales = {'scaleX': base.dx, 'scaleY': base.dy};
      }

      final transform = Matrix4.translationValues(dx, dy, 0)
        ..scale(scales['scaleX'], scales['scaleY']);

      context.paintChild(childIndex, transform: transform, opacity: opacity);
    }

    if (incomingChildIndex != null) {
      final childIndex = incomingChildIndex;
      final double incomingDir = -dir; // Flip for from-left

      final double dx = _calculateSwipeOffset(
        0.0,
        swipeProgress,
        size.width,
        incomingDir,
      );
      final double dy = _calculateSwipeYOffset(0.0, swipeProgress);

      // Incoming starts large, shrinks to top base
      const double baseX = 0.9;
      const double baseY = 1.0;
      const double growthX = -0.1;
      const double growthY = -0.1;
      final double scaleX = baseX - growthX * (1 - swipeProgress);
      final double scaleY = baseY - growthY * (1 - swipeProgress);

      final transform = Matrix4.translationValues(dx, dy, 0)
        ..scale(scaleX, scaleY);

      context.paintChild(childIndex, transform: transform, opacity: 1.0);
    }
  }

  Map<String, double> _calculateParallaxScales(
    int indexFromTop,
    double swipeProgress,
  ) {
    double scaleX = 1.0;
    double scaleY = 1.0;
    if (!isCardExpanded) {
      return {'scaleX': scaleX, 'scaleY': scaleY};
    }

    final scales = _getBaseScale(indexFromTop.toDouble());
    final List<Offset> growthFactors = [
      const Offset(-0.1, -0.1),
      const Offset(0.0, 0.05),
      const Offset(0.05, 0.05),
    ];

    final double scaleDir = isSwipingLeft ? 1.0 : -1.0;

    final int idx = indexFromTop.clamp(0, growthFactors.length - 1);

    final Offset growth = growthFactors[idx];

    return {
      'scaleX': scales.dx + (growth.dx * swipeProgress * scaleDir),
      'scaleY': scales.dy + (growth.dy * swipeProgress * scaleDir),
    };
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
