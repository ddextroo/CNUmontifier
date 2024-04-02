import 'dart:convert';
import 'dart:typed_data';

import 'package:cnumontifier/widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Characteristics extends StatefulWidget {
  final String image;

  const Characteristics({Key? key, required this.image}) : super(key: key);

  @override
  State<Characteristics> createState() => _CharacteristicsState();
}

class _CharacteristicsState extends State<Characteristics> {
  Future<Map<String, dynamic>> scanImage() async {
    try {
      final String baseUrl = dotenv.env['SCANNER']!;
      final response = await http.post(
        Uri.parse("$baseUrl/predict"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, String>{
          "image": widget.image,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: scanImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Stack(
              children: <Widget>[
                Base64ImageWidget(
                  base64Image: widget.image,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                      child: CustomText(
                    text: "${snapshot.data?["classification"].substring(2)}",
                    textAlign: TextAlign.center,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class Base64ImageWidget extends StatelessWidget {
  final String base64Image;

  Base64ImageWidget({required this.base64Image});

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(base64Image);
    return ColorFiltered(
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.srcOver),
      child: Image.memory(
        bytes,
        fit: BoxFit.none,
        colorBlendMode: BlendMode.srcOver,
      ),
    );
  }
}
