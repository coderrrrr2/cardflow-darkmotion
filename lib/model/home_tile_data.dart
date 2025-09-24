class HomeTileData {
  final String key; // To store ValueKey identifier
  final String imagePath;
  final String title;
  final String description;

  HomeTileData({
    required this.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  HomeTileData copyWith({
    String? key,
    String? imagePath,
    String? title,
    String? description,
  }) {
    return HomeTileData(
      key: key ?? this.key,
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
