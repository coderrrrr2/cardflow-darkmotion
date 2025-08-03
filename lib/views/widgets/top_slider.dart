import 'package:animation_practice1/shared/assets.dart';
import 'package:animation_practice1/views/widgets/home_tile.dart';
import 'package:flutter/material.dart';

class TopSlider extends StatefulWidget {
  final bool isExpanded;
  final Function(bool)? onTap;
  const TopSlider({super.key, required this.isExpanded, this.onTap});

  @override
  State<TopSlider> createState() => _TopSliderState();
}

class _TopSliderState extends State<TopSlider> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: widget.isExpanded ? 650 : 400,
      curve: Curves.easeInOut,

      child: CarouselView(
        itemSnapping: true,
        itemExtent: 650,
        onTap: (value) {
          setState(() {
            widget.onTap != null
                ? widget.onTap!(!widget.isExpanded)
                : widget.onTap;
          });
        },
        children: List.generate(widget.isExpanded ? 5 : 1, (index) {
          return HomeTile(
            imagePath: tree,
            title: "Titleuuu $index",
            description: "Description for item $index",
            // onTap: () {
            //   log("is it being tapped");
            //   widget.onTap != null
            //       ? widget.onTap!(!widget.isExpanded)
            //       : widget.onTap;
            // },
          );
        }),
      ),
    );
    // .animate(
    //   target: _animate ? 1 : 0, // toggles animation on tap
    // )
    // .scale(duration: 400.ms, curve: Curves.easeOut);
  }
}
