import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnumontifier/service/auth_service.dart';
import 'package:cnumontifier/service/leaf_collection_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
  Location location = Location();

  double? currentLatitude = 0;
  double? currentLongitude = 0;

  Future<bool> requestPermission() async {
    final permission = await location.requestPermission();
    return permission == PermissionStatus.granted;
  }

  @override
  void initState() {
    super.initState();
    requestPermission().then((granted) {
      if (granted) {
        if (currentLatitude == 0 && currentLongitude == 0) {
          location.onLocationChanged.listen((LocationData currentLocation) {
            setState(() {
              currentLatitude = currentLocation.latitude;
              currentLongitude = currentLocation.longitude;
            });
          });
        }
      }
    });
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
            return _currentPosition != null
                ? GoogleMap(
                    zoomControlsEnabled: true,
                    tiltGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentLatitude!, currentLongitude!),
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
