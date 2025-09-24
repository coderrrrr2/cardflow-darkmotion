import 'package:animation_practice1/shared/shared.dart';
import 'package:animation_practice1/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Header extends ConsumerStatefulWidget {
  const Header({super.key});

  @override
  ConsumerState<Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<Header> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final isCardExpanded = ref.watch(
      homeProvider.select((state) => state.isCardExpanded),
    );

    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 500),
        firstCurve: Curves.easeInOut,
        secondCurve: Curves.easeInOut,
        sizeCurve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        crossFadeState:
            isCardExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
        firstChild: _slideWrapper(
          _buildCollapsedHeader(),
          fromTop: true,
          goingToExpanded: isCardExpanded,
        ),
        secondChild: _slideWrapper(
          _buildExpandedHeader(),
          fromTop: false,
          goingToExpanded: !isCardExpanded,
        ),
      ),
    );
  }

  /// fromTop: where the widget is initially coming from
  /// goingToExpanded: true if this transition is happening because we are expanding
  Widget _slideWrapper(
    Widget child, {
    required bool fromTop,
    required bool goingToExpanded,
  }) {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    // Determine slide direction based on expanding/collapsing
    final beginOffset =
        goingToExpanded
            ? (fromTop ? const Offset(0, -1) : const Offset(0, 1))
            : (fromTop ? const Offset(0, 1) : const Offset(0, -1));

    final offsetTween = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    final fadeTween = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    return SlideTransition(
      position: offsetTween,
      child: FadeTransition(opacity: fadeTween, child: child),
    );
  }

  Widget _buildCollapsedHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(text: "SUNDAY, SEPTEMBER 7", fontSize: 13, color: Colors.grey),
        addHeight(15),
        LeadingText(text: "For You"),
        addHeight(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _chip("Nature", selected: true),
            _chip("City"),
            _chip("People"),
            _chip("Animals", width: 80),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandedHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        addHeightAnimated(5),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: "COLLECTIONS", fontSize: 16, color: Colors.grey),
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
        ),
      ],
    );
  }

  Widget _chip(String text, {bool selected = false, double width = 100}) {
    return Container(
      height: 50,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(selected ? 30 : 4),
        color: selected ? Colors.grey : Colors.black,
      ),
      child: Center(
        child: AppText(
          text: text,
          fontSize: selected ? 17 : 15,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );
  }
}
