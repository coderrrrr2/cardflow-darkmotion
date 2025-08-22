import 'package:animation_practice1/shared/assets.dart';
import 'package:animation_practice1/shared/shared.dart' show addWidth;
import 'package:animation_practice1/views/widgets/nav_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animation_practice1/viewmodel/home_viewmodel.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar>
    with TickerProviderStateMixin {
  late AnimationController _circleController;
  late Animation<double> _circleScale;

  @override
  void initState() {
    super.initState();

    // Controller for the purple button's scale animation
    _circleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _circleScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _circleController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNavBarOpen = ref.watch(
      homeProvider.select((state) => state.isNavBarOpen),
    );

    // Sync circleController with isNavBarOpen
    ref.listen<bool>(homeProvider.select((state) => state.isNavBarOpen), (
      previous,
      next,
    ) {
      if (next) {
        _circleController.forward();
      } else {
        _circleController.reverse();
      }
    });

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Navbar containers
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NavBarContainer(
              width: isNavBarOpen ? 0 : 210,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                bottomLeft: Radius.circular(60),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 30),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(
                            Icons.home,
                            size: 26,
                            color: Color.fromARGB(255, 34, 51, 182),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 26,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            NavBarContainer(
              width: isNavBarOpen ? 0 : 210,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28, right: 10),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(tree),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        addWidth(20),

        // First widget
        TweenAnimationBuilder<Offset>(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
          tween: Tween<Offset>(
            begin: isNavBarOpen ? Offset(180, 0) : Offset(80, -70),
            end: isNavBarOpen ? Offset(80, -70) : Offset(180, 0),
          ),
          builder: (context, offset, child) {
            return Positioned(
              left: offset.dx,
              top: offset.dy,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(192, 192, 192, 1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.folder),
              ),
            );
          },
        ),

        // Second widget
        TweenAnimationBuilder<Offset>(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
          tween: Tween<Offset>(
            begin: isNavBarOpen ? Offset(190, 0) : Offset(190, -120),
            end: isNavBarOpen ? Offset(190, -120) : Offset(190, 0),
          ),
          builder: (context, offset, child) {
            return Positioned(
              left: offset.dx,
              top: offset.dy,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(192, 192, 192, 1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.folder_open),
              ),
            );
          },
        ),

        // Third widget
        TweenAnimationBuilder<Offset>(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
          tween: Tween<Offset>(
            begin: isNavBarOpen ? Offset(200, 0) : Offset(290, -70),
            end: isNavBarOpen ? Offset(290, -70) : Offset(200, 0),
          ),
          builder: (context, offset, child) {
            return Positioned(
              left: offset.dx,
              top: offset.dy,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(192, 192, 192, 1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.folder_special),
              ),
            );
          },
        ),

        // Add button
        Positioned(
          top: -8,
          left: 185,
          child: GestureDetector(
            onTap: () {
              ref.read(homeProvider.notifier).toggleNavBarOpen();
            },
            child: Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.black, size: 32),
            ),
          ),
        ),

        // Close button with scale animation
        Positioned(
          top: -8,
          left: 185,
          child: GestureDetector(
            onTap: () {
              ref.read(homeProvider.notifier).toggleNavBarOpen();
            },
            child: ScaleTransition(
              scale: _circleScale,
              alignment: Alignment.center,
              child: Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(102, 101, 235, 1.0),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 32),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
