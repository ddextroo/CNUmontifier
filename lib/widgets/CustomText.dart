import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final String fontName;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign; // Add text alignment property

  CustomText({
    required this.text,
    this.fontName = 'Open Sans',
    this.color = ColorTheme.textColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign, // Pass text alignment to the Text widget
      style: GoogleFonts.getFont(
        fontName,
        textStyle: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

//Eyy