//png

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

String tree = "tree".png;
String greenLeafs = "green_leafs".jpeg;
String greenLeafsTwo = "green_leafs2".jpeg;
String purpleGreenLeafs = "purple_green_leafs".webp;
String whiteGreenLeafs = "white_green_leafs".jpg;
String desertDunes = "desert_dune".jpg;

//svg

//json

extension ImageExtension on String {
  String get png => 'assets/pngs/$this.png';
  String get jpg => 'assets/pngs/$this.jpg';
  String get jpeg => 'assets/pngs/$this.jpeg';
  String get webp => 'assets/pngs/$this.webp';

  String get svg => 'assets/svgs/$this.svg';
  String get json => 'assets/jsons/$this.json';

  Widget get image {
    if (endsWith('.svg')) {
      return SvgPicture.asset(this);
    } else {
      return Image.asset(this);
    }
  }

  /// Shortcut to use like: `'tree'.svgImage` or `'icon'.pngImage`
  Widget get svgImage => SvgPicture.asset(svg);
  Widget get pngImage => Image.asset(png);
}
