import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cnumontifier/widgets/colors.dart';
import 'text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double padding;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.padding = 8.0,
    this.fontWeight = FontWeight.bold,
    this.backgroundColor = ColorTheme.primaryColor, // default background color
    this.textColor = ColorTheme.textColorLight, // default text color
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: backgroundColor,
        minimumSize: Size(double.infinity, 2),
        padding: EdgeInsets.all(padding),
      ),
      child: CustomText(
        text: text,
        fontSize: 14,
        fontWeight: fontWeight,
        textAlign: TextAlign.center,
        color: textColor,
      ),
    );
  }
}