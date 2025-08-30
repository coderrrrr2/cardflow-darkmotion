import 'package:animation_practice1/shared/assets.dart';
import 'package:animation_practice1/viewmodel/home_viewmodel.dart';
import 'package:animation_practice1/views/widgets/card_delegate.dart';
import 'package:animation_practice1/views/widgets/home_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardSlider extends ConsumerStatefulWidget {
  const CardSlider({super.key});

  @override
  ConsumerState<CardSlider> createState() => _CardSliderState();
}

class _CardSliderState extends ConsumerState<CardSlider>
    with TickerProviderStateMixin {
  final List<HomeTile> allCards = [
    HomeTile(
      key: const ValueKey('emma'),
      imagePath: tree,
      title: 'Emma Wallace',
      description: '13 photos',
    ),
    HomeTile(
      key: const ValueKey('harry'),
      imagePath: greenLeafsTwo,
      title: 'Harry Sans',
      description: '13 photos',
    ),
    HomeTile(
      key: const ValueKey('garden'),
      imagePath: greenLeafs,
      title: 'Garden Views',
      description: '15 photos',
    ),
    HomeTile(
      key: const ValueKey('forest'),
      imagePath: purpleGreenLeafs,
      title: 'Forest Trail',
      description: '7 photos',
    ),
  ];

  late AnimationController _swipeController;
  late Animation<double> _swipeAnimation;
  bool _isAnimating = false;
  bool _isSwipingLeft = true;

  @override
  void initState() {
    super.initState();

    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _swipeAnimation = CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  Future<void> swipeLeft() async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _isSwipingLeft = true;
    });

    await _swipeController.forward();

    setState(() {
      final first = allCards.removeAt(0);
      allCards.add(first);
      _isAnimating = false;
    });

    _swipeController.reset();
  }

  Future<void> swipeRight() async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _isSwipingLeft = false;
    });

    await _swipeController.forward();

    setState(() {
      final last = allCards.removeLast();
      allCards.insert(0, last);
      _isAnimating = false;
    });

    _swipeController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final isCardExpanded = ref.watch(
      homeProvider.select((state) => state.isCardExpanded),
    );

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < -20) {
          swipeLeft();
        } else if (details.primaryVelocity! > 20) {
          swipeRight();
        }
      },
      onTap: () {
        if (!_isAnimating) {
          ref.read(homeProvider.notifier).toggleExpanded();
        }
      },
      child: Padding(
        padding:
            isCardExpanded
                ? const EdgeInsets.only(left: 30, right: 10)
                : const EdgeInsets.symmetric(horizontal: 30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          height: isCardExpanded ? 600 : 430,
          curve: Curves.easeInOut,
          child: AnimatedBuilder(
            animation: _swipeAnimation,
            builder: (context, child) {
              return Flow(
                delegate: ParallaxFlowDelegate(
                  isCardExpanded: isCardExpanded,
                  offsetX: 20,
                  swipeProgress: _isAnimating ? _swipeAnimation.value : 0.0,
                  isSwipingLeft: _isSwipingLeft,
                ),
                children: allCards, // full list, first element = topmost
              );
            },
          ),
        ),
      ),
    );
  }
}
