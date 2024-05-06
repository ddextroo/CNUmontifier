import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnumontifier/service/auth_service.dart';
import 'package:cnumontifier/service/leaf_collection_service.dart';
import 'package:cnumontifier/widgets/CustomText.dart';
import 'package:cnumontifier/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer();
  AuthService authService = AuthService();
  LeafService leafService = LeafService();

  double? currentLatitude = 0;
  double? currentLongitude = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

  void _showModal(BuildContext context, DocumentSnapshot leafDoc) async {
    String uid = leafDoc['uid'];
    DocumentSnapshot? userDoc = await authService.getUserInfo(uid);
    final GoogleMapController controller = await _controller.future;
    LatLng markerLocation = LatLng(leafDoc["latitude"], leafDoc["longitude"]);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext modalContext) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Base64ImageWidget(
                  base64Image: leafDoc["leafImage"],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                              NetworkImage(userDoc?["avatar"] ?? ''),
                          backgroundColor: Colors.transparent,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: userDoc?["fullname"] ?? '',
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                  text: userDoc?["email"] ?? '',
                                  textAlign: TextAlign.start),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: CustomText(
                        text: "${leafDoc["leafName"]}",
                        textAlign: TextAlign.center,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                text: "Characteristics",
                                textAlign: TextAlign.left,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
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
                                    text: "${leafDoc["leafAccuracy"]}",
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
                            value: leafDoc["leafAccuracy"],
                            divisions: 4,
                            onChanged: (double value) {},
                            label: "${leafDoc["leafName"]}",
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
                                    text: "${leafDoc["leafShape"]}",
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
                                    text: "${leafDoc["leafArea"]}",
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
                                    text: "Latitude",
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
                                    text: "${leafDoc["latitude"]}",
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
                                    text: "Longitude",
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
                                    text: "${leafDoc["longitude"]}",
                                    textAlign: TextAlign.left,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    controller.animateCamera(CameraUpdate.newLatLngZoom(markerLocation, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: leafService.getLeafInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Error retrieving leaf information.'));
          } else {
            var leafDocs = snapshot.data!;
            return GoogleMap(
              zoomControlsEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(currentLatitude!, currentLongitude!),
                zoom: 7,
              ),
              markers: leafDocs
                  .map((doc) => Marker(
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueGreen),
                        markerId: MarkerId(doc.id),
                        position: LatLng(doc["latitude"], doc["longitude"]),
                        onTap: () => _showModal(context, doc),
                      ))
                  .toSet(),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
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
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOver),
      child: Image.memory(
        bytes,
        fit: BoxFit.cover,
        colorBlendMode: BlendMode.srcOver,
      ),
    );
  }
}
