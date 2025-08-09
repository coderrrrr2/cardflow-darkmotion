import 'package:animation_practice1/shared/assets.dart';
import 'package:animation_practice1/shared/shared_widgets.dart';
import 'package:animation_practice1/views/widgets/header.dart';
import 'package:animation_practice1/views/widgets/home_tile.dart';
import 'package:animation_practice1/views/widgets/top_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Animate(child: Header(isExpanded: isExpanded)),

                addHeight(30),
                TopSlider(
                  isExpanded: isExpanded,
                  onTap: (p0) {
                    setState(() {
                      isExpanded = p0;
                    });
                  },
                ),
                addHeightAnimated(isExpanded ? 200 : 30),
                HomeTile(
                  imagePath: tree,
                  title: 'Emma Wallace',
                  description: '13 photos',
                ),

                // ConstrainedBox(
                //   constraints: BoxConstraints(maxHeight: 650, minHeight: 450),
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,

                //     itemCount: 10,
                //     itemBuilder: (context, index) {
                //       return Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: HomeTile(
                //           title: "Title $index",
                //           description: "Description for item $index",
                //           onTap: () {
                //             // Handle tile tap
                //           },
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavBar(),
    );
  }
}
