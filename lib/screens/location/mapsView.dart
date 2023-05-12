import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fooddelievery/screens/location/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(23.0225, 72.5714),
    zoom: 14.4746,
  );

  static const CameraPosition _home = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(23.1072, 72.5722),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  //For Home Location
  static const Marker homeMarker = Marker(
      markerId: MarkerId('marker'),
      infoWindow: InfoWindow(title: 'Home'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(23.1072, 72.5722));

  //For Target Location
  static Marker targetMarker = Marker(
      markerId: MarkerId('targetMarker'),
      infoWindow: InfoWindow(title: 'Target'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: LatLng(28.1072, 74.5722));

  //For Polylines
  static final Polyline polyline = Polyline(
      polylineId: PolylineId('hometoTargetPolyline'),
      width: 5,
      points: [LatLng(23.1072, 72.5722), LatLng(28.1072, 74.5722)]);

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Google maps'),
        backgroundColor: Color(0xFFD96704),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: searchController,
                onChanged: (value) {
                  print(value);
                },
                onSubmitted: (value) {
                  LocationService().getPlaceID(value);
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Search...'),
              )),
            ],
          ),
          Expanded(
            flex: 10,
            child: GoogleMap(
              mapType: MapType.normal,
              markers: {homeMarker, targetMarker},
              polylines: {polyline},
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToTheLake,
        backgroundColor: Color(0xFFD96704),
        child: const Icon(
          Icons.home_filled,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_home));
  }
}
