class Plant {
  final String photo;
  final String name;
  final int photosCount;

  Plant({required this.photo, required this.name, required this.photosCount});

  // Optional: From JSON
  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      photo: json['photo'],
      name: json['name'],
      photosCount: json['photosCount'],
    );
  }

  // Optional: To JSON
  Map<String, dynamic> toJson() {
    return {'photo': photo, 'name': name, 'photosCount': photosCount};
  }
}
