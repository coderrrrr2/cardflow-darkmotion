import 'package:animation_practice1/shared/assets.dart';
import 'package:animation_practice1/shared/shared_widgets.dart';
import 'package:animation_practice1/viewmodel/home_viewmodel.dart';
import 'package:animation_practice1/views/widgets/header.dart';
import 'package:animation_practice1/views/widgets/home_tile.dart';
import 'package:animation_practice1/views/widgets/nav_bar.dart';
import 'package:animation_practice1/views/widgets/card_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  double paddingValue = 20;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Smoothly interpolate padding as the scale animation progresses
    _scaleController.addListener(() {
      setState(() {
        // normalized: 0 -> 1
        final normalized = (_scaleAnimation.value - 0.85) / (1.0 - 0.85);
        // map to 20 -> 100 range
        paddingValue = 100 - (80 * normalized);
      });
    });

    // Listen to nav bar changes only once, not every build

    // Start fully expanded
    _scaleController.value = 1.0;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCardExpanded = ref.watch(
      homeProvider.select((state) => state.isCardExpanded),
    );
    final isNavBarOpen = ref.watch(
      homeProvider.select((state) => state.isNavBarOpen),
    );

    ref.listen<bool>(homeProvider.select((state) => state.isNavBarOpen), (
      previous,
      next,
    ) {
      if (next) {
        _scaleController.reverse();
      } else {
        _scaleController.forward();
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // ScaleTransition with smooth scaling
            ScaleTransition(
              scale: _scaleAnimation,
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                      ).copyWith(top: paddingValue),
                      child: Header(),
                    ),
                    addHeight(30),
                    CardSlider(),
                    addHeightAnimated(isCardExpanded ? 200 : 30),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                      ).copyWith(top: paddingValue),
                      child: HomeTile(
                        imagePath: tree,
                        title: 'Emma Wallace',
                        description: '13 photos',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isNavBarOpen)
              Container(color: Colors.black.withValues(alpha: 0.7)),
            SafeArea(child: BottomNavBar()),
          ],
        ),
      ),
    );
  }
}
