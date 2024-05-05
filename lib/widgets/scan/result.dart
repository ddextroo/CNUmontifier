import 'dart:convert';
import 'dart:typed_data';

import 'package:cnumontifier/controller/classify_image_controller.dart';
import 'package:cnumontifier/view/select_map.dart';
import 'package:cnumontifier/widgets/CustomText.dart';
import 'package:cnumontifier/widgets/button.dart';
import 'package:cnumontifier/widgets/colors.dart';
import 'package:cnumontifier/service/leaf_collection_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

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
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;

  String? _userId;
  LeafService leafService = LeafService();
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchUserId();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  Future<void> _fetchUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
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
                                    text: "Shape",
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
                                    text: "Elliptic",
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
                                    text: "Leaf Area",
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
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tempor elit non tellus bibendum porttitor. In vitae odio semper, porta mauris ut, finibus quam. Aliquam volutpat augue eget quam tincidunt, vel accumsan quam varius. Mauris placerat quam sem, in auctor risus consectetur ac. Integer feugiat mi at facilisis maximus. Proin posuere molestie sapien sed congue. In hac habitasse platea dictumst. Integer at odio eget est malesuada lacinia vel non arcu. Aliquam nulla est, congue et lectus quis, hendrerit porta felis. Aliquam iaculis orci eu dolor varius finibus. Suspendisse ac tortor molestie, hendrerit tellus mattis, commodo sapien. Maecenas eget faucibus tellus, ac auctor leo. Nulla facilisi. Curabitur felis risus, laoreet pulvinar ex nec, porttitor laoreet nulla.""",
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
                                      : currentLatitude,
                                  longitude: widget.longitude != 0
                                      ? widget.longitude
                                      : currentLongitude,
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
                                            "Latitude: ${widget.latitude != 0 ? widget.latitude : currentLatitude}",
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
                                            "Longitude: ${widget.longitude != 0 ? widget.longitude : currentLongitude}",
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
                              text: "Add to collection",
                              onPressed: () {
                                if (_userId != null) {
                                  leafService.leafStore(
                                    _userId,
                                    widget.image,
                                    31,
                                    currentLatitude,
                                    currentLongitude,
                                    "ambot",
                                  );
                                }
                              }),
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
