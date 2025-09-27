import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // 👈 Import the Google Fonts package

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool isItalic;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final StrutStyle? strutStyle;

  const AppText({
    super.key,
    required this.text,
    this.isItalic = false,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.strutStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // If you haven't set a default theme text style (e.g., in MaterialApp),
    // it's best to use GoogleFonts.workSans() to create the base style.

    // Define the custom base style using the Google Font
    final TextStyle customBaseStyle = GoogleFonts.figtree(
      textStyle:
          Theme.of(
            context,
          ).textTheme.displaySmall, // Inherit size/spacing properties if needed
      color: Colors.white,
      fontWeight: FontWeight.w400,
    );

    return Text(
      text,
      style:
          style ??
          customBaseStyle.copyWith(
            // Apply your custom overrides to the new base font
            color:
                color, // The base style sets it to white, but null here allows the custom color to override it, or keeps the base if 'color' is null.
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      strutStyle: strutStyle,
    );
  }
}

class LeadingText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  const LeadingText({
    super.key,
    required this.text,
    this.fontSize = 50,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,

      style: theme.textTheme.headlineLarge!.copyWith(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color ?? Colors.white,
      ),
    );
  }
}

class TrailingText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;

  const TrailingText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.displaySmall!.copyWith(
              fontSize: fontSize ?? 14,
              fontWeight: fontWeight ?? FontWeight.w200,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
