import 'package:animation_practice1/shared/assets.dart';
import 'package:animation_practice1/viewmodel/home_viewmodel.dart';
import 'package:animation_practice1/views/widgets/home_tile.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopSlider extends ConsumerWidget {
  const TopSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<HomeTile> tiles = [
      HomeTile(
        imagePath: tree,
        title: 'Emma Wallace',
        description: '13 photos',
      ),
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
      HomeTile(
        imagePath: tree,
        title: 'Emma Wallace',
        description: '13 photos',
      ),
    ];

    final isCardExpanded = ref.watch(
      homeProvider.select((state) => state.isCardExpanded),
    );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      height: isCardExpanded ? 600 : 400,
      curve: Curves.easeInOut,
      child: Swiper(
        axisDirection: AxisDirection.right,
        itemCount: isCardExpanded ? tiles.length : homeTile.length,
        layout: SwiperLayout.STACK,
        loop: false,
        itemWidth: 900,
        itemBuilder: (BuildContext context, int index) {
          final tile = isCardExpanded ? tiles[index] : homeTile[0];
          return tile.copyWith(
            onTap: () {
              ref.read(homeProvider.notifier).toggleExpanded();
            },
          );
        },
        duration: 300,
      ),
    );
  }
}
