import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class LocationService {
  final String key = 'AIzaSyAV1M74RGvFX9gdOT4qpCvBhW5X1XJgUa0';

  Future<String> getPlaceID(String input) async {
    print(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?input=$input&inputtype=textquery&key=AIzaSyAV1M74RGvFX9gdOT4qpCvBhW5X1XJgUa0';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    print(json);
    var placeID = json['place_id'] as String;
    print(placeID);
    return placeID;
  }

  // Future<Map<String, dynamic>> getPlace(String input) async {
  //   return
  // }
}
