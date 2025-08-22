import 'package:animation_practice1/shared/shared.dart';
import 'package:flutter/material.dart';

class HomeTile extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onTap;
  final String imagePath;

  const HomeTile({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.onTap,
  });

  HomeTile copyWith({
    String? title,
    String? description,
    String? imagePath,
    VoidCallback? onTap,
  }) {
    return HomeTile(
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      onTap: onTap ?? this.onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: 900,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.purple,
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  // backgroundImage: AssetImage("assets/images/avatar.png"),
                ),
                addWidth(20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: title,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    AppText(
                      text: description,
                      fontSize: 12,
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
  }
}
