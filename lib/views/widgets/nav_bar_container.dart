import 'package:flutter/material.dart';

class NavBarContainer extends StatelessWidget {
  final BorderRadiusGeometry borderRadius;
  final Widget child;
  final double beginWidth;
  final double endWidth;

  const NavBarContainer({
    super.key,
    required this.beginWidth,
    required this.endWidth,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: endWidth,
      height: 68,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(192, 192, 192, 1),
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
