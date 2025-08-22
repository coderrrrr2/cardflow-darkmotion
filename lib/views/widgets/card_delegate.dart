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

  @override
  void paintChildren(FlowPaintingContext context) {
    final total = context.childCount;
    final size = context.size;

    for (int i = 0; i < total; i++) {
      final childIndex = total - 1 - i;

      final indexFromTop = (total - 1 - i).clamp(0, total - 1);
      if (indexFromTop > 2) continue; // Only paint top 3 cards

      // Base X offset (for stacked look when expanded)
      double dx = isCardExpanded ? offsetX * indexFromTop : 0.0;
      double dy =
          !isCardExpanded
              ? 5
              : indexFromTop * 20.0; // Vertical offset for stacking

      // Apply swipe parallax offset
      if (swipeProgress > 0.0) {
        dx += _calculateSwipeOffset(indexFromTop, swipeProgress, size.width);
        // Add parallax movement for Y position during swipe
        dy += _calculateSwipeYOffset(indexFromTop, swipeProgress);
      }

      // Enhanced scaling with parallax progression
      final scales = _calculateParallaxScales(indexFromTop, swipeProgress);
      double scaleX = scales['scaleX']!;
      double scaleY = scales['scaleY']!;

      final transform = Matrix4.translationValues(dx, dy, 0)
        ..scale(scaleX, scaleY);

      // Map to the correct child index to ensure proper z-order

      context.paintChild(childIndex, transform: transform);
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

    // Base scales for each card depth
    final baseScales = [
      const Offset(0.9, 1.0), // Top card
      const Offset(0.9, 0.94), // Second card
      const Offset(0.9, 0.9), // Third card
    ];

    // Growth multipliers (how much each card grows with swipe)
    final growthFactors = [
      const Offset(-0.1, -0.1), // Top card shrinks when swiping left
      const Offset(0.0, 0.05), // Second card grows vertically
      const Offset(0.05, 0.05), // Third card subtle growth
    ];

    // Clamp index (so if more than 3 cards, reuse last config)
    final idx = indexFromTop.clamp(0, baseScales.length - 1);

    final base = baseScales[idx];
    final growth = growthFactors[idx];

    // Direction multiplier: -1 when swiping right, +1 when left
    final dir = isSwipingLeft ? 1.0 : -1.0;

    // Apply growth smoothly with swipeProgress
    scaleX = base.dx + (growth.dx * swipeProgress * dir);
    scaleY = base.dy + (growth.dy * swipeProgress * dir);

    return {'scaleX': scaleX, 'scaleY': scaleY};
  }

  double _calculateSwipeOffset(
    int indexFromTop,
    double progress,
    double screenWidth,
  ) {
    // Parallax depth factor: top moves most, deeper cards less
    final depthFactor = 0.05 + (0.02 * indexFromTop);

    // For both left and right swipes, use negative direction to ensure correct movement (left swipe: 0 to -max, right swipe: -max to 0)
    final dir = -1.0;

    // Top card moves full width, others move fractionally
    final maxShift =
        indexFromTop == 0 ? screenWidth : screenWidth * depthFactor;

    // For swipe right, invert progress (since entering)
    final effectiveProgress = isSwipingLeft ? progress : (1.0 - progress);

    return dir * maxShift * effectiveProgress;
  }

  double _calculateSwipeYOffset(int indexFromTop, double progress) {
    if (!isCardExpanded) return 0.0;

    // Each deeper card moves up into previous card’s slot
    // Y shift = -20 * progress * dir
    final dir = isSwipingLeft ? -1.0 : 1.0;

    // Only cards deeper than the top should shift
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
