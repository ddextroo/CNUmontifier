import 'dart:convert';
import 'dart:typed_data';

import 'package:cnumontifier/widgets/CustomText.dart';
import 'package:cnumontifier/widgets/button.dart';
import 'package:cnumontifier/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
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
            return SingleChildScrollView(
              child: Flexible(
                flex: 1,
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Base64ImageWidget(
                        base64Image: widget.image,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: CustomText(
                        text:
                            "${snapshot.data?["classification"].substring(2)}",
                        textAlign: TextAlign.center,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/list-indefinite.svg",
                                    width: 20,
                                    height: 20,
                                    color: ColorTheme.bgColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: CustomText(
                                      text: "Charateristics",
                                      textAlign: TextAlign.left,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    child: CustomText(
                                      text: "Accuracy",
                                      textAlign: TextAlign.left,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    child: CustomText(
                                      text: "${snapshot.data?["confidence"]}",
                                      textAlign: TextAlign.left,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Slider(
                              min: 0.0,
                              max: 100.0,
                              value: snapshot.data?["confidence"],
                              divisions: 4,
                              onChanged: (double value) {},
                              label:
                                  "${snapshot.data?["confidence"].toStringAsFixed(2)}",
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    child: CustomText(
                                      text: "Accuracy",
                                      textAlign: TextAlign.left,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    child: CustomButton(
                                        text: "text", onPressed: () {})),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOver),
        child: Image.memory(
          bytes,
          fit: BoxFit.none,
          colorBlendMode: BlendMode.srcOver,
        ),
      ),
    );
  }
}
