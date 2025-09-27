// Add this new widget definition, likely in the same file or a new one.

import 'package:flutter/material.dart';

class HeaderContent extends StatelessWidget {
  final Widget firstChild; // The "For you" text
  final Widget secondChild; // The full Header widget
  final bool showFirst; // true to show "For you", false to show Header

  const HeaderContent({
    required this.firstChild,
    required this.secondChild,
    required this.showFirst,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // The duration and curve should match what's used inside your original Header logic
    const Duration duration = Duration(milliseconds: 400);
    const Curve curve = Curves.easeInOut;

    // We use showFirst to control the animation, where:
    // showFirst = true means "For you" (firstChild) is visible.
    // showFirst = false means Header (secondChild) is visible.

    return SizedBox(
      // Ensure the container has enough height for the transition to occur
      // Max height of the full header transition
      height: 160,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // "For you" content (firstChild)
          AnimatedPositioned(
            duration: duration,
            curve: curve,
            // Slides down to reveal
            top: showFirst ? 0 : -200,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: showFirst ? 1 : 0,
              duration: duration,
              child: AnimatedScale(
                alignment: Alignment.topLeft,
                scale: showFirst ? 1.0 : 0.8, // Shrinks when leaving
                duration: duration,
                curve: curve,
                // Wrap firstChild in Align to match the desired layout in HomeView
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: firstChild,
                ),
              ),
            ),
          ),

          // Header content (secondChild)
          AnimatedPositioned(
            duration: duration,
            curve: curve,
            // Slides up to enter
            top: showFirst ? 200 : 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: showFirst ? 0 : 1,
              duration: duration,
              child: AnimatedScale(
                alignment: Alignment.bottomRight,
                scale: showFirst ? 0.8 : 1.0, // Grows when entering
                duration: duration,
                curve: curve,
                child: secondChild,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
