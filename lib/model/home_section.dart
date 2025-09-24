import 'package:animation_practice1/model/home_tile_data.dart';

class HomeSection {
  final List<HomeTileData> cardList; // List of HomeTile data
  final String location;
  final List<String> detailsCard; // List of image paths

  HomeSection({
    required this.cardList,
    required this.location,
    required this.detailsCard,
  });

  HomeSection copyWith({
    List<HomeTileData>? cardList,
    String? location,
    List<String>? detailsCard,
  }) {
    return HomeSection(
      cardList: cardList ?? this.cardList,
      location: location ?? this.location,
      detailsCard: detailsCard ?? this.detailsCard,
    );
  }
}
