import 'package:animation_practice1/model/home_section.dart';
import 'package:animation_practice1/shared/shared.dart';
import 'package:animation_practice1/views/widgets/home_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CardDetailView extends StatefulWidget {
  final HomeSection section;
  final HomeTile homeTile;
  final int index;

  const CardDetailView({
    super.key,
    required this.section,
    required this.homeTile,
    required this.index,
  });

  @override
  State<CardDetailView> createState() => _CardDetailViewState();
}

class _CardDetailViewState extends State<CardDetailView>
    with SingleTickerProviderStateMixin {
  bool _showBackButton = false;

  static const heroAnimationDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    // Show back button only after hero animation completes
    Future.delayed(heroAnimationDuration, () {
      if (mounted) setState(() => _showBackButton = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.homeTile.data;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Top hero header
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,

            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                bool collapsed =
                    constraints.biggest.height <= kToolbarHeight + 80;

                if (collapsed) {
                  return Container(
                    color: Colors.black87,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SafeArea(
                      child: Row(
                        children: [
                          if (_showBackButton)
                            const BackButton(color: Colors.white),
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage(data.userImage),
                          ),
                          addWidth(15),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: data.title,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              addHeight(3),
                              AppText(
                                text: data.description,
                                fontSize: 13,
                                color: Colors.white70,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return FlexibleSpaceBar(
                    background: Hero(
                      tag: 'card_${data.key}',
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(data.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            addHeight(40),
                            if (_showBackButton)
                              const BackButton(color: Colors.white),
                            const Spacer(),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 37,
                                  backgroundImage: AssetImage(data.userImage),
                                ),
                                addWidth(20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: data.title,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    addHeight(5),
                                    AppText(
                                      text: data.description,
                                      fontSize: 19,
                                      color: Colors.white70,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),

          SliverToBoxAdapter(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 700),

              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 30),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 17,
                        ),
                        addWidth(5),
                        Text(
                          data.location,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    addHeight(20),
                    Text(
                      data.detailsDescription,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    addHeight(10),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ).copyWith(bottom: 30),
            sliver: AnimationLimiter(
              child: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 22,
                crossAxisSpacing: 25,
                childCount: widget.section.detailsCard.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                    delay: Duration(milliseconds: 250),
                    duration: Duration(milliseconds: 1600),
                    position: index,
                    columnCount: 2,
                    child: SlideAnimation(
                      verticalOffset: 90.0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      child: FadeInAnimation(
                        duration: const Duration(milliseconds: 400),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            widget.section.detailsCard[index],
                            fit: BoxFit.cover,
                            height: (index % 3 + 1.5) * 100.0,
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
