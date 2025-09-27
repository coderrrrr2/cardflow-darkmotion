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

    return SizedBox(
      height: !isCardExpanded ? 160 : 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Collapsed Header
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: isCardExpanded ? -100 : 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: isCardExpanded ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: AnimatedScale(
                alignment: Alignment.topLeft,
                scale: isCardExpanded ? 0.8 : 1.0, // shrink when leaving
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _buildCollapsedHeader(const ValueKey("collapsed")),
              ),
            ),
          ),

          // Expanded Header
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: isCardExpanded ? 0 : 100,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: isCardExpanded ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: AnimatedScale(
                alignment: Alignment.bottomRight,

                scale: isCardExpanded ? 1.0 : 0.8, // grow when entering
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _buildExpandedHeader(const ValueKey("expanded")),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedHeader(ValueKey key) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(text: "SUNDAY, SEPTEMBER 7", fontSize: 13, color: Colors.grey),
        addHeight(10),
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

  Widget _buildExpandedHeader(ValueKey key) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "COLLECTIONS",
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w100,
                ),
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
