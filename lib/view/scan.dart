import 'package:cnumontifier/widgets/button.dart';
import 'package:cnumontifier/widgets/colors.dart';
import 'package:flutter/material.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Camera',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/camera');
              },
              backgroundColor: ColorTheme.accentColor,
            ),
            CustomButton(
              text: 'Pick File',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/pick_file');
              },
              backgroundColor: ColorTheme.accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
