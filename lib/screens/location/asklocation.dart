import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fooddelievery/screens/bottomnavigation.dart';
import 'package:location/location.dart';

class AskLocation extends StatefulWidget {
  const AskLocation({super.key});

  @override
  State<AskLocation> createState() => _AskLocationState();
}

class _AskLocationState extends State<AskLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What's your location?",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text(
                      "We need your location to show available restaurant & products.",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                    ),
                    Image.asset(
                      'lib/assets/Images/illustrations/location.png',
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Bounce(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 45,
                            decoration: const BoxDecoration(
                                color: Color(0xFFD96704),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Center(
                              child: Text(
                                'Allow location access',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          duration: const Duration(milliseconds: 110),
                          onPressed: () {
                            openLocationSettings().whenComplete(() {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomNavigation()),
                                  (route) => false);
                            });
                          }),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  openLocationSettings() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      } else {
        return Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BottomNavigation()));
      }
    }

    _locationData = await location.getLocation();

    // location.enableBackgroundMode(enable: true);

    location.onLocationChanged.listen((event) {
      print(event);
    });
  }
}
