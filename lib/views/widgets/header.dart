import 'package:animation_practice1/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Header extends StatefulWidget {
  final bool isExpanded;
  const Header({super.key, required this.isExpanded});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return widget.isExpanded
        ? Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                AppText(text: "collections", fontSize: 16, color: Colors.grey),
                addHeight(4),
                LeadingText(text: "Plants"),
              ],
            ),
            Spacer(),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: Icon(Icons.file_copy, color: Colors.white),
            ),
            addWidth(20),
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color.fromARGB(255, 39, 39, 39),
              child: Icon(Icons.grid_3x3, color: Colors.white),
            ),
          ],
        ).animate().slide(begin: Offset(0, 1), end: Offset(0, 0))
        : Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "SUNDAY, SEPTEMBER 7",
                  fontSize: 16,
                  color: Colors.grey,
                ),
                addHeight(4),
                LeadingText(text: "For You"),
              ],
            ),
          ],
        ).animate().slide(begin: Offset(0, -1), end: Offset(0, 0));
  }
}
