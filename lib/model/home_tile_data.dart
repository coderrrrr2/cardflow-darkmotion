class HomeTileData {
  final String key; // To store ValueKey identifier
  final String imagePath;
  final String title;
  final String description;
  final String userImage; // New field for user image
  final String location; // New field for location
  final String detailsDescription; // New field for detailed description

  HomeTileData({
    required this.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.userImage,
    required this.location,
    required this.detailsDescription,
  });

  HomeTileData copyWith({
    String? key,
    String? imagePath,
    String? title,
    String? description,
    String? userImage,
    String? location,
    String? detailsDescription,
  }) {
    return HomeTileData(
      key: key ?? this.key,
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
      description: description ?? this.description,
      userImage: userImage ?? this.userImage,
      location: location ?? this.location,
      detailsDescription: detailsDescription ?? this.detailsDescription,
    );
  }
}
