import 'package:animation_practice1/model/home_tile_data.dart';
import 'package:animation_practice1/shared/shared.dart';
import 'package:flutter/material.dart';

class HomeTile extends StatelessWidget {
  final HomeTileData data;
  final VoidCallback? onCardTap;
  final VoidCallback? onAvatarTap;

  /// New: allows parent (CardSlider) to wrap this widget in Hero or other transitions
  final Widget Function(Widget child)? childWrapper;

  const HomeTile({
    super.key,
    required this.data,
    this.onCardTap,
    this.onAvatarTap,
    this.childWrapper,
  });

  HomeTile copyWith({
    Key? key,
    HomeTileData? data,
    VoidCallback? onCardTap,
    VoidCallback? onAvatarTap,
    Widget Function(Widget child)? childWrapper,
  }) {
    return HomeTile(
      key: key ?? this.key,
      data: data ?? this.data,
      onCardTap: onCardTap ?? this.onCardTap,
      onAvatarTap: onAvatarTap ?? this.onAvatarTap,
      childWrapper: childWrapper ?? this.childWrapper,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget card = GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.purple,
          image: DecorationImage(
            image: AssetImage(data.imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onAvatarTap,
                  child: CircleAvatar(
                    radius: 27,
                    backgroundImage: AssetImage(data.userImage),
                  ),
                ),
                addWidth(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: data.title,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    addHeight(5),
                    AppText(
                      text: data.description,
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // If a wrapper (e.g., Hero) is provided, wrap it around the card
    return childWrapper != null ? childWrapper!(card) : card;
  }
}
