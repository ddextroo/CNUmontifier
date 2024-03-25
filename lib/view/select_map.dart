import 'package:cnumontifier/widgets/button.dart';
import 'package:cnumontifier/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class SelectMap extends StatefulWidget {
  @override
  _SelectMapState createState() => _SelectMapState();
}

class _SelectMapState extends State<SelectMap> {
  Set<Marker> _markers = {};
  late GoogleMapController _mapController;

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

  void _onMapTap(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(
            position.latitude.toString() + position.longitude.toString()),
        position: position,
      ));
    });
    _showMarkerInfo(position);
  }

  void _showMarkerInfo(LatLng position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(
            text: 'Marker Information',
            textAlign: TextAlign.start,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          content: CustomText(
            text:
                'Latitude: ${position.latitude}\nLongitude: ${position.longitude}',
            textAlign: TextAlign.start,
            fontSize: 14,
          ),
          actions: <Widget>[
            CustomButton(
              text: 'Cancel',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CustomButton(
              text: 'Proceed',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Select place", textAlign: TextAlign.center),
      ),
      body: GoogleMap(
        zoomControlsEnabled: true,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 15,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        onTap: _onMapTap,
      ),
    );
  }
}
