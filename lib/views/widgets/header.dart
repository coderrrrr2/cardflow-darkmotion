import 'package:animation_practice1/shared/shared.dart';
import 'package:animation_practice1/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Header extends ConsumerStatefulWidget {
  const Header({super.key});

  @override
  ConsumerState<Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<Header> {
  @override
  Widget build(BuildContext context) {
    final isCardExpanded = ref.watch(
      homeProvider.select((state) => state.isCardExpanded),
    );
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final bool childRepresentsExpanded = child.key == const ValueKey(true);

        final Offset offset =
            childRepresentsExpanded ? const Offset(0, 1) : const Offset(0, -1);

        final tween = Tween<Offset>(begin: offset, end: Offset.zero);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: tween.animate(animation),
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.topCenter,
        key: ValueKey(isCardExpanded),
        child: SizedBox(
          height: 100, // Ensure both versions take same vertical space
          child:
              isCardExpanded ? _buildExpandedHeader() : _buildCollapsedHeader(),
        ),
      ),
    );
  }

  Widget _buildCollapsedHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "SUNDAY, SEPTEMBER 7",
              fontSize: 16,
              color: Colors.grey,
            ),
            addHeight(4),
            LeadingText(text: "For You"),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandedHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(text: "collections", fontSize: 16, color: Colors.grey),
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
    );
  }
}
