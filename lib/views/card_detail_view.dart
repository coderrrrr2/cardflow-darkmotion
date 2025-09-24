import 'package:animation_practice1/model/home_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CardDetailView extends StatefulWidget {
  final HomeSection section;
  const CardDetailView({super.key, required this.section});

  @override
  State<CardDetailView> createState() => _CardDetailViewState();
}

class _CardDetailViewState extends State<CardDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card Detail')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero-wrapped Container with the first card's image
                Hero(
                  tag:
                      widget.section.cardList.isNotEmpty
                          ? 'hero-${widget.section.cardList.first.key}'
                          : 'hero-default',
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          widget.section.cardList.isNotEmpty
                              ? widget.section.cardList.first.imagePath
                              : 'assets/images/placeholder.png', // Fallback image
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Location text
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.section.location,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // SliverMasonryGrid for detailsCard images with staggered animations
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: AnimationLimiter(
              child: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childCount: widget.section.detailsCard.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: 2,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            widget.section.detailsCard[index],
                            fit: BoxFit.cover,
                            height:
                                (index % 3 + 2) *
                                100.0, // Varying heights for masonry effect
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  height: (index % 3 + 2) * 100.0,
                                  color: Colors.grey,
                                  child: const Icon(Icons.error),
                                ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
