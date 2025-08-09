import 'package:animation_practice1/shared/shared.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  final bool isExpanded;
  const Header({super.key, required this.isExpanded});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final bool childRepresentsExpanded = child.key == const ValueKey(true);

        final Offset offset =
            childRepresentsExpanded ? const Offset(0, 1) : const Offset(0, -1);

        final tween = Tween<Offset>(begin: offset, end: Offset.zero);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: tween.animate(animation),
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.topCenter,
        key: ValueKey(widget.isExpanded),
        child: SizedBox(
          height: 100, // Ensure both versions take same vertical space
          child:
              widget.isExpanded
                  ? _buildExpandedHeader()
                  : _buildCollapsedHeader(),
        ),
      ),
    );
  }

  Widget _buildCollapsedHeader() {
    return Row(
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
    );
  }

  Widget _buildExpandedHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(text: "collections", fontSize: 16, color: Colors.grey),
            addHeight(4),
            LeadingText(text: "Plants"),
          ],
        ),
        const Spacer(),
        const CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey,
          child: Icon(Icons.file_copy, color: Colors.white),
        ),
        addWidth(20),
        const CircleAvatar(
          radius: 25,
          backgroundColor: Color.fromARGB(255, 39, 39, 39),
          child: Icon(Icons.grid_3x3, color: Colors.white),
        ),
      ],
    );
  }
}
