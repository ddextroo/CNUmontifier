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
  Location location = new Location();
  LatLng? _currentPosition;

  Future<bool> requestPermission() async {
    final permission = await location.requestPermission();
    return permission == PermissionStatus.granted;
  }

  @override
  void initState() {
    super.initState();
    requestPermission().then((granted) {
      if (granted) {
        location.onLocationChanged.listen((LocationData currentLocation) {
          setState(() {
            _currentPosition =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition != null
          ? GoogleMap(
              zoomControlsEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 18,
              ),
              markers: {
                // Marker(
                //   icon: BitmapDescriptor.defaultMarkerWithHue(
                //     BitmapDescriptor.hueGreen,
                //   ),
                //   markerId: MarkerId("source"),
                //   position: _currentPosition!,
                // ),
                // Marker(
                //   icon: BitmapDescriptor.defaultMarkerWithHue(
                //     BitmapDescriptor.hueRed,
                //   ),
                //   markerId: MarkerId("current"),
                //   position: _currentPosition!,
                // ),
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
