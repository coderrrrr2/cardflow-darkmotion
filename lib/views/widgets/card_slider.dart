import 'package:animation_practice1/model/home_section.dart';
import 'package:animation_practice1/viewmodel/home_viewmodel.dart';
import 'package:animation_practice1/views/widgets/card_delegate.dart';
import 'package:animation_practice1/views/widgets/home_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardSlider extends ConsumerStatefulWidget {
  final HomeSection section;
  final int index;
  final bool isLastCard;
  final int? expandedIndex; // Add this to know which card is expanded
  final int totalCards; // Add this to know total number of cards

  const CardSlider({
    super.key,
    required this.section,
    required this.index,
    this.isLastCard = false,
    this.expandedIndex,
    required this.totalCards,
  });

  @override
  ConsumerState<CardSlider> createState() => _CardSliderState();
}

class _CardSliderState extends ConsumerState<CardSlider>
    with TickerProviderStateMixin {
  late final HomeSection section;
  late final List<HomeTile> allCards;
  late AnimationController _swipeController;
  late Animation<double> _swipeAnimation;
  bool _isAnimating = false;
  bool _isSwipingLeft = true;

  @override
  void initState() {
    super.initState();
    allCards = widget.section.cardList.map((e) => HomeTile(data: e)).toList();
    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 400),
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

  void onAvatarTapped() {}

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    final expandedIndex = state.expandedSectionIndex;
    final isCardExpanded = widget.index == expandedIndex;
    final isAnyCardExpanded = expandedIndex != null;

    bool shouldSlideOut = isAnyCardExpanded && !isCardExpanded;
    bool slideDown = false;

    if (shouldSlideOut) {
      slideDown = widget.index > expandedIndex;
    }

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < -20) {
          swipeLeft();
        } else if (details.primaryVelocity! > 20) {
          swipeRight();
        }
      },
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        offset:
            shouldSlideOut
                ? (slideDown ? const Offset(0, 1) : const Offset(0, -1))
                : Offset.zero,
        child: Padding(
          padding:
              isCardExpanded
                  ? const EdgeInsets.only(left: 30, right: 10)
                  : const EdgeInsets.symmetric(horizontal: 30),
          child: Hero(
            tag: 'card_slider_${widget.index}',
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: isCardExpanded ? 600 : 400,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),

                curve: Curves.easeInOutBack,
                height: isCardExpanded ? 600 : 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: AnimatedBuilder(
                  animation: _swipeAnimation,
                  builder: (context, child) {
                    return Flow(
                      delegate: ParallaxFlowDelegate(
                        isCardExpanded: isCardExpanded,
                        offsetX: 20,
                        swipeProgress:
                            _isAnimating ? _swipeAnimation.value : 0.0,
                        isSwipingLeft: _isSwipingLeft,
                      ),
                      children:
                          allCards
                              .map(
                                (e) => e.copyWith(
                                  onAvatarTap: () {
                                    /* open detail */
                                  },
                                  onCardTap: () {
                                    final isExpanded =
                                        ref.read(homeProvider).isCardExpanded;
                                    if (isExpanded) {
                                      ref
                                          .read(homeProvider.notifier)
                                          .toggleExpanded(null);
                                    } else {
                                      ref
                                          .read(homeProvider.notifier)
                                          .toggleExpanded(widget.index);
                                    }
                                  },
                                ),
                              )
                              .toList(),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
