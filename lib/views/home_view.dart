import 'package:animation_practice1/shared/data.dart';
import 'package:animation_practice1/viewmodel/home_viewmodel.dart';
import 'package:animation_practice1/views/widgets/card_slider.dart';
import 'package:animation_practice1/views/widgets/header.dart';
import 'package:animation_practice1/views/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _expandController;
  late Animation<double> _scaleAnimation;

  double paddingValue = 20;
  late ScrollController _scrollController;
  late List<GlobalKey> cardKeys;
  double? collapsedScrollOffset;

  bool _showHeader = true;
  static const double _scrollThreshold = 20.0;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _scaleController.addListener(() {
      setState(() {
        final normalized = (_scaleAnimation.value - 0.85) / (1.0 - 0.85);
        paddingValue = 100 - (80 * normalized);
      });
    });

    _expandController.addListener(() {
      final state = ref.read(homeProvider);
      final expandedIndex = state.expandedSectionIndex;
      if (expandedIndex != null &&
          expandedIndex == allHomeSections.length - 1 &&
          collapsedScrollOffset != null &&
          _scrollController.hasClients) {
        const delta = 200.0; // 600 - 400
        _scrollController.jumpTo(
          collapsedScrollOffset! + (_expandController.value * delta),
        );
      }
    });

    _scaleController.value = 1.0;
    _scrollController = ScrollController();
    cardKeys = List.generate(allHomeSections.length, (index) => GlobalKey());

    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateHeaderVisibility();
    });
  }

  /// Single unified rule for header visibility
  bool _shouldShowHeader(int? expandedIndex, double scrollOffset) {
    final isExpanded = expandedIndex != null;
    final isAtTop = scrollOffset <= _scrollThreshold;
    return isExpanded || isAtTop;
  }

  void _updateHeaderVisibility({int? expandedIndex}) {
    final index = expandedIndex ?? ref.read(homeProvider).expandedSectionIndex;
    final shouldShow = _shouldShowHeader(index, _scrollController.offset);

    if (_showHeader != shouldShow) {
      setState(() => _showHeader = shouldShow);
    }
  }

  void _onScroll() {
    _updateHeaderVisibility();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _expandController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int?>(
      homeProvider.select((state) => state.expandedSectionIndex),
      (previous, next) {
        // update header consistently
        _updateHeaderVisibility(expandedIndex: next);

        if (next != null) {
          collapsedScrollOffset = _scrollController.offset;
          _expandController.forward();

          final isLast = next == allHomeSections.length - 1;
          if (!isLast) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final keyContext = cardKeys[next].currentContext;
              if (keyContext != null && _scrollController.hasClients) {
                if (!context.mounted) return;
                // Scrollable.ensureVisible(
                //   keyContext,
                //   alignment: 0.1, // Align closer to top
                //   duration: const Duration(milliseconds: 400),
                // );
              }
            });
          }
        } else {
          _expandController.reverse();
          _expandController.addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              collapsedScrollOffset = null;
            }
          });
        }
      },
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

    final state = ref.watch(homeProvider);
    final isNavBarOpen = state.isNavBarOpen;
    final expandedSectionIndex = state.expandedSectionIndex;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        // Animated top spacing (replaces addHeightAnimated + Column spacer)
                        if (_showHeader)
                          SliverToBoxAdapter(
                            child: AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 400,
                              ), // Match card expansion duration
                              curve: Curves.easeInOut,
                              height:
                                  (expandedSectionIndex ==
                                          0) // Special handling for first card
                                      ? 160 // Reduced height when first card expands
                                      : (expandedSectionIndex ==
                                          allHomeSections.length - 1)
                                      ? 0
                                      : state.isCardExpanded
                                      ? 160
                                      : 200,
                            ),
                          ),

                        // Your list of cards
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return Container(
                              key: cardKeys[index],
                              margin: EdgeInsets.only(
                                top: index == 0 ? 0 : 8,
                                bottom:
                                    index == allHomeSections.length - 1
                                        ? 40
                                        : 8,
                              ),
                              child: CardSlider(
                                section: allHomeSections[index],
                                index: index,
                                isLastCard: index == allHomeSections.length - 1,
                                expandedIndex: expandedSectionIndex,
                                totalCards: allHomeSections.length,
                              ),
                            );
                          }, childCount: allHomeSections.length),
                        ),

                        // Bottom safe space (replaces ListView padding.bottom)
                        const SliverToBoxAdapter(child: SizedBox(height: 100)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                  ).copyWith(top: paddingValue),
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState:
                        _showHeader
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                    firstChild: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'For you',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    secondChild: const Header(),
                  ),
                ),
              ),
            ),
            if (isNavBarOpen)
              Container(color: Colors.black.withValues(alpha: 0.7)),
            const SafeArea(child: BottomNavBar()),
          ],
        ),
      ),
    );
  }
}
