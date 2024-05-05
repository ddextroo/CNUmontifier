import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnumontifier/service/auth_service.dart';
import 'package:cnumontifier/service/leaf_collection_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  LatLng? _currentPosition;
  AuthService authService = AuthService();
  LeafService leafService = LeafService();

  double currentLatitude = 0.0;
  double currentLongitude = 0.0;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _getCurrentLocation();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      if (mounted) {
        setState(() {
          currentLatitude = position.latitude;
          currentLongitude = position.longitude;
        });
      }
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: leafService.getLeafInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(child: Text('Error retrieving leaf information.'));
          } else {
            var leafDocs = snapshot.data!;
            return _currentPosition != null
                ? GoogleMap(
                    zoomControlsEnabled: true,
                    tiltGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          leafDocs[0]["latitude"],
                          leafDocs[0][
                              "longitude"]), // Just an example to get the first document's position
                      zoom: 30,
                    ),
                    markers: leafDocs
                        .map((doc) => Marker(
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueGreen,
                              ),
                              markerId: MarkerId(doc["uid"]),
                              position:
                                  LatLng(doc["latitude"], doc["longitude"]),
                            ))
                        .toSet(),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  )
                : Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
