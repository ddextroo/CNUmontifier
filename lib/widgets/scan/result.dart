import 'dart:convert';
import 'dart:typed_data';

import 'package:cnumontifier/controller/classify_image_controller.dart';
import 'package:cnumontifier/view/select_map.dart';
import 'package:cnumontifier/widgets/CustomText.dart';
import 'package:cnumontifier/widgets/button.dart';
import 'package:cnumontifier/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Characteristics extends StatefulWidget {
  final String image;
  final double latitude;
  final double longitude;

  const Characteristics(
      {Key? key,
      required this.image,
      required this.latitude,
      required this.longitude})
      : super(key: key);

  @override
  State<Characteristics> createState() => _CharacteristicsState();
}

class _CharacteristicsState extends State<Characteristics> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Provider.of<ClassifyImageController>(context, listen: false)
            .scanImage(widget.image),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: CustomText(
                      text: "${snapshot.data?["classification"].substring(2)}",
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
                          padding: const EdgeInsets.symmetric(
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
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
                                  padding: const EdgeInsets.symmetric(
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
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
                                  padding: const EdgeInsets.symmetric(
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
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
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
                                  padding: const EdgeInsets.symmetric(
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
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
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
                                  padding: const EdgeInsets.symmetric(
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
                        const Divider(),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/information-2-line.svg",
                                  width: 20,
                                  height: 20,
                                  color: ColorTheme.bgColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CustomText(
                                    text: "Description",
                                    textAlign: TextAlign.left,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: CustomText(
                            text: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tempor elit non tellus bibendum porttitor. In vitae odio semper, porta mauris ut, finibus quam. Aliquam volutpat augue eget quam tincidunt, vel accumsan quam varius. Mauris placerat quam sem, in auctor risus consectetur ac. Integer feugiat mi at facilisis maximus. Proin posuere molestie sapien sed congue. In hac habitasse platea dictumst. Integer at odio eget est malesuada lacinia vel non arcu. Aliquam nulla est, congue et lectus quis, hendrerit porta felis. Aliquam iaculis orci eu dolor varius finibus. Suspendisse ac tortor molestie, hendrerit tellus mattis, commodo sapien. Maecenas eget faucibus tellus, ac auctor leo. Nulla facilisi. Curabitur felis risus, laoreet pulvinar ex nec, porttitor laoreet nulla.

Curabitur pharetra in est quis mattis. Ut iaculis iaculis justo nec euismod. Sed eget quam augue. Aliquam luctus purus varius purus convallis consectetur. Donec lacus dui, hendrerit at est id, facilisis volutpat ante. Nam vitae pharetra enim. Nullam semper augue eget sem tincidunt, in pretium risus vestibulum. Quisque faucibus ullamcorper pharetra. Proin id odio vestibulum, vestibulum lacus sit amet, dignissim arcu. Morbi luctus blandit posuere. Etiam ultricies quis mi et pretium. Nullam ut erat accumsan, suscipit diam non, eleifend enim. Donec sapien tellus, fringilla ac aliquet ut, facilisis sed est. Nulla blandit consectetur ipsum non scelerisque. Donec eu placerat tellus. Mauris at vehicula sem.""",
                            textAlign: TextAlign.justify,
                            fontSize: 12,
                          ),
                        ),
                        const Divider(),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/map-pin-line.svg",
                                  width: 20,
                                  height: 20,
                                  color: ColorTheme.bgColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CustomText(
                                    text: "Set Location",
                                    textAlign: TextAlign.left,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectMap(
                                  image: widget.image,
                                  latitude: widget.latitude != 0
                                      ? widget.latitude
                                      : 0,
                                  longitude: widget.longitude != 0
                                      ? widget.longitude
                                      : 0,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/map-pin-add-line.svg",
                                      width: 15,
                                      height: 15,
                                      color: ColorTheme.textColorGray,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: CustomText(
                                        text:
                                            "Latitude: ${widget.latitude != 0.000000000000 ? widget.latitude : 0.000000000000}",
                                        fontSize: 14,
                                        textAlign: TextAlign.center,
                                        color: ColorTheme.textColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/map-pin-add-line.svg",
                                      width: 15,
                                      height: 15,
                                      color: ColorTheme.textColorGray,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: CustomText(
                                        text:
                                            "Longitude: ${widget.longitude != 0.000000000000 ? widget.longitude : 0.000000000000}",
                                        fontSize: 14,
                                        textAlign: TextAlign.center,
                                        color: ColorTheme.textColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomButton(
                              text: "Add to collection", onPressed: () {}),
                        )
                      ],
                    ),
                  ),
                ],
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
      borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0)),
      child: ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOver),
        child: Image.memory(
          bytes,
          fit: BoxFit.cover,
          colorBlendMode: BlendMode.srcOver,
        ),
      ),
    );
  }
}
