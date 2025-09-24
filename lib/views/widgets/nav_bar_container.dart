import 'package:flutter/material.dart';

class NavBarContainer extends StatelessWidget {
  final BorderRadiusGeometry borderRadius;
  final Widget child;
  final double width;

  const NavBarContainer({
    super.key,
    required this.width,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: width,
      height: 68,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(192, 192, 192, 1),
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
