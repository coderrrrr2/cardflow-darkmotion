// import 'package:animation_practice1/shared/data.dart';
// import 'package:animation_practice1/views/widgets/header.dart';
// import 'package:flutter/material.dart';

// class CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final bool showFullHeader;
//   final int? expandedIndex;
//   final bool isCardExpanded;
//   final double paddingValue; // Pass this if it changes dynamically

//   CustomHeaderDelegate({
//     required this.showFullHeader,
//     required this.expandedIndex,
//     required this.isCardExpanded,
//     required this.paddingValue,
//   });

//   static const double minHeaderExtent = 50.0; // For "For You" + padding
//   static const double maxNormalExtent = 200.0;
//   static const double maxExpandedExtent = 160.0;
//   static const double maxFirstExpandedExtent = 130.0;
//   static const double maxLastExpandedExtent = 0.0;

//   @override
//   double get minExtent =>
//       (isCardExpanded && expandedIndex == allHomeSections.length - 1)
//           ? maxLastExpandedExtent
//           : minHeaderExtent;

//   @override
//   double get maxExtent =>
//       showFullHeader
//           ? (expandedIndex == 0
//               ? maxFirstExpandedExtent
//               : (expandedIndex == allHomeSections.length - 1
//                   ? maxLastExpandedExtent
//                   : isCardExpanded
//                   ? maxExpandedExtent
//                   : maxNormalExtent))
//           : minExtent;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     final double currentExtent = (maxExtent - shrinkOffset).clamp(
//       minExtent,
//       maxExtent,
//     );
//     if (currentExtent <= 0) {
//       return const SizedBox.shrink();
//     }

//     final double proportion = 2 - (maxExtent / currentExtent);
//     final double percent = proportion.clamp(0.0, 1.0);

//     return SizedBox(
//       height: currentExtent,
//       child: Container(
//         color: Colors.black,
//         padding: EdgeInsets.symmetric(
//           horizontal: 30,
//         ).copyWith(top: paddingValue),
//         child: Stack(
//           children: [
//             // Full header (fades out as it shrinks)
//             Positioned(
//               bottom: 0.0,
//               left: 0.0,
//               right: 0.0,
//               child: Opacity(opacity: percent, child: const Header()),
//             ),
//             // "For You" title (fades in as it shrinks)
//             Positioned(
//               top: 0.0,
//               left: 0.0,
//               right: 0.0,
//               child: Opacity(
//                 opacity: 1 - percent,
//                 child: const Align(
//                   alignment: Alignment.topLeft,
//                   child: Text(
//                     'For you',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   bool shouldRebuild(covariant CustomHeaderDelegate oldDelegate) {
//     return showFullHeader != oldDelegate.showFullHeader ||
//         expandedIndex != oldDelegate.expandedIndex ||
//         isCardExpanded != oldDelegate.isCardExpanded ||
//         paddingValue != oldDelegate.paddingValue;
//   }
// }
