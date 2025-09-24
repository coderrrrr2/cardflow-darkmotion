import 'package:flutter/material.dart';

Widget addHeight(double height) {
  return SizedBox(height: height);
}

Widget addWidth(double width) {
  return SizedBox(width: width);
}

Widget addHeightAnimated(double height) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 400),

    curve: Curves.easeInOut,
    height: height,
  );
}

double getScreenHeight(BuildContext context) {
  double height = MediaQuery.of(context).size.height;

  var padding = MediaQuery.of(context).padding;
  return height - padding.top - padding.bottom;
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
