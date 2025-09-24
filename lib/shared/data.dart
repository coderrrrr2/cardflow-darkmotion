import 'package:animation_practice1/model/home_section.dart';
import 'package:animation_practice1/model/home_tile_data.dart';
import 'package:animation_practice1/shared/assets.dart';

final List<HomeSection> allHomeSections = [
  HomeSection(
    cardList: [
      HomeTileData(
        key: 'emma',
        imagePath: tree,
        title: 'Emma Wallace',
        description: '13 photos',
      ),
      HomeTileData(
        key: 'harry',
        imagePath: greenLeafsTwo,
        title: 'Harry Sans',
        description: '13 photos',
      ),
      HomeTileData(
        key: 'garden',
        imagePath: greenLeafs,
        title: 'Garden Views',
        description: '15 photos',
      ),
      HomeTileData(
        key: 'forest',
        imagePath: purpleGreenLeafs,
        title: 'Forest Trail',
        description: '7 photos',
      ),
    ],
    location: 'Emma\'s Gallery',
    detailsCard: [tree, greenLeafsTwo, greenLeafs, purpleGreenLeafs],
  ),
  HomeSection(
    cardList: [
      HomeTileData(
        key: 'harry',
        imagePath: greenLeafsTwo,
        title: 'Harry Sans',
        description: '13 photos',
      ),
      HomeTileData(
        key: 'garden',
        imagePath: greenLeafs,
        title: 'Garden Views',
        description: '15 photos',
      ),
      HomeTileData(
        key: 'forest',
        imagePath: purpleGreenLeafs,
        title: 'Forest Trail',
        description: '7 photos',
      ),
      HomeTileData(
        key: 'emma',
        imagePath: tree,
        title: 'Emma Wallace',
        description: '13 photos',
      ),
    ],
    location: 'Harry\'s Collection',
    detailsCard: [
      'assets/images/detail_harry1.png',
      'assets/images/detail_harry2.png',
    ],
  ),
  HomeSection(
    cardList: [
      HomeTileData(
        key: 'garden',
        imagePath: greenLeafs,
        title: 'Garden Views',
        description: '15 photos',
      ),
      HomeTileData(
        key: 'emma',
        imagePath: tree,
        title: 'Emma Wallace',
        description: '13 photos',
      ),
      HomeTileData(
        key: 'forest',
        imagePath: purpleGreenLeafs,
        title: 'Forest Trail',
        description: '7 photos',
      ),
      HomeTileData(
        key: 'harry',
        imagePath: greenLeafsTwo,
        title: 'Harry Sans',
        description: '13 photos',
      ),
    ],
    location: 'Garden Gallery',
    detailsCard: [
      'assets/images/detail_garden1.png',
      'assets/images/detail_garden2.png',
      'assets/images/detail_garden3.png',
    ],
  ),
  HomeSection(
    cardList: [
      HomeTileData(
        key: 'forest',
        imagePath: purpleGreenLeafs,
        title: 'Forest Trail',
        description: '7 photos',
      ),
      HomeTileData(
        key: 'garden',
        imagePath: greenLeafs,
        title: 'Garden Views',
        description: '15 photos',
      ),
      HomeTileData(
        key: 'emma',
        imagePath: tree,
        title: 'Emma Wallace',
        description: '13 photos',
      ),
      HomeTileData(
        key: 'harry',
        imagePath: greenLeafsTwo,
        title: 'Harry Sans',
        description: '13 photos',
      ),
    ],
    location: 'Forest Gallery',
    detailsCard: [
      'assets/images/detail_forest1.png',
      'assets/images/detail_forest2.png',
    ],
  ),
];
