import 'dart:io';

import 'package:cnumontifier/widgets/button.dart';
import 'package:cnumontifier/widgets/colors.dart';
import 'package:cnumontifier/widgets/scan/pick_file.dart';
import 'package:cnumontifier/widgets/scan/result.dart';
import 'package:cnumontifier/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: CustomText(
              text: "Scan your image",
              fontSize: 20,
              textAlign: TextAlign.center,
              color: ColorTheme.bgColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'Camera',
                      onPressed: () async {
                        final String? image_path =
                            await pickImage(ImageSource.camera);
                        if (image_path != null) {
                          File image = File(image_path);
                          List<int> imageBytes = image.readAsBytesSync();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Characteristics(
                                image: base64Encode(imageBytes),
                                latitude: 0,
                                longitude: 0,
                              ),
                            ),
                          );
                        }
                      },
                      backgroundColor: ColorTheme.accentColor,
                    ),
                    CustomButton(
                      text: 'Pick File',
                      onPressed: () async {
                        final String? image_path =
                            await pickImage(ImageSource.gallery);
                        if (image_path != null) {
                          File image = File(image_path);
                          List<int> imageBytes = image.readAsBytesSync();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Characteristics(
                                image: base64Encode(imageBytes),
                                latitude: 0,
                                longitude: 0,
                              ),
                            ),
                          );
                        }
                      },
                      backgroundColor: ColorTheme.accentColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
