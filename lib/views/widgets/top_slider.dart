import 'package:animation_practice1/shared/assets.dart';
import 'package:animation_practice1/views/widgets/home_tile.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class TopSlider extends StatefulWidget {
  final bool isExpanded;
  final Function(bool)? onTap;
  const TopSlider({super.key, required this.isExpanded, this.onTap});

  @override
  State<TopSlider> createState() => _TopSliderState();
}

class _TopSliderState extends State<TopSlider> {
  List<HomeTile> tiles = [
    HomeTile(imagePath: tree, title: 'Emma Wallace', description: '13 photos'),
    HomeTile(
      imagePath: greenLeafs,
      title: 'Harry Sans',
      description: '13 photos',
    ),
    HomeTile(imagePath: tree, title: 'Tulip', description: '13 photos'),
    HomeTile(imagePath: tree, title: 'Orchid', description: '13 photos'),
    HomeTile(imagePath: tree, title: 'Lily', description: '13 photos'),
  ];

  List<HomeTile> homeTile = [
    HomeTile(imagePath: tree, title: 'Emma Wallace', description: '13 photos'),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      height: widget.isExpanded ? 600 : 400,

      curve: Curves.easeInOut,
      child: Swiper(
        axisDirection: AxisDirection.right,
        itemCount: widget.isExpanded ? tiles.length : homeTile.length,
        layout: SwiperLayout.STACK,
        loop: false,
        itemWidth: 900,
        itemBuilder: (BuildContext context, int index) {
          final tile = widget.isExpanded ? tiles[index] : homeTile[0];
          return tile.copyWith(
            onTap: () {
              setState(() {
                widget.onTap?.call(!widget.isExpanded);
              });
            },
          );
        },
        // Control swipe animation
        duration: 300, // Animation duration in milliseconds
      ),
    );
  }
}

        //     CustomLayoutOption(
        //         startIndex: -1, // Ensure active card is rendered last (on top)
        //         stateCount: 3, // Show active card + 2 behind
        //       )
        //       ..addTranslate([
        //         Offset(
        //           cardWidth * 0.4,
        //           0.1,
        //         ), // Second next card (farthest back, most offset)
        //         Offset(cardWidth * 0.2, 0.1), // Next card (middle, less offset)
        //         Offset(0, 0), // Active card (centered, on top)
        //       ])
        //       ..addScale([
        //         0.8,
        //         0.9,
        //         1.0,
        //       ], Alignment.bottomCenter), // Second next, next, active card