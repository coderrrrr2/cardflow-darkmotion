import 'dart:math';
import 'package:animation_practice1/model/home_section.dart';
import 'package:animation_practice1/model/home_tile_data.dart';
import 'package:animation_practice1/shared/assets.dart';

final Random _random = Random();

/// Titles mapped to images so they stay consistent
final Map<String, String> titles = {
  tree: 'Emma Wallace',
  greenLeafsTwo: 'Harry Sans',
  greenLeafs: 'Liam Carter',
  purpleGreenLeafs: 'Sophia Bennett',
  desertDunes: 'Noah Mitchell',
  birdPicture: 'Ava Thompson',
  forest: 'Ethan Ross',
};

/// Descriptions for variety
final Map<String, String> descriptions = {
  tree: '13 photos',
  greenLeafsTwo: '13 photos',
  greenLeafs: '15 photos',
  purpleGreenLeafs: '7 photos',
  desertDunes: '10 photos',
  birdPicture: '9 photos',
  forest: '12 photos',
};

/// Locations
final Map<String, String> locations = {
  tree: 'Rainforest',
  greenLeafsTwo: 'Countryside',
  greenLeafs: 'Botanical Garden',
  purpleGreenLeafs: 'Woodland Trail',
  desertDunes: 'Sahara Desert',
  birdPicture: 'Wetlands',
  forest: 'Amazon Forest',
};

/// Details Descriptions
final Map<String, String> detailsDescriptions = {
  tree: 'A nature enthusiast capturing the serenity of the rainforest.',
  greenLeafsTwo: 'Exploring calm countryside greenery in full bloom.',
  greenLeafs: 'Documenting lush botanical gardens filled with exotic plants.',
  purpleGreenLeafs: 'Following the winding woodland trail at sunset.',
  desertDunes: 'Golden sands reflecting the beauty of untouched deserts.',
  birdPicture: 'A close encounter with vibrant bird life by the wetlands.',
  forest: 'Immersed deep within the Amazon capturing raw wilderness.',
};

/// User Images (assigning each asset randomly to a person)
List<String> people = [person1, person2, person3, person4, person5];

/// Main card images
List<String> allImages = [
  tree,
  greenLeafs,
  greenLeafsTwo,
  purpleGreenLeafs,
  desertDunes,
  birdPicture,
  forest,
];

/// Detail card images
List<String> detailImages = [rf1, rf2, rf3, rf4, r5, r6, greenLeafs];

List<HomeTileData> generateRandomCards(
  List<String> availableImages,
  int sectionIndex,
) {
  List<String> shuffled = List.of(availableImages)..shuffle(_random);

  return shuffled.take(4).map((img) {
    return HomeTileData(
      key: '${img}_${sectionIndex}_${_random.nextInt(10000)}', // ✅ unique key
      imagePath: img,
      title: titles[img] ?? 'Untitled',
      description: descriptions[img] ?? '0 photos',
      userImage: people[_random.nextInt(people.length)], // random person
      location: locations[img] ?? 'Unknown Location',
      detailsDescription: detailsDescriptions[img] ?? 'No details available',
    );
  }).toList();
}

final List<HomeSection> allHomeSections =
    (() {
      // Pick 4 unique first images (one per section)
      List<String> shuffledImages = List.of(allImages)..shuffle(_random);
      List<String> uniqueFirstImages = shuffledImages.take(4).toList();

      // Build the 4 sections
      return List.generate(4, (sectionIndex) {
        // Assign one consistent user image for this section
        String sectionUser = people[_random.nextInt(people.length)];

        // Create a fresh pool of images for this section
        List<String> pool = List.of(allImages)..shuffle(_random);

        // Reserve unique first image
        pool.remove(uniqueFirstImages[sectionIndex]);
        List<HomeTileData> cards =
            generateRandomCards(pool, sectionIndex)
                .map(
                  (card) => card.copyWith(userImage: sectionUser),
                ) // ✅ enforce same user
                .toList();

        // Insert the guaranteed unique first card with the same user
        cards[0] = HomeTileData(
          key:
              '${uniqueFirstImages[sectionIndex]}_${sectionIndex}_${_random.nextInt(10000)}',
          imagePath: uniqueFirstImages[sectionIndex],
          title: titles[uniqueFirstImages[sectionIndex]] ?? 'Untitled',
          description:
              descriptions[uniqueFirstImages[sectionIndex]] ?? '0 photos',
          userImage: sectionUser, // ✅ same user for all cards
          location:
              locations[uniqueFirstImages[sectionIndex]] ?? 'Unknown Location',
          detailsDescription:
              detailsDescriptions[uniqueFirstImages[sectionIndex]] ??
              'No details available',
        );

        return HomeSection(
          cardList: cards,
          location: 'Gallery ${sectionIndex + 1}',
          detailsCard: List.of(detailImages)..shuffle(_random), // ✅ NEW pool
        );
      });
    })();
